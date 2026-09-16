import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class CreateProductDto {
  @Type(() => Number)
  @IsInt({ message: 'Category must be an integer.' })
  @Min(0, { message: 'Category must be greater than or equal to 0.' })
  category!: number;

  @Type(() => Number)
  @IsInt({ message: 'Type must be an integer.' })
  @Min(0, { message: 'Type must be greater than or equal to 0.' })
  _type!: number;

  @IsString({ message: 'Name must be a string.' })
  @IsNotEmpty({ message: 'Name is required.' })
  name!: string;

  @IsString({ message: 'Name (Chinese) must be a string.' })
  @IsNotEmpty({ message: 'Name (Chinese) is required.' })
  nameZh!: string;

  @IsString({ message: 'Description must be a string.' })
  @IsNotEmpty({ message: 'Description is required.' })
  description!: string;
}
