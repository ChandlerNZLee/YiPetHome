import { BadRequestException, Body, Controller, Delete, Get, Headers, Param, ParseIntPipe, Post, Put, Query } from '@nestjs/common';

import { AppointmentsService } from './appointments.service';
import { CreateAppointmentDto } from './dto/create-appointment.dto';
import { UpdateAppointmentDto } from './dto/update-appointment.dto';
import { GetAppointmentAvailabilityDto } from './dto/get-appointment-availability.dto';
import { RescheduleAppointmentDto } from './dto/reschedule-appointment.dto';

@Controller('appointments')
export class AppointmentsController {
  constructor(
    private readonly appointmentsService: AppointmentsService,
  ) { }

  @Post()
  async create(
    @Body() createAppointmentDto: CreateAppointmentDto,
  ) {
    return this.appointmentsService.create(createAppointmentDto);
  }

  @Get()
  async findAll() {
    return this.appointmentsService.findAll();
  }

  @Get('availability')
  async getAvailability(
    @Query() query: GetAppointmentAvailabilityDto,
  ) {
    return this.appointmentsService.getAvailability(query);
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.appointmentsService.findOne(id);
  }

  @Put(':id/cancel')
  async cancel(
    @Param('id', ParseIntPipe) id: number,
    @Headers('x-user-id') userIdHeader: string,
  ) {
    const userId = Number(userIdHeader);

    if (
      !Number.isInteger(userId) ||
      userId <= 0
    ) {
      throw new BadRequestException(
        'Invalid user ID',
      );
    }

    return this.appointmentsService.cancel(
      id,
      userId,
    );
  }

  @Put(':id/reschedule')
  async reschedule(
    @Param('id', ParseIntPipe) id: number,
    @Headers('x-user-id') userIdHeader: string,
    @Body() dto: RescheduleAppointmentDto,
  ) {
    const userId = Number(userIdHeader);

    if (
      !Number.isInteger(userId) ||
      userId <= 0
    ) {
      throw new BadRequestException(
        'Invalid user ID',
      );
    }

    return this.appointmentsService.reschedule(
      id,
      userId,
      dto,
    );
  }

  @Put(':id/complete')
  async complete(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.appointmentsService.complete(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Headers('x-user-id') userIdHeader: string,
    @Body() dto: UpdateAppointmentDto,
  ) {
    const userId = Number(userIdHeader);

    if (
      !Number.isInteger(userId) ||
      userId <= 0
    ) {
      throw new BadRequestException(
        'Invalid user ID',
      );
    }

    return this.appointmentsService.update(
      id,
      userId,
      dto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.appointmentsService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.appointmentsService.removeAll();
  }
}
