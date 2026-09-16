import { Injectable } from '@nestjs/common';

import { PrismaService } from '../../prisma/prisma.service';

import type { CreateAppointmentSlotDto } from './dto/create-appointment-slot.dto';
import type { UpdateAppointmentSlotDto } from './dto/update-appointment-slot.dto';

@Injectable()
export class AppointmentSlotsService {
  constructor(private readonly prisma: PrismaService) { }

  create(createAppointmentSlotDto: CreateAppointmentSlotDto) {
    return this.prisma.db.orm.public.AppointmentSlots.create(createAppointmentSlotDto);
  }

  findAll() {
    return this.prisma.db.orm.public.AppointmentSlots.all();
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.AppointmentSlots.where({ id }).first();
  }

  update(id: number, updateAppointmentSlotDto: UpdateAppointmentSlotDto) {
    return this.prisma.db.orm.public.AppointmentSlots.where({ id }).update(updateAppointmentSlotDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.AppointmentSlots.where({ id }).delete();
    return {
      message: 'Appointment slot deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.AppointmentSlots.where({}).deleteAndCount();
    return {
      message: 'All appointment slots deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
