import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class CreatePetWeightDto {
  @Type(() => Number)
  @IsInt({ message: 'Pet ID must be an integer.' })
  @Min(0, { message: 'Pet ID must be greater than or equal to 0.' })
  petId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Weight must be an integer.' })
  @Min(0, { message: 'Weight must be greater than or equal to 0.' })
  weight!: number;

  @IsString({ message: 'Record date must be a string.' })
  @IsNotEmpty({ message: 'Record date is required.' })
  recordDate!: string;

  @Type(() => Number)
  @IsInt({ message: 'Appointment ID must be an integer.' })
  @Min(0, { message: 'Appointment ID must be greater than or equal to 0.' })
  appointmentId!: number;
}
