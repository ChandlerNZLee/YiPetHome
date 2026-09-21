import { Type } from 'class-transformer';
import { IsInt, IsNumber, Min } from 'class-validator';

export class CreateAppointmentServiceDto {
  @Type(() => Number)
  @IsInt({ message: 'Appointment ID must be an integer.' })
  @Min(0, { message: 'Appointment ID must be greater than or equal to 0.' })
  appointmentId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Service ID must be an integer.' })
  @Min(0, { message: 'Service ID must be greater than or equal to 0.' })
  serviceId!: number;

  @Type(() => Number)
  @IsNumber()
  @Min(0)
  price!: number;

  @Type(() => Number)
  @IsInt()
  @Min(1)
  duration!: number;
}
