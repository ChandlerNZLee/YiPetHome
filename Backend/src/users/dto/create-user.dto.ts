import { Type } from 'class-transformer';
import { IsEmail, IsInt, IsNotEmpty, IsString, Min } from 'class-validator';

export class CreateUserDto {
  @IsString({ message: 'Username must be a string.' })
  @IsNotEmpty({ message: 'Username is required.' })
  username!: string;

  @IsString({ message: 'Password must be a string.' })
  @IsNotEmpty({ message: 'Password is required.' })
  password!: string;

  @Type(() => Number)
  @IsInt({ message: 'Role must be an integer.' })
  @Min(0, { message: 'Role must be greater than or equal to 0.' })
  role!: number;

  @Type(() => Number)
  @IsInt({ message: 'Shop ID must be an integer.' })
  @Min(0, { message: 'Shop ID must be greater than or equal to 0.' })
  shopId!: number;

  @IsString({ message: 'Avatar must be a string.' })
  avatar!: string;

  @IsString({ message: 'Mobile must be a string.' })
  @IsNotEmpty({ message: 'Mobile is required.' })
  mobile!: string;

  @IsEmail()
  @IsNotEmpty({ message: 'Email is required.' })
  email!: string;

  @IsString({ message: 'First name must be a string.' })
  @IsNotEmpty({ message: 'First name is required.' })
  firstName!: string;

  @IsString({ message: 'Last name must be a string.' })
  @IsNotEmpty({ message: 'Last name is required.' })
  lastName!: string;

  @Type(() => Number)
  @IsInt({ message: 'Balance must be an integer.' })
  @Min(0, { message: 'Balance must be greater than or equal to 0.' })
  balance!: number;
}
