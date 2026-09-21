import { BadRequestException, ConflictException, Injectable, NotFoundException } from '@nestjs/common';

import { Temporal } from 'temporal-polyfill';

import { PrismaService } from '../prisma/prisma.service';
import { PaymentsService } from '../payments/payments.service';

import type { CreateAppointmentDto } from './dto/create-appointment.dto';
import type { UpdateAppointmentDto } from './dto/update-appointment.dto';
import type { GetAppointmentAvailabilityDto } from './dto/get-appointment-availability.dto';
import { RescheduleAppointmentDto } from './dto/reschedule-appointment.dto';

import { AppointmentStatus } from './enums/appointment-status.enum';
import { PAYMENT_STATUS } from '../payments/constants/payment-status.constant';

export interface AppointmentAvailabilitySlot {
  startAt: string;
  endAt: string;
  available: boolean;
}

export interface AppointmentAvailabilityResult {
  date: string;
  weekday: number;
  shopId: number;
  groomerId: number;
  servicePriceId: number;

  serviceId?: number;
  duration?: number;
  durationMinutes: number;
  price?: number;

  slots: AppointmentAvailabilitySlot[];
}

@Injectable()
export class AppointmentsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly paymentsService: PaymentsService,
  ) { }

  async create(dto: CreateAppointmentDto) {
    await this.expirePendingAppointments();

    const {
      userId,
      petId,
      shopId,
      groomerId,
      servicePriceId,
      startAt,
      notes,
    } = dto;

    // --------------------------------------------------
    // 1. Service Price
    // --------------------------------------------------

    const servicePrice =
      await this.prisma.db.orm.public.ServicePrices
        .where({
          id: servicePriceId,
        })
        .first();

    if (!servicePrice) {
      throw new NotFoundException('Service price not found');
    }

    const durationMinutes = servicePrice.duration * 30;

    if (durationMinutes <= 0) {
      throw new BadRequestException(
        'Service duration must be greater than 0',
      );
    }

    // --------------------------------------------------
    // 2. Groomer
    // --------------------------------------------------

    const groomer =
      await this.prisma.db.orm.public.Groomers
        .where({
          id: groomerId,
          shopId,
        })
        .first();

    if (!groomer) {
      throw new NotFoundException(
        'Groomer not found in this shop',
      );
    }

    // --------------------------------------------------
    // 3. Pet
    // --------------------------------------------------

    const pet =
      await this.prisma.db.orm.public.Pets
        .where({
          id: petId,
          userId,
        })
        .first();

    if (!pet) {
      throw new NotFoundException(
        'Pet not found for this user',
      );
    }

    // --------------------------------------------------
    // 4. Calculate appointment time
    // --------------------------------------------------

    const appointmentStart = new Date(startAt);

    if (Number.isNaN(appointmentStart.getTime())) {
      throw new BadRequestException(
        'Invalid appointment start time',
      );
    }

    const appointmentEnd = new Date(
      appointmentStart.getTime() +
      durationMinutes * 60_000,
    );

    // 目前没有额外 buffer
    const blockingEnd = appointmentEnd;

    // --------------------------------------------------
    // 5. Re-check availability
    // --------------------------------------------------

    const localDate =
      this.formatAppointmentDate(
        appointmentStart,
      );

    const availability = await this.getAvailability({
      shopId,
      groomerId,
      servicePriceId,
      date: localDate,
    });

    const requestedSlot = availability.slots.find(
      (slot) =>
        new Date(slot.startAt).getTime() ===
        appointmentStart.getTime(),
    );

    if (!requestedSlot) {
      throw new BadRequestException(
        'Selected appointment time is not part of the groomer schedule',
      );
    }

    console.log('CREATE AVAILABILITY CHECK', {
      requestedStartAt:
        appointmentStart.toISOString(),

      localDate,

      requestedSlot,
    });

    if (!requestedSlot.available) {
      throw new ConflictException(
        'Selected appointment time is no longer available',
      );
    }

    // --------------------------------------------------
    // 6. Temporary payment lock
    // --------------------------------------------------

    const expiresAt = new Date(
      Date.now() + 10 * 60_000,
    );

    // --------------------------------------------------
    // 7. Build 30-minute database locks
    // --------------------------------------------------

    const lockStarts: Date[] = [];

    for (
      let lockTime = appointmentStart.getTime();
      lockTime < blockingEnd.getTime();
      lockTime += 30 * 60_000
    ) {
      lockStarts.push(new Date(lockTime));
    }

    // --------------------------------------------------
    // 8. Create appointment atomically
    // --------------------------------------------------

    try {
      const appointment =
        await this.prisma.db.transaction(async (tx) => {
          // 8.1 Appointment
          const createdAppointment =
            await tx.orm.public.Appointments.create({
              _type: 0,

              userId,
              petId,
              shopId,
              groomerId,

              startAt: Temporal.Instant.from(
                appointmentStart.toISOString(),
              ),

              endAt: Temporal.Instant.from(
                appointmentEnd.toISOString(),
              ),

              blockingEndAt: Temporal.Instant.from(
                blockingEnd.toISOString(),
              ),

              expiresAt: Temporal.Instant.from(
                expiresAt.toISOString(),
              ),

              originPrice: servicePrice.price,
              discount: 0,
              price: servicePrice.price,

              paymentStatus: 0,
              appointmentStatus:
                AppointmentStatus.PENDING_PAYMENT,

              notes: notes ?? '',
            });

          // 8.2 Service snapshot
          await tx.orm.public.AppointmentServices.create({
            appointmentId: createdAppointment.id,
            serviceId: servicePrice.serviceId,

            price: servicePrice.price,
            duration: servicePrice.duration,
          });

          // 8.3 Database appointment locks
          for (const lockStart of lockStarts) {
            await tx.orm.public.AppointmentLocks.create({
              appointmentId: createdAppointment.id,
              groomerId,

              slotStart: Temporal.Instant.from(
                lockStart.toISOString(),
              ),
            });
          }

          return createdAppointment;
        });

      return appointment;
    } catch (error: unknown) {
      if (
        typeof error === 'object' &&
        error !== null &&
        'sqlState' in error &&
        'constraint' in error &&
        error.sqlState === '23505' &&
        error.constraint === 'appointment_locks_pkey'
      ) {
        throw new ConflictException(
          'Selected appointment time is no longer available',
        );
      }

      console.error('Failed to create appointment:', error);

      throw error;
    }
  }

  private async expirePendingAppointments() {
    const pendingAppointments =
      await this.prisma.db.orm.public.Appointments
        .where({
          appointmentStatus:
            AppointmentStatus.PENDING_PAYMENT,
        })
        .all();

    const now = Date.now();

    for (const appointment of pendingAppointments) {
      if (!appointment.expiresAt) {
        continue;
      }

      if (
        appointment.expiresAt.epochMilliseconds >
        now
      ) {
        continue;
      }

      const payment =
        await this.prisma.db.orm.public.Payments
          .where({
            paymentType: 2,
            appointmentId: appointment.id,
          })
          .first();

      if (
        payment?.stripeCheckoutSessionId &&
        (
          payment.status === PAYMENT_STATUS.PENDING ||
          payment.status === PAYMENT_STATUS.FAILED
        )
      ) {
        continue;
      }

      await this.prisma.db.transaction(async (tx) => {
        const current =
          await tx.orm.public.Appointments
            .where({
              id: appointment.id,
            })
            .first();

        // 防止扫描之后状态已经发生变化
        if (
          !current ||
          current.appointmentStatus !==
          AppointmentStatus.PENDING_PAYMENT ||
          !current.expiresAt ||
          current.expiresAt.epochMilliseconds >
          Date.now()
        ) {
          return;
        }

        await tx.orm.public.Appointments
          .where({
            id: current.id,
          })
          .update({
            appointmentStatus:
              AppointmentStatus.EXPIRED,
          });

        await tx.orm.public.AppointmentLocks
          .where({
            appointmentId: current.id,
          })
          .deleteAll();
      });
    }
  }

  findAll() {
    return this.prisma.db.orm.public.Appointments.all();
  }

  async getAvailability(
    query: GetAppointmentAvailabilityDto,
  ): Promise<AppointmentAvailabilityResult> {
    await this.expirePendingAppointments();

    const {
      shopId,
      groomerId,
      servicePriceId,
      date,
    } = query;

    const servicePrice =
      await this.prisma.db.orm.public.ServicePrices
        .where({
          id: servicePriceId,
        })
        .first();

    if (!servicePrice) {
      throw new NotFoundException(
        'Service price not found',
      );
    }

    const durationMinutes =
      servicePrice.duration * 30;

    const availability =
      await this.getAvailableSlots(
        shopId,
        groomerId,
        date,
        durationMinutes,
      );

    return {
      date,
      weekday: availability.weekday,
      shopId,
      groomerId,
      servicePriceId,

      serviceId:
        servicePrice.serviceId,

      duration:
        servicePrice.duration,

      durationMinutes,

      price:
        servicePrice.price,

      slots:
        availability.slots,
    };
  }

  private async getAvailableSlots(
    shopId: number,
    groomerId: number,
    date: string,
    durationMinutes: number,
    excludeAppointmentId?: number,
  ): Promise<{
    weekday: number;
    slots: Array<{
      startAt: string;
      endAt: string;
      available: boolean;
    }>;
  }> {
    // --------------------------------------------------
    // 1. Groomer
    // --------------------------------------------------

    const groomer =
      await this.prisma.db.orm.public.Groomers
        .where({
          id: groomerId,
          shopId,
        })
        .first();

    if (!groomer) {
      throw new NotFoundException(
        'Groomer not found in this shop',
      );
    }

    if (durationMinutes <= 0) {
      throw new BadRequestException(
        'Service duration must be greater than 0',
      );
    }

    // --------------------------------------------------
    // 2. Date / weekday
    // --------------------------------------------------

    const requestedDate =
      new Date(`${date}T12:00:00`);

    if (Number.isNaN(requestedDate.getTime())) {
      throw new BadRequestException(
        'Invalid appointment date',
      );
    }

    const jsDay = requestedDate.getDay();
    const weekday = jsDay === 0 ? 7 : jsDay;

    // --------------------------------------------------
    // 3. Groomer working slots
    // --------------------------------------------------

    const allGroomerSlots =
      await this.prisma.db.orm.public.GroomerSlots
        .where({
          groomerId,
          enabled: true,
        })
        .all();

    const weekdaySlots =
      allGroomerSlots.filter(
        (slot) =>
          slot.weekday === weekday,
      );

    const genericSlots =
      allGroomerSlots.filter(
        (slot) =>
          slot.weekday === null,
      );

    const groomerSlots =
      weekdaySlots.length > 0
        ? weekdaySlots
        : genericSlots;

    if (groomerSlots.length === 0) {
      return {
        weekday,
        slots: [],
      };
    }

    // --------------------------------------------------
    // 4. Existing appointments
    // --------------------------------------------------

    const appointments =
      await this.prisma.db.orm.public.Appointments
        .where({
          groomerId,
        })
        .all();

    const now = new Date();

    const appointmentsForDate =
      appointments.filter(
        (appointment) => {
          // Reschedule:
          // ignore the appointment being moved.
          if (
            excludeAppointmentId !== undefined &&
            appointment.id ===
            excludeAppointmentId
          ) {
            return false;
          }

          const startAt =
            new Date(
              appointment.startAt
                .epochMilliseconds,
            );

          const appointmentLocalDate =
            new Intl.DateTimeFormat('en-CA', {
              timeZone: 'Pacific/Auckland',
              year: 'numeric',
              month: '2-digit',
              day: '2-digit',
            }).format(startAt);

          if (appointmentLocalDate !== date) {
            return false;
          }

          switch (
          appointment.appointmentStatus
          ) {
            case AppointmentStatus.CONFIRMED:
            case AppointmentStatus.COMPLETED:
              return true;

            case AppointmentStatus.PENDING_PAYMENT:
              return (
                appointment.expiresAt !==
                null &&
                new Date(
                  appointment.expiresAt
                    .epochMilliseconds,
                ) > now
              );

            case AppointmentStatus.CANCELLED:
            case AppointmentStatus.EXPIRED:
              return false;

            default:
              return false;
          }
        },
      );

    // --------------------------------------------------
    // 5. Generate candidate slots
    // --------------------------------------------------

    const result: Array<{
      startAt: string;
      endAt: string;
      available: boolean;
    }> = [];

    const sortedGroomerSlots =
      [...groomerSlots].sort(
        (a, b) =>
          this.combineDateAndTime(
            date,
            a.startTime,
          ).getTime() -
          this.combineDateAndTime(
            date,
            b.startTime,
          ).getTime(),
      );

    for (
      let i = 0;
      i < sortedGroomerSlots.length;
      i++
    ) {
      const firstSlot =
        sortedGroomerSlots[i];

      const candidateStart =
        this.combineDateAndTime(
          date,
          firstSlot.startTime,
        );

      const candidateEnd =
        new Date(
          candidateStart.getTime() +
          durationMinutes * 60_000,
        );

      let coveredUntil =
        candidateStart;

      let hasContinuousCoverage =
        false;

      for (
        let j = i;
        j < sortedGroomerSlots.length;
        j++
      ) {
        const slot =
          sortedGroomerSlots[j];

        const slotStart =
          this.combineDateAndTime(
            date,
            slot.startTime,
          );

        const slotEnd =
          this.combineDateAndTime(
            date,
            slot.endTime,
          );

        if (
          slotStart.getTime() !==
          coveredUntil.getTime()
        ) {
          break;
        }

        coveredUntil = slotEnd;

        if (
          coveredUntil >=
          candidateEnd
        ) {
          hasContinuousCoverage =
            true;
          break;
        }
      }

      if (!hasContinuousCoverage) {
        continue;
      }

      const hasConflict =
        appointmentsForDate.some(
          (appointment) => {
            const existingStart =
              new Date(
                appointment.startAt
                  .epochMilliseconds,
              );

            const existingEnd =
              new Date(
                appointment.blockingEndAt
                  .epochMilliseconds,
              );

            return this.hasTimeOverlap(
              candidateStart,
              candidateEnd,
              existingStart,
              existingEnd,
            );
          },
        );

      if (hasConflict) {
        console.log(
          'SLOT CONFLICT',
          candidateStart.toISOString(),
          appointmentsForDate.map(
            (appointment) => ({
              id: appointment.id,
              status:
                appointment.appointmentStatus,
              startAt:
                new Date(
                  appointment.startAt
                    .epochMilliseconds,
                ).toISOString(),
              blockingEndAt:
                new Date(
                  appointment.blockingEndAt
                    .epochMilliseconds,
                ).toISOString(),
              expiresAt:
                appointment.expiresAt
                  ? new Date(
                    appointment.expiresAt
                      .epochMilliseconds,
                  ).toISOString()
                  : null,
            }),
          ),
        );
      }

      result.push({
        startAt:
          candidateStart.toISOString(),
        endAt:
          candidateEnd.toISOString(),
        available: !hasConflict,
      });
    }

    result.sort(
      (a, b) =>
        new Date(a.startAt).getTime() -
        new Date(b.startAt).getTime(),
    );

    return {
      weekday,
      slots: result,
    };
  }

  private combineDateAndTime(
    date: string,
    time: string,
  ): Date {
    const normalizedTime =
      time.length === 5 ? `${time}:00` : time;

    const value = new Date(
      `${date}T${normalizedTime}`,
    );

    if (Number.isNaN(value.getTime())) {
      throw new BadRequestException(
        `Invalid time: ${time}`,
      );
    }

    return value;
  }

  private formatAppointmentDate(
    date: Date,
  ): string {
    return new Intl.DateTimeFormat(
      'en-CA',
      {
        timeZone: 'Pacific/Auckland',
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
      },
    ).format(date);
  }

  private hasTimeOverlap(
    startA: Date,
    endA: Date,
    startB: Date,
    endB: Date,
  ): boolean {
    return startA < endB && endA > startB;
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.Appointments.where({ id }).first();
  }

  async cancel(
    id: number,
    userId: number,
  ) {
    const appointment =
      await this.prisma.db.orm.public.Appointments
        .where({ id })
        .first();

    if (!appointment) {
      throw new NotFoundException(
        'Appointment not found',
      );
    }

    // --------------------------------------------------
    // Ownership
    // --------------------------------------------------

    if (appointment.userId !== userId) {
      throw new BadRequestException(
        'This appointment does not belong to the current user',
      );
    }

    // --------------------------------------------------
    // Status validation
    // --------------------------------------------------

    if (
      appointment.appointmentStatus ===
      AppointmentStatus.CANCELLED
    ) {
      throw new BadRequestException(
        'Appointment is already cancelled',
      );
    }

    if (
      appointment.appointmentStatus ===
      AppointmentStatus.EXPIRED
    ) {
      throw new BadRequestException(
        'Expired appointment cannot be cancelled',
      );
    }

    if (
      appointment.appointmentStatus ===
      AppointmentStatus.COMPLETED
    ) {
      throw new BadRequestException(
        'Completed appointment cannot be cancelled',
      );
    }

    if (
      appointment.appointmentStatus ===
      AppointmentStatus.CONFIRMED
    ) {
      throw new BadRequestException(
        'Paid confirmed appointments must be cancelled through the refund flow',
      );
    }

    // --------------------------------------------------
    // Atomic cancellation
    // --------------------------------------------------

    const cancelledAppointment =
      await this.prisma.db.transaction(
        async (tx) => {
          const current =
            await tx.orm.public.Appointments
              .where({ id })
              .first();

          if (!current) {
            throw new NotFoundException(
              'Appointment not found',
            );
          }

          if (current.userId !== userId) {
            throw new BadRequestException(
              'This appointment does not belong to the current user',
            );
          }

          if (
            current.appointmentStatus !==
            AppointmentStatus.PENDING_PAYMENT
          ) {
            throw new ConflictException(
              'Appointment can no longer be cancelled',
            );
          }

          const updatedAppointment =
            await tx.orm.public.Appointments
              .where({ id })
              .update({
                appointmentStatus:
                  AppointmentStatus.CANCELLED,
              });

          await tx.orm.public.AppointmentLocks
            .where({
              appointmentId: id,
            })
            .deleteAll();

          return updatedAppointment;
        },
      );

    // DB cancellation has committed.
    // Now expire any active Stripe Checkout Sessions.
    await this.paymentsService
      .expireAppointmentCheckout(id);

    return cancelledAppointment;
  }

  async reschedule(
    id: number,
    userId: number,
    dto: RescheduleAppointmentDto,
  ) {
    // --------------------------------------------------
    // 1. Appointment
    // --------------------------------------------------

    const appointment =
      await this.prisma.db.orm.public.Appointments
        .where({ id })
        .first();

    if (!appointment) {
      throw new NotFoundException(
        'Appointment not found',
      );
    }

    if (appointment.userId !== userId) {
      throw new BadRequestException(
        'This appointment does not belong to the current user',
      );
    }

    if (
      appointment.appointmentStatus !==
      AppointmentStatus.CONFIRMED
    ) {
      throw new BadRequestException(
        'Only confirmed appointments can be rescheduled',
      );
    }

    // --------------------------------------------------
    // 2. Appointment service snapshot
    // --------------------------------------------------

    const appointmentService =
      await this.prisma.db.orm.public.AppointmentServices
        .where({
          appointmentId: id,
        })
        .first();

    if (!appointmentService) {
      throw new NotFoundException(
        'Appointment service not found',
      );
    }

    const durationMinutes =
      appointmentService.duration * 30;

    if (durationMinutes <= 0) {
      throw new BadRequestException(
        'Appointment duration must be greater than 0',
      );
    }

    // --------------------------------------------------
    // 3. Parse new start time
    // --------------------------------------------------

    const newStartAt =
      new Date(dto.startAt);

    if (
      Number.isNaN(
        newStartAt.getTime(),
      )
    ) {
      throw new BadRequestException(
        'Invalid appointment start time',
      );
    }

    if (
      newStartAt.getTime() ===
      appointment.startAt.epochMilliseconds
    ) {
      throw new BadRequestException(
        'New appointment time is the same as the current time',
      );
    }

    const newEndAt =
      new Date(
        newStartAt.getTime() +
        durationMinutes * 60_000,
      );

    /*
     * Current system has no additional buffer.
     * If buffer is introduced later,
     * blockingEndAt should include it here.
     */
    const newBlockingEndAt =
      newEndAt;

    // --------------------------------------------------
    // 4. Availability check
    // --------------------------------------------------

    const date =
      this.formatAppointmentDate(
        newStartAt,
      );

    const availability =
      await this.getAvailableSlots(
        appointment.shopId,
        appointment.groomerId,
        date,
        durationMinutes,
        appointment.id,
      );

    const selectedSlot =
      availability.slots.find(
        (slot) =>
          new Date(
            slot.startAt,
          ).getTime() ===
          newStartAt.getTime(),
      );

    if (
      !selectedSlot ||
      !selectedSlot.available
    ) {
      throw new ConflictException(
        'Selected appointment time is not available',
      );
    }

    // --------------------------------------------------
    // 5. Generate new locks
    // --------------------------------------------------

    const lockStarts: Date[] = [];

    for (
      let time =
        newStartAt.getTime();
      time <
      newBlockingEndAt.getTime();
      time += 30 * 60_000
    ) {
      lockStarts.push(
        new Date(time),
      );
    }

    // --------------------------------------------------
    // 6. Atomic reschedule
    // --------------------------------------------------

    try {
      return await this.prisma.db.transaction(
        async (tx) => {
          /*
           * Re-read inside transaction.
           *
           * Availability above is only a user-friendly
           * pre-check. AppointmentLocks remains the
           * final concurrency protection.
           */
          const current =
            await tx.orm.public.Appointments
              .where({ id })
              .first();

          if (!current) {
            throw new NotFoundException(
              'Appointment not found',
            );
          }

          if (
            current.userId !== userId
          ) {
            throw new BadRequestException(
              'This appointment does not belong to the current user',
            );
          }

          if (
            current.appointmentStatus !==
            AppointmentStatus.CONFIRMED
          ) {
            throw new ConflictException(
              'Appointment can no longer be rescheduled',
            );
          }

          // --------------------------------------
          // A. Delete old locks
          // --------------------------------------

          await tx.orm.public.AppointmentLocks
            .where({
              appointmentId: id,
            })
            .deleteAll();

          // --------------------------------------
          // B. Acquire new locks
          // --------------------------------------

          for (
            const lockStart of
            lockStarts
          ) {
            await tx.orm.public.AppointmentLocks
              .create({
                appointmentId:
                  id,

                groomerId:
                  current.groomerId,

                slotStart:
                  Temporal.Instant.from(
                    lockStart.toISOString(),
                  ),
              });
          }

          // --------------------------------------
          // C. Update appointment
          // --------------------------------------

          return tx.orm.public.Appointments
            .where({ id })
            .update({
              startAt:
                Temporal.Instant.from(
                  newStartAt.toISOString(),
                ),

              endAt:
                Temporal.Instant.from(
                  newEndAt.toISOString(),
                ),

              blockingEndAt:
                Temporal.Instant.from(
                  newBlockingEndAt.toISOString(),
                ),
            });
        },
      );
    } catch (error: unknown) {
      /*
       * Another request may have acquired one of the
       * requested locks after our availability check.
       */
      if (
        typeof error === 'object' &&
        error !== null &&
        'sqlState' in error &&
        'constraint' in error &&
        error.sqlState === '23505' &&
        error.constraint ===
        'appointment_locks_pkey'
      ) {
        throw new ConflictException(
          'Selected appointment time is no longer available',
        );
      }

      throw error;
    }
  }

  async complete(id: number) {
    const appointment =
      await this.prisma.db.orm.public.Appointments
        .where({ id })
        .first();

    if (!appointment) {
      throw new NotFoundException(
        'Appointment not found',
      );
    }

    // --------------------------------------------------
    // Only CONFIRMED can become COMPLETED
    // --------------------------------------------------

    if (
      appointment.appointmentStatus !==
      AppointmentStatus.CONFIRMED
    ) {
      throw new BadRequestException(
        'Only confirmed appointments can be completed',
      );
    }

    if (
      appointment.paymentStatus !==
      PAYMENT_STATUS.SUCCEEDED
    ) {
      throw new BadRequestException(
        'Appointment payment has not been completed',
      );
    }

    // --------------------------------------------------
    // Appointment must already have ended
    // --------------------------------------------------

    const endAt =
      new Date(
        appointment.endAt.epochMilliseconds,
      );

    if (endAt.getTime() > Date.now()) {
      throw new BadRequestException(
        'Appointment cannot be completed before it has ended',
      );
    }

    // --------------------------------------------------
    // Complete
    // --------------------------------------------------

    return this.prisma.db.orm.public.Appointments
      .where({ id })
      .update({
        appointmentStatus:
          AppointmentStatus.COMPLETED,
      });
  }

  async update(
    id: number,
    userId: number,
    dto: UpdateAppointmentDto,
  ) {
    const appointment =
      await this.prisma.db.orm.public.Appointments
        .where({ id })
        .first();

    if (!appointment) {
      throw new NotFoundException(
        'Appointment not found',
      );
    }

    if (appointment.userId !== userId) {
      throw new BadRequestException(
        'This appointment does not belong to the current user',
      );
    }

    if (
      appointment.appointmentStatus ===
      AppointmentStatus.CANCELLED
    ) {
      throw new BadRequestException(
        'Cancelled appointment cannot be updated',
      );
    }

    if (
      appointment.appointmentStatus ===
      AppointmentStatus.EXPIRED
    ) {
      throw new BadRequestException(
        'Expired appointment cannot be updated',
      );
    }

    if (
      appointment.appointmentStatus ===
      AppointmentStatus.COMPLETED
    ) {
      throw new BadRequestException(
        'Completed appointment cannot be updated',
      );
    }

    return this.prisma.db.orm.public.Appointments
      .where({ id })
      .update({
        notes: dto.notes,
      });
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.Appointments.where({ id }).delete();
    return {
      message: 'Appointment deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.Appointments.where({}).deleteAndCount();
    return {
      message: 'All appointments deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
