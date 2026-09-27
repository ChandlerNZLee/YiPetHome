import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put, Query, Req, UseGuards } from '@nestjs/common';

import { JwtAuthGuard } from '../common/auth/jwt-auth.guard';
import type { AuthenticatedRequest } from '../common/auth/authenticated-request.interface';

import { AppointmentsService } from './appointments.service';
import { CreateAppointmentDto } from './dto/create-appointment.dto';
import { UpdateAppointmentDto } from './dto/update-appointment.dto';
import { GetAppointmentAvailabilityDto } from './dto/get-appointment-availability.dto';
import { RescheduleAppointmentDto } from './dto/reschedule-appointment.dto';

@Controller('appointments')
@UseGuards(JwtAuthGuard)
export class AppointmentsController {
  constructor(
    private readonly appointmentsService: AppointmentsService,
  ) { }

  @Post()

  async create(
    @Req() request: AuthenticatedRequest,
    @Body() createAppointmentDto: CreateAppointmentDto,
  ) {
    return this.appointmentsService.create(request.user, createAppointmentDto);
  }

  @Get()
  async findAll(
    @Req() request: AuthenticatedRequest,
  ) {
    return this.appointmentsService.findAll(request.user);
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
    @Req() request: AuthenticatedRequest,
  ) {
    return this.appointmentsService.findOne(id, request.user);
  }

  @Put(':id/cancel')
  async cancel(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ) {
    return this.appointmentsService.cancel(
      id,
      request.user,
    );
  }

  @Put(':id/reschedule')
  async reschedule(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
    @Body() dto: RescheduleAppointmentDto,
  ) {
    return this.appointmentsService.reschedule(
      id,
      request.user,
      dto,
    );
  }

  @Put(':id/complete')
  async complete(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ) {
    return this.appointmentsService.complete(id, request.user);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
    @Body() dto: UpdateAppointmentDto,
  ) {
    return this.appointmentsService.update(
      id,
      request.user,
      dto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ): Promise<{ message: string }> {
    return this.appointmentsService.remove(id, request.user);
  }

  @Delete()
  async removeAll(
    @Req() request: AuthenticatedRequest,
  ): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.appointmentsService.removeAll(request.user);
  }
}
