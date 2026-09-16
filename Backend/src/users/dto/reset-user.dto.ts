import { IsNotEmpty, IsString } from 'class-validator';

export class ResetUserDto {
    @IsString({ message: 'Token must be a string.' })
    @IsNotEmpty({ message: 'Token is required.' })
    token!: string;

    @IsString({ message: 'Password must be a string.' })
    @IsNotEmpty({ message: 'Password is required.' })
    password!: string;
}
