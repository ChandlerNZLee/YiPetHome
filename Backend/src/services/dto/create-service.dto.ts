import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class CreateServiceDto {
  @Type(() => Number)
  @IsInt({ message: 'Service type must be an integer.' })
  @Min(0, { message: 'Service type must be greater than or equal to 0.' })
  _type!: number;

  @IsString({ message: 'Name must be a string.' })
  @IsNotEmpty({ message: 'Name is required.' })
  name!: string;

  @IsString({ message: 'Description must be a string.' })
  @IsNotEmpty({ message: 'Description is required.' })
  description!: string;

  @IsString({ message: 'Image must be a string.' })
  @IsNotEmpty({ message: 'Image is required.' })
  image!: string;
}
