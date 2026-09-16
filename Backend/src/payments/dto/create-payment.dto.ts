import { Type } from 'class-transformer';
import { IsInt, IsPositive } from 'class-validator';

export class CreatePaymentDto {
    @Type(() => Number)
    @IsInt()
    @IsPositive()
    orderId!: number;

    @Type(() => Number)
    @IsInt()
    @IsPositive()
    userId!: number;
}