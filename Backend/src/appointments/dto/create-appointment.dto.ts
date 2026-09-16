import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class CreateAppointmentDto {
  @Type(() => Number)
  @IsInt({ message: 'Type must be an integer.' })
  @Min(0, { message: 'Type must be greater than or equal to 0.' })
  _type!: number;

  @Type(() => Number)
  @IsInt({ message: 'User ID must be an integer.' })
  @Min(0, { message: 'User ID must be greater than or equal to 0.' })
  userId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Pet ID must be an integer.' })
  @Min(0, { message: 'Pet ID must be greater than or equal to 0.' })
  petId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Shop ID must be an integer.' })
  @Min(0, { message: 'Shop ID must be greater than or equal to 0.' })
  shopId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Groomer ID must be an integer.' })
  @Min(0, { message: 'Groomer ID must be greater than or equal to 0.' })
  groomerId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Origin price must be an integer.' })
  @Min(0, { message: 'Origin price must be greater than or equal to 0.' })
  originPrice!: number;

  @Type(() => Number)
  @IsInt({ message: 'Discount must be an integer.' })
  @Min(0, { message: 'Discount must be greater than or equal to 0.' })
  discount!: number;

  @Type(() => Number)
  @IsInt({ message: 'Price must be an integer.' })
  @Min(0, { message: 'Price must be greater than or equal to 0.' })
  price!: number;

  @Type(() => Number)
  @IsInt({ message: 'Payment status must be an integer.' })
  @Min(0, { message: 'Payment status must be greater than or equal to 0.' })
  paymentStatus!: number;

  @Type(() => Number)
  @IsInt({ message: 'Appointment status must be an integer.' })
  @Min(0, { message: 'Appointment status must be greater than or equal to 0.' })
  appointmentStatus!: number;

  @IsString({ message: 'Notes must be a string.' })
  @IsNotEmpty({ message: 'Notes is required.' })
  notes!: string;
}
