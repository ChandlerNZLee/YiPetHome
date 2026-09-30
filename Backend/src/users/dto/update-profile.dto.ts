import {
    IsEmail,
    IsOptional,
    IsString,
} from 'class-validator';

export class UpdateProfileDto {
    @IsOptional()
    @IsString({
        message: 'Avatar must be a string.',
    })
    avatar?: string;

    @IsOptional()
    @IsString({
        message: 'Mobile must be a string.',
    })
    mobile?: string;

    @IsOptional()
    @IsEmail()
    email?: string;

    @IsOptional()
    @IsString({
        message: 'First name must be a string.',
    })
    firstName?: string;

    @IsOptional()
    @IsString({
        message: 'Last name must be a string.',
    })
    lastName?: string;
}