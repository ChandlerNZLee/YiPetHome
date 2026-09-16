import { Type } from 'class-transformer';
import { IsEmail, IsInt, IsOptional, IsString, Min } from 'class-validator';

export class UpdateUserDto {
  @IsOptional()
  @IsString({ message: 'Username must be a string.' })
  username?: string;

  @IsOptional()
  @IsString({ message: 'Password must be a string.' })
  password?: string;

  @IsOptional()
  @Type(() => Number)
  @IsInt({ message: 'Role must be an integer.' })
  @Min(0, { message: 'Role must be greater than or equal to 0.' })
  role?: number;

  @IsOptional()
  @Type(() => Number)
  @IsInt({ message: 'Shop ID must be an integer.' })
  @Min(0, { message: 'Shop ID must be greater than or equal to 0.' })
  shop_id?: number;

  @IsOptional()
  @IsString({ message: 'Avatar must be a string.' })
  avatar?: string;

  @IsOptional()
  @IsString({ message: 'Mobile must be a string.' })
  mobile?: string;

  @IsOptional()
  @IsEmail()
  email?: string;

  @IsOptional()
  @IsString({ message: 'First name must be a string.' })
  first_name?: string;

  @IsOptional()
  @IsString({ message: 'Last name must be a string.' })
  last_name?: string;

  @IsOptional()
  @IsString({ message: 'Balance must be a string.' })
  balance?: number;

  @IsOptional()
  @IsString({ message: 'Last name must be a string.' })
  reset_token?: string;

  @IsOptional()
  @IsString({ message: 'Balance must be a string.' })
  reset_expires?: Date;
}
