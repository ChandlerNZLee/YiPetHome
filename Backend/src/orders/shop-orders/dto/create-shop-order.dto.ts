import { Type } from 'class-transformer';
import { IsArray, IsInt, IsNotEmpty, Min, ValidateNested } from 'class-validator';

export class CreateShopOrderProductDto {
  @Type(() => Number)
  @IsInt({ message: 'Product ID must be an integer.' })
  @Min(0, { message: 'Product ID must be greater than or equal to 0.' })
  productId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Stock ID must be an integer.' })
  @Min(0, { message: 'Stock ID must be greater than or equal to 0.' })
  stockId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Quantity must be an integer.' })
  @Min(1, { message: 'Quantity must be greater than or equal to 0.' })
  quantity!: number;

  @Type(() => Number)
  @IsInt({ message: 'Price must be an integer.' })
  @Min(0, { message: 'Price must be greater than or equal to 0.' })
  price!: number;
}

export class CreateShopOrderDto {
  @Type(() => Number)
  @IsInt({ message: 'User ID must be an integer.' })
  @Min(0, { message: 'User ID must be greater than or equal to 0.' })
  userId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Address ID must be an integer.' })
  @Min(0, { message: 'Address ID must be greater than or equal to 0.' })
  addressId!: number;

  @IsArray()
  @IsNotEmpty()
  @ValidateNested({ each: true })
  @Type(() => CreateShopOrderProductDto)
  products!: CreateShopOrderProductDto[];
}
