import { Transform, Type } from 'class-transformer';
import { IsArray, IsDateString, IsInt, Min, ArrayMinSize } from 'class-validator';

export class GetAppointmentAvailabilityDto {
    @Type(() => Number)
    @IsInt()
    @Min(1)
    shopId!: number;

    @Type(() => Number)
    @IsInt()
    @Min(1)
    groomerId!: number;

    @Transform(({ value }) => {
        if (Array.isArray(value)) {
            return value.map((item) => Number(item));
        }

        return String(value)
            .split(',')
            .map((item) => item.trim())
            .filter((item) => item.length > 0)
            .map((item) => Number(item));
    })
    @IsArray()
    @ArrayMinSize(1)
    @IsInt({ each: true })
    @Min(1, { each: true })
    servicePriceIds!: number[];

    @IsDateString()
    date!: string;
}