import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class UpdatePetDto {
  @Type(() => Number)
  @IsInt({ message: 'User ID must be an integer.' })
  @Min(0, { message: 'User ID must be greater than or equal to 0.' })
  userId!: number;

  @IsString({ message: 'Avatar must be a string.' })
  @IsNotEmpty({ message: 'Avatar is required.' })
  avatar!: string;

  @IsString({ message: 'Name must be a string.' })
  @IsNotEmpty({ message: 'Name is required.' })
  name!: string;

  @Type(() => Number)
  @IsInt({ message: 'Gender must be an integer.' })
  @Min(0, { message: 'Gender must be greater than or equal to 0.' })
  gender!: number;

  @Type(() => Number)
  @IsInt({ message: 'Category must be an integer.' })
  @Min(0, { message: 'Category must be greater than or equal to 0.' })
  category!: number;

  @Type(() => Number)
  @IsInt({ message: 'Fur type must be an integer.' })
  @Min(0, { message: 'Fur type must be greater than or equal to 0.' })
  furType!: number;

  @IsString({ message: 'Birthday must be a string.' })
  @IsNotEmpty({ message: 'Birthday is required.' })
  birthday!: string;

  @Type(() => Number)
  @IsInt({ message: 'Activation status must be an integer.' })
  @Min(0, { message: 'Activation status must be greater than or equal to 0.' })
  activationStatus!: number;
}
