import { Transform, Type } from 'class-transformer';
import {
  IsArray,
  IsDateString,
  IsInt,
  IsOptional,
  IsString,
  Min,
  ArrayMinSize
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

  @Transform(({ value }) => {
    if (Array.isArray(value)) {
      return value.map((item) => Number(item));
    }

    return String(value)
      .split(',')
      .map((item) => item.trim())
      .filter((item) => item.length > 0)
      .map((item) => Number(item));
  })
  @IsArray()
  @ArrayMinSize(1)
  @IsInt({ each: true })
  @Min(1, { each: true })
  servicePriceIds!: number[];

  @IsDateString(
    {},
    { message: 'Start time must be a valid ISO 8601 date.' },
  )
  startAt!: string;

  @IsOptional()
  @IsString({ message: 'Notes must be a string.' })
  notes?: string;
}