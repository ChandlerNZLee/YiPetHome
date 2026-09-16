import { IsEmail, IsNotEmpty, IsString } from 'class-validator';

export class LoginAppDto {
  @IsEmail()
  @IsNotEmpty()
  email!: string;

  @IsString()
  @IsNotEmpty()
  password!: string;
}