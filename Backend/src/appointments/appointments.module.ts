import { Module } from '@nestjs/common';

import { PaymentsModule } from '../payments/payments.module';

import { AppointmentsController } from './appointments.controller';
import { AppointmentsService } from './appointments.service';
import { AppointmentServicesController } from './appointment-services/appointment-services.controller';
import { AppointmentServicesService } from './appointment-services/appointment-services.service';

@Module({
  imports: [PaymentsModule],
  controllers: [AppointmentsController, AppointmentServicesController],
  providers: [AppointmentsService, AppointmentServicesService],
  exports: [AppointmentsService, AppointmentServicesService],
})
export class AppointmentsModule { }
