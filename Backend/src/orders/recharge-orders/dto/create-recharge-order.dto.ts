import { IsInt, Min } from 'class-validator';

export class CreateRechargeOrderDto {
    @IsInt()
    @Min(0, { message: 'User ID must be greater than or equal to 0.' })
    userId!: number;

    @IsInt()
    @Min(0, { message: 'Bonus ID must be greater than or equal to 0.' })
    bonusId!: number;
}