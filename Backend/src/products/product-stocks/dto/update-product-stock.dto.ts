import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class UpdateProductStockDto {
  @Type(() => Number)
  @IsInt({ message: 'Product ID must be an integer.' })
  @Min(0, { message: 'Product ID must be greater than or equal to 0.' })
  productId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Shop ID must be an integer.' })
  @Min(0, { message: 'Shop ID must be greater than or equal to 0.' })
  shopId!: number;

  @IsString({ message: 'Size must be a string.' })
  @IsNotEmpty({ message: 'Size is required.' })
  size!: string;

  @Type(() => Number)
  @IsInt({ message: 'Stock must be an integer.' })
  @Min(0, { message: 'Stock must be greater than or equal to 0.' })
  stock!: number;

  @Type(() => Number)
  @IsInt({ message: 'Price must be an integer.' })
  @Min(0, { message: 'Price must be greater than or equal to 0.' })
  price!: number;

  @Type(() => Number)
  @IsInt({ message: 'Discount must be an integer.' })
  @Min(0, { message: 'Discount must be greater than or equal to 0.' })
  discount!: number;
}
