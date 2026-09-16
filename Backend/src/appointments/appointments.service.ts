import { Injectable } from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';

import type { CreateAppointmentDto } from './dto/create-appointment.dto';
import type { UpdateAppointmentDto } from './dto/update-appointment.dto';

@Injectable()
export class AppointmentsService {
  constructor(private readonly prisma: PrismaService) { }

  create(createAppointmentDto: CreateAppointmentDto) {
    return this.prisma.db.orm.public.Appointments.create(createAppointmentDto);
  }

  findAll() {
    return this.prisma.db.orm.public.Appointments.all();
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.Appointments.where({ id }).first();
  }

  update(id: number, updateAppointmentDto: UpdateAppointmentDto) {
    return this.prisma.db.orm.public.Appointments.where({ id }).update(updateAppointmentDto);
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
