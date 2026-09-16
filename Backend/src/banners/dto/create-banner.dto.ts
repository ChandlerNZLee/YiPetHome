import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class CreateBannerDto {
  @Type(() => Number)
  @IsInt({ message: 'Shop ID must be an integer.' })
  @Min(0, { message: 'Shop ID must be greater than or equal to 0.' })
  shopId!: number;

  @IsString({ message: 'Title must be a string.' })
  @IsNotEmpty({ message: 'Title is required.' })
  title!: string;

  @IsString({ message: 'Description must be a string.' })
  @IsNotEmpty({ message: 'Description is required.' })
  description!: string;

  @IsString({ message: 'Image must be a string.' })
  @IsNotEmpty({ message: 'Image is required.' })
  image!: string;

  @IsString({ message: 'URL must be a string.' })
  @IsNotEmpty({ message: 'URL is required.' })
  url!: string;

  @Type(() => Number)
  @IsInt({ message: 'Activation status must be an integer.' })
  @Min(0, { message: 'Activation status must be greater than or equal to 0.' })
  activationStatus!: number;

  @Type(() => Number)
  @IsInt({ message: 'Sort order must be an integer.' })
  @Min(0, { message: 'Sort order must be greater than or equal to 0.' })
  sortOrder!: number;
}
