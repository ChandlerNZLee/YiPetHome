import { Type } from 'class-transformer';
import {
  IsDateString,
  IsInt,
  IsOptional,
  IsString,
  Min,
} from 'class-validator';

export class CreateAppointmentDto {
  @Type(() => Number)
  @IsInt({ message: 'User ID must be an integer.' })
  @Min(1, { message: 'User ID must be greater than 0.' })
  userId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Pet ID must be an integer.' })
  @Min(1, { message: 'Pet ID must be greater than 0.' })
  petId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Shop ID must be an integer.' })
  @Min(1, { message: 'Shop ID must be greater than 0.' })
  shopId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Groomer ID must be an integer.' })
  @Min(1, { message: 'Groomer ID must be greater than 0.' })
  groomerId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Service price ID must be an integer.' })
  @Min(1, { message: 'Service price ID must be greater than 0.' })
  servicePriceId!: number;

  @IsDateString(
    {},
    { message: 'Start time must be a valid ISO 8601 date.' },
  )
  startAt!: string;

  @IsOptional()
  @IsString({ message: 'Notes must be a string.' })
  notes?: string;
}