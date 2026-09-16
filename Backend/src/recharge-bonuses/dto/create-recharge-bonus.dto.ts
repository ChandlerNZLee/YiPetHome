import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class CreateRechargeBonusDto {
  @IsString({ message: 'Name must be a string.' })
  @IsNotEmpty({ message: 'Name is required.' })
  name!: string;

  @IsInt({ message: 'Recharge amount must be an integer.' })
  @Min(0, { message: 'Recharge amount must be greater than or equal to 0.' })
  rechargeAmount!: number;

  @IsInt({ message: 'Gift amount must be an integer.' })
  @Min(0, { message: 'Gift amount must be greater than or equal to 0.' })
  giftAmount!: number;

  @Type(() => Number)
  @IsInt({ message: 'Activation status must be an integer.' })
  @Min(0, { message: 'Activation status must be greater than or equal to 0.' })
  activationStatus!: number;

  @Type(() => Number)
  @IsInt({ message: 'Sort order must be an integer.' })
  @Min(0, { message: 'Sort order must be greater than or equal to 0.' })
  sortOrder!: number;
}
