import { Body, Controller, Post, UploadedFile, UseInterceptors } from '@nestjs/common';

import { FileInterceptor } from '@nestjs/platform-express';
import type { Express } from 'express';

import { AIService } from './ai.service';
import { ChatDto } from './dto/chat.dto';

@Controller('ai')

export class AIController {
    constructor(private readonly aiService: AIService) { }

    @Post('chat')
    async chat(@Body() dto: ChatDto) {
        return this.aiService.chat(dto.message);
    }

    @Post('vision')
    @UseInterceptors(FileInterceptor('image'))
    async vision(
        @UploadedFile() image: Express.Multer.File,
        @Body('message') message: string,
    ) {
        return this.aiService.vision(message, image);
    }
}