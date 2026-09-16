import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class CreateServicePriceDto {
  @Type(() => Number)
  @IsInt({ message: 'Service ID must be an integer.' })
  @Min(0, { message: 'Service ID must be greater than or equal to 0.' })
  serviceId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Category must be an integer.' })
  @Min(0, { message: 'Category must be greater than or equal to 0.' })
  category!: number;

  @Type(() => Number)
  @IsInt({ message: 'Fur type must be an integer.' })
  @Min(0, { message: 'Fur type must be greater than or equal to 0.' })
  furType!: number;

  @Type(() => Number)
  @IsInt({ message: 'Duration must be an integer.' })
  @Min(0, { message: 'Duration must be greater than or equal to 0.' })
  duration!: number;

  @Type(() => Number)
  @IsInt({ message: 'Price must be an integer.' })
  @Min(0, { message: 'Price must be greater than or equal to 0.' })
  price!: number;

  @Type(() => Number)
  @IsInt({ message: 'Weight From must be an integer.' })
  @Min(0, { message: 'Weight From must be greater than or equal to 0.' })
  weightFrom!: number;

  @Type(() => Number)
  @IsInt({ message: 'Weight To must be an integer.' })
  @Min(0, { message: 'Weight To must be greater than or equal to 0.' })
  weightTo!: number;
}
