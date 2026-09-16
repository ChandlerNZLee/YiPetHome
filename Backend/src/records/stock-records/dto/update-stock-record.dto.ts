import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class UpdateStockRecordDto {
  @Type(() => Number)
  @IsInt({ message: 'User ID must be an integer.' })
  @Min(0, { message: 'User ID must be greater than or equal to 0.' })
  userId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Stock ID must be an integer.' })
  @Min(0, { message: 'Stock ID must be greater than or equal to 0.' })
  stockId!: number;

  @Type(() => Number)
  @IsInt({ message: 'Change amount must be an integer.' })
  @Min(0, { message: 'Change amount must be greater than or equal to 0.' })
  changeAmount!: number;

  @IsString({ message: 'Change reason must be a string.' })
  @IsNotEmpty({ message: 'Change reason is required.' })
  changeReason!: string;

  @IsString({ message: 'Change time must be a string.' })
  @IsNotEmpty({ message: 'Change time is required.' })
  changeTime!: string;
}
