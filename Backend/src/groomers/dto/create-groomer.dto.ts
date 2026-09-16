import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class CreateGroomerDto {
    @Type(() => Number)
    @IsInt({ message: 'Shop ID must be an integer.' })
    @Min(0, { message: 'Shop ID must be greater than or equal to 0.' })
    shopId!: number;

    @IsString({ message: 'Name must be a string.' })
    @IsNotEmpty({ message: 'Name is required.' })
    name!: string;

    @Type(() => Number)
    @IsInt({ message: 'Type must be an integer.' })
    @Min(0, { message: 'Type must be greater than or equal to 0.' })
    _type!: number;

    @Type(() => Number)
    @IsInt({ message: 'Experience must be an integer.' })
    @Min(0, { message: 'Experience must be greater than or equal to 0.' })
    experience!: number;

    @Type(() => Number)
    @IsInt({ message: 'Customers must be an integer.' })
    @Min(0, { message: 'Customers must be greater than or equal to 0.' })
    customers!: number;

    @IsString({ message: 'Description must be a string.' })
    @IsNotEmpty({ message: 'Description is required.' })
    description!: string;

    @IsString({ message: 'Avatar must be a string.' })
    @IsNotEmpty({ message: 'Avatar is required.' })
    avatar!: string;

    @Type(() => Number)
    @IsInt({ message: 'Customers must be an integer.' })
    @Min(0, { message: 'Customers must be greater than or equal to 0.' })
    price!: number;
}
