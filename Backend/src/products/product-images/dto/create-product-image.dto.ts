import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class CreateProductImageDto {
  @Type(() => Number)
  @IsInt({ message: 'Product ID must be an integer.' })
  @Min(0, { message: 'Product ID must be greater than or equal to 0.' })
  productId!: number;

  @IsString({ message: 'URL must be a string.' })
  @IsNotEmpty({ message: 'URL is required.' })
  url!: string;

  @Type(() => Number)
  @IsInt({ message: 'Sort order must be an integer.' })
  @Min(0, { message: 'Sort order must be greater than or equal to 0.' })
  sortOrder!: number;
}
