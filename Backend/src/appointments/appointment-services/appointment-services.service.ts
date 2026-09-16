import { Injectable } from '@nestjs/common';

import { PrismaService } from '../../prisma/prisma.service';

import type { CreateAppointmentServiceDto } from './dto/create-appointment-service.dto';
import type { UpdateAppointmentServiceDto } from './dto/update-appointment-service.dto';

@Injectable()
export class AppointmentServicesService {
  constructor(private readonly prisma: PrismaService) { }

  create(createAppointmentServiceDto: CreateAppointmentServiceDto) {
    return this.prisma.db.orm.public.AppointmentServices.create(createAppointmentServiceDto);
  }

  findAll() {
    return this.prisma.db.orm.public.AppointmentServices.all();
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.AppointmentServices.where({ id }).first;
  }

  update(id: number, updateAppointmentServiceDto: UpdateAppointmentServiceDto) {
    return this.prisma.db.orm.public.AppointmentServices.where({ id }).update(updateAppointmentServiceDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.AppointmentServices.where({ id }).delete();
    return {
      message: 'Appointment deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.AppointmentServices.where({}).deleteAndCount();
    return {
      message: 'All appointment services deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
