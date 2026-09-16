import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class CreateSpendRecordDto {
  @Type(() => Number)
  @IsInt({ message: 'User ID must be an integer.' })
  @Min(0, { message: 'User ID must be greater than or equal to 0.' })
  userId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Type must be an integer.' })
  @Min(0, { message: 'Type must be greater than or equal to 0.' })
  _type!: number;

  @Type(() => Number)
  @IsInt({ message: 'Record ID must be an integer.' })
  @Min(0, { message: 'Record ID must be greater than or equal to 0.' })
  recordId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Spend amount must be an integer.' })
  @Min(0, { message: 'Spend amount must be greater than or equal to 0.' })
  spendAmount!: number;

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
