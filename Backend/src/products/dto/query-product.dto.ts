import { Type } from 'class-transformer';
import { IsInt, IsOptional, IsString, Min } from 'class-validator';

export class QueryProductDto {
    @IsOptional()
    @Type(() => Number)
    @IsInt({ message: 'Pet ID must be an integer.' })
    @Min(0, { message: 'Pet ID must be greater than or equal to 0.' })
    petId?: number;

    @IsOptional()
    @Type(() => Number)
    @IsInt({ message: 'Shop ID must be an integer.' })
    @Min(0, { message: 'Shop ID must be greater than or equal to 0.' })
    shopId?: number;

    @IsOptional()
    @IsString({ message: 'Keyword must be a string.' })
    keyword?: string;

    @IsOptional()
    @Type(() => Number)
    @IsInt({ message: 'Product ID must be an integer.' })
    @Min(0, { message: 'Product ID must be greater than or equal to 0.' })
    productId?: number;
}
