import { Type } from 'class-transformer';
import {
    IsInt,
    IsOptional,
    Min,
} from 'class-validator';

export class CreateRechargeOrderDto {
    @IsOptional()
    @Type(() => Number)
    @IsInt({
        message: 'User ID must be an integer.',
    })
    @Min(1, {
        message: 'User ID must be greater than 0.',
    })
    userId?: number;

    @Type(() => Number)
    @IsInt({
        message: 'Bonus ID must be an integer.',
    })
    @Min(1, {
        message: 'Bonus ID must be greater than 0.',
    })
    bonusId!: number;
}