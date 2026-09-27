import { Type } from 'class-transformer';
import { IsArray, IsInt, IsNotEmpty, Min, ValidateNested } from 'class-validator';

export class UpdateShopOrderProductDto {
  @Type(() => Number)
  @IsInt({ message: 'Stock ID must be an integer.' })
  @Min(0, { message: 'Stock ID must be greater than or equal to 0.' })
  stockId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Quantity must be an integer.' })
  @Min(1, { message: 'Quantity must be greater than or equal to 0.' })
  quantity!: number;
}

export class UpdateShopOrderDto {
  @Type(() => Number)
  @IsInt({ message: 'Address ID must be an integer.' })
  @Min(0, { message: 'Address ID must be greater than or equal to 0.' })
  addressId!: number;

  @IsArray()
  @IsNotEmpty()
  @ValidateNested({ each: true })
  @Type(() => UpdateShopOrderProductDto)
  products!: UpdateShopOrderProductDto[];
}
