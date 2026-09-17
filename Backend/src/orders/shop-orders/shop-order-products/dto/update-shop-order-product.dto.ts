import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class UpdateShopOrderProductDto {
  @Type(() => Number)
  @IsInt({ message: 'Order ID must be an integer.' })
  @Min(0, { message: 'Order ID must be greater than or equal to 0.' })
  orderId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Product ID must be an integer.' })
  @Min(0, { message: 'Product ID must be greater than or equal to 0.' })
  productId!: number;


  @Type(() => Number)
  @IsInt({ message: 'Amount must be an integer.' })
  @Min(0, { message: 'Amount must be greater than or equal to 0.' })
  amount!: number;

  @Type(() => Number)
  @IsInt({ message: 'Price must be an integer.' })
  @Min(0, { message: 'Price must be greater than or equal to 0.' })
  price!: number;
}
