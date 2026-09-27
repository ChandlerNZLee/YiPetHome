import {
    IsEmail,
    IsNotEmpty,
    IsString,
    MinLength,
} from 'class-validator';

export class RegisterAppDto {
    @IsString({
        message: 'Username must be a string.',
    })
    @IsNotEmpty({
        message: 'Username is required.',
    })
    username!: string;

    @IsString({
        message: 'Password must be a string.',
    })
    @IsNotEmpty({
        message: 'Password is required.',
    })
    @MinLength(6, {
        message: 'Password must be at least 6 characters.',
    })
    password!: string;

    @IsString({
        message: 'Mobile must be a string.',
    })
    @IsNotEmpty({
        message: 'Mobile is required.',
    })
    mobile!: string;

    @IsEmail({}, {
        message: 'Please enter a valid email address.',
    })
    @IsNotEmpty({
        message: 'Email is required.',
    })
    email!: string;

    @IsString({
        message: 'First name must be a string.',
    })
    @IsNotEmpty({
        message: 'First name is required.',
    })
    firstName!: string;

    @IsString({
        message: 'Last name must be a string.',
    })
    @IsNotEmpty({
        message: 'Last name is required.',
    })
    lastName!: string;
}