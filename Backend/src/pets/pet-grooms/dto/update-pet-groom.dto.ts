import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class UpdatePetGroomDto {
  @Type(() => Number)
  @IsInt({ message: 'Pet ID must be an integer.' })
  @Min(0, { message: 'Pet ID must be greater than or equal to 0.' })
  petId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Groom ID must be an integer.' })
  @Min(0, { message: 'Groom ID must be greater than or equal to 0.' })
  groomId!: number;

  @IsString({ message: 'Groom date must be a string.' })
  @IsNotEmpty({ message: 'Groom date is required.' })
  groomDate!: string;
}
