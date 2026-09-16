import { BadRequestException, Injectable } from '@nestjs/common';

import type { Express } from 'express';
import sharp from 'sharp';

import { execFile } from 'node:child_process';
import { mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import { join } from 'node:path';
import { tmpdir } from 'node:os';
import { promisify } from 'node:util';

const execFileAsync = promisify(execFile);

@Injectable()
export class AIService {
    private readonly ollamaUrl = 'http://localhost:11434';

    async chat(message: string) {
        const response = await fetch(`${this.ollamaUrl}/api/chat`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                model: 'qwen3:8b',
                messages: [
                    {
                        role: 'user',
                        content: message,
                    },
                ],
                stream: false,
            }),
        });

        if (!response.ok) {
            throw new Error(`Ollama error: ${response.statusText}`);
        }

        const data = await response.json();
        return {
            message: data.message.content,
        };
    }

    async vision(message: string, image: Express.Multer.File) {
        if (!image) {
            throw new BadRequestException('Image is required');
        }

        const imageBuffer = await this.prepareVisionImage(image);
        const base64Image = imageBuffer.toString('base64');
        const response = await fetch(`${this.ollamaUrl}/api/chat`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                model: 'qwen3-vl:8b',
                messages: [
                    {
                        role: 'user',
                        content: message || '请详细分析这张图片，并告诉我你看到了什么。',
                        images: [base64Image],
                    },
                ],
                stream: false,
                options: {
                    num_ctx: 16384,
                },
            }),
        });

        if (!response.ok) {
            const error = await response.text();
            throw new Error(`Ollama Vision error: ${error}`);
        }

        const data = await response.json();

        console.log(
            JSON.stringify(data, null, 2),
        );

        return {
            message: data.message?.content ?? '',
            thinking: data.message?.thinking ?? '',
        };
    }

    private async prepareVisionImage(image: Express.Multer.File): Promise<Buffer> {
        let sourceBuffer = image.buffer;

        try {
            const filename = image.originalname.toLowerCase();

            const isHeic =
                filename.endsWith('.heic') ||
                filename.endsWith('.heif') ||
                image.mimetype === 'image/heic' ||
                image.mimetype === 'image/heif';

            console.log(
                'Original image:',
                {
                    name: image.originalname,
                    type: image.mimetype,
                    size: image.size,
                },
            );

            if (isHeic) {
                console.log(
                    'HEIC detected, converting with sips...',
                );

                sourceBuffer = await this.convertHeicWithSips(image.buffer);
            }

            const metadata = await sharp(sourceBuffer).metadata();

            console.log(
                'Image metadata after conversion:',
                {
                    format: metadata.format,
                    width: metadata.width,
                    height: metadata.height,
                },
            );

            const result =
                await sharp(sourceBuffer)
                    .rotate()
                    .resize({
                        width: 1600,
                        height: 1600,
                        fit: 'inside',
                        withoutEnlargement: true,
                    })
                    .jpeg({ quality: 82 })
                    .toBuffer();

            console.log(
                'Processed image:',
                {
                    originalSize: image.buffer.length,
                    processedSize: result.length,
                },
            );

            return result;
        } catch (error) {
            console.error(
                'Image conversion failed:',
                error,
            );

            throw new BadRequestException(
                'Unable to process this image. Please upload JPG, PNG, HEIC or HEIF.',
            );
        }
    }

    private async convertHeicWithSips(
        buffer: Buffer,
    ): Promise<Buffer> {
        const tempDir =
            await mkdtemp(
                join(
                    tmpdir(),
                    'vision-',
                ),
            );

        const inputPath =
            join(
                tempDir,
                'input.heic',
            );

        const outputPath =
            join(
                tempDir,
                'output.jpg',
            );

        try {
            await writeFile(
                inputPath,
                buffer,
            );

            await execFileAsync(
                'sips',
                [
                    '-s',
                    'format',
                    'jpeg',

                    inputPath,

                    '--out',
                    outputPath,
                ],
            );

            const jpegBuffer =
                await readFile(
                    outputPath,
                );

            return jpegBuffer;
        } finally {
            await rm(
                tempDir,
                {
                    recursive: true,
                    force: true,
                },
            );
        }
    }
}