import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { AppointmentSlotsService } from './appointment-slots.service';
import { CreateAppointmentSlotDto } from './dto/create-appointment-slot.dto';
import { UpdateAppointmentSlotDto } from './dto/update-appointment-slot.dto';

@Controller('appointment-slots')
export class AppointmentSlotsController {
  constructor(
    private readonly appointmentSlotsService: AppointmentSlotsService,
  ) {}

  @Post()
  async create(
    @Body() createAppointmentSlotDto: CreateAppointmentSlotDto,
  ) {
    return this.appointmentSlotsService.create(createAppointmentSlotDto);
  }

  @Get()
  async findAll() {
    return this.appointmentSlotsService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.appointmentSlotsService.findOne(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateAppointmentSlotDto: UpdateAppointmentSlotDto,
  ) {
    return this.appointmentSlotsService.update(
      id,
      updateAppointmentSlotDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.appointmentSlotsService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.appointmentSlotsService.removeAll();
  }
}
