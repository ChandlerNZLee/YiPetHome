import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { AppointmentServicesService } from './appointment-services.service';
import { CreateAppointmentServiceDto } from './dto/create-appointment-service.dto';
import { UpdateAppointmentServiceDto } from './dto/update-appointment-service.dto';

@Controller('appointment-services')
export class AppointmentServicesController {
  constructor(
    private readonly appointmentServicesService: AppointmentServicesService,
  ) {}

  @Post()
  async create(
    @Body() createAppointmentServiceDto: CreateAppointmentServiceDto,
  ) {
    return this.appointmentServicesService.create(createAppointmentServiceDto);
  }

  @Get()
  async findAll() {
    return this.appointmentServicesService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.appointmentServicesService.findOne(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateAppointmentServiceDto: UpdateAppointmentServiceDto,
  ) {
    return this.appointmentServicesService.update(
      id,
      updateAppointmentServiceDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.appointmentServicesService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.appointmentServicesService.removeAll();
  }
}
