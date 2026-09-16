import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class UpdateOperationRecordDto {
  @Type(() => Number)
  @IsInt({ message: 'User ID must be an integer.' })
  @Min(0, { message: 'User ID must be greater than or equal to 0.' })
  userId!: number;

  @IsString({ message: 'Operation must be a string.' })
  @IsNotEmpty({ message: 'Operation is required.' })
  operation!: string;

  @IsString({ message: 'Table name must be a string.' })
  @IsNotEmpty({ message: 'Table name is required.' })
  tableName!: string;

  @IsString({ message: 'Time must be a string.' })
  @IsNotEmpty({ message: 'Time is required.' })
  time!: string;
}