import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class UpdateShopOrderDto {
  @Type(() => Number)
  @IsInt({ message: 'User ID must be an integer.' })
  @Min(0, { message: 'User ID must be greater than or equal to 0.' })
  user_id!: number;

  @Type(() => Number)
  @IsInt({ message: 'Address ID must be an integer.' })
  @Min(0, { message: 'Address ID must be greater than or equal to 0.' })
  address_id!: number;

  @IsString({ message: 'Time must be a string.' })
  @IsNotEmpty({ message: 'Time is required.' })
  time!: string;

  @IsString({ message: 'Total price must be a string.' })
  @IsNotEmpty({ message: 'Total price is required.' })
  total_price!: string;

  @Type(() => Number)
  @IsInt({ message: 'Payment status must be an integer.' })
  @Min(0, { message: 'Payment status must be greater than or equal to 0.' })
  payment_status!: number;

  @Type(() => Number)
  @IsInt({ message: 'Order status must be an integer.' })
  @Min(0, { message: 'Order status must be greater than or equal to 0.' })
  order_status!: number;

  @Type(() => Number)
  @IsInt({ message: 'Tracking number must be an integer.' })
  @Min(0, { message: 'Tracking number must be greater than or equal to 0.' })
  tracking_number!: number;
}
