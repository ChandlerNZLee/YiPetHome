import { IsNotEmpty, IsString } from 'class-validator';

export class LoginWebDto {
  @IsString()
  @IsNotEmpty()
  username!: string;

  @IsString()
  @IsNotEmpty()
  password!: string;
}