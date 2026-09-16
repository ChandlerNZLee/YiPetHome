import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class CreateRechargeRecordDto {
  @Type(() => Number)
  @IsInt({ message: 'User ID must be an integer.' })
  @Min(0, { message: 'User ID must be greater than or equal to 0.' })
  userId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Bonus ID must be an integer.' })
  @Min(0, { message: 'Bonus ID must be greater than or equal to 0.' })
  bonusId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Balance before must be an integer.' })
  @Min(0, { message: 'Balance before must be greater than or equal to 0.' })
  balanceBefore!: number;

  @Type(() => Number)
  @IsInt({ message: 'Balance after must be an integer.' })
  @Min(0, { message: 'Balance after must be greater than or equal to 0.' })
  balanceAfter!: number;

  @IsString({ message: 'Create time must be a string.' })
  @IsNotEmpty({ message: 'Create time is required.' })
  createTime!: string;
}
