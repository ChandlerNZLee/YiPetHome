import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class UpdatePetVaccineDto {
  @Type(() => Number)
  @IsInt({ message: 'Pet ID must be an integer.' })
  @Min(0, { message: 'Pet ID must be greater than or equal to 0.' })
  petId!: number;

  @IsString({ message: 'Vaccine name must be a string.' })
  @IsNotEmpty({ message: 'Vaccine name is required.' })
  vaccineName!: string;

  @IsString({ message: 'Vaccine date must be a string.' })
  @IsNotEmpty({ message: 'Vaccine date is required.' })
  vaccineDate!: string;

  @IsString({ message: 'Next date must be a string.' })
  @IsNotEmpty({ message: 'Next date is required.' })
  nextDate!: string;
}
