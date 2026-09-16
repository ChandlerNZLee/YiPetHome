import { Module } from '@nestjs/common';

import { AppointmentsController } from './appointments.controller';
import { AppointmentsService } from './appointments.service';
import { AppointmentSlotsController } from './appointment-slots/appointment-slots.controller';
import { AppointmentSlotsService } from './appointment-slots/appointment-slots.service';
import { AppointmentServicesController } from './appointment-services/appointment-services.controller';
import { AppointmentServicesService } from './appointment-services/appointment-services.service';

@Module({
  controllers: [AppointmentsController, AppointmentSlotsController, AppointmentServicesController],
  providers: [AppointmentsService, AppointmentSlotsService, AppointmentServicesService],
  exports: [AppointmentsService, AppointmentSlotsService, AppointmentServicesService],
})
export class AppointmentsModule {}
