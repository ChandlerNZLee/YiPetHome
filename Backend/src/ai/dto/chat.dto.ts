import { IsNotEmpty, IsString } from 'class-validator';

export class ChatDto {
    @IsString({ message: 'Message must be a string.' })
    @IsNotEmpty({ message: 'Message is required.' })
    message!: string;
}