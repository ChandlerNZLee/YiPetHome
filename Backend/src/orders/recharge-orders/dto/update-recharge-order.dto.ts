import { IsInt, Min } from 'class-validator';

export class UpdateRechargeOrderDto {
    @IsInt()
    @Min(0, { message: 'Bonus ID must be greater than or equal to 0.' })
    bonusId!: number;
}