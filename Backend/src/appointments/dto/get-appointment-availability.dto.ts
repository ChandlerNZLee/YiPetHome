import { Type } from 'class-transformer';
import { IsDateString, IsInt, Min } from 'class-validator';

export class GetAppointmentAvailabilityDto {
    @Type(() => Number)
    @IsInt()
    @Min(1)
    shopId!: number;

    @Type(() => Number)
    @IsInt()
    @Min(1)
    groomerId!: number;

    @Type(() => Number)
    @IsInt()
    @Min(1)
    servicePriceId!: number;

    @IsDateString()
    date!: string;
}