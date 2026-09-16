import { Type } from 'class-transformer';
import { IsInt, Min } from 'class-validator';

export class UpdateAppointmentServiceDto {
  @Type(() => Number)
  @IsInt({ message: 'Appointment ID must be an integer.' })
  @Min(0, { message: 'Appointment ID must be greater than or equal to 0.' })
  appointmentId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Service ID must be an integer.' })
  @Min(0, { message: 'Service ID must be greater than or equal to 0.' })
  serviceId!: number;
}
