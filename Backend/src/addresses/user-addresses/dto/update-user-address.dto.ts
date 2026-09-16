import { Type } from 'class-transformer';
import { IsInt, Min } from 'class-validator';

export class UpdateUserAddressDto {
    @Type(() => Number)
    @IsInt({ message: 'User ID must be an integer.' })
    @Min(0, { message: 'User ID must be greater than or equal to 0.' })
    userId!: number;

    @Type(() => Number)
    @IsInt({ message: 'Address ID must be an integer.' })
    @Min(0, { message: 'Address ID must be greater than or equal to 0.' })
    addressId!: number;

    @Type(() => Number)
    @IsInt({ message: 'Is default must be an integer.' })
    @Min(0, { message: 'Is default must be greater than or equal to 0.' })
    isDefault!: number;
}
