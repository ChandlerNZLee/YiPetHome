import 'temporal-polyfill/full/global';

import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';

import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    rawBody: true,
  });

  const configService = app.get(ConfigService);

  app.enableCors({
    origin: [
      'http://localhost:5173',
      'https://nzdc.co.uk',
    ],
    credentials: true,
  });

  app.useGlobalPipes(new ValidationPipe({
    whitelist: true,
    forbidNonWhitelisted: true,
    transform: true,
  }));

  const port = configService.get<number>(
    'PORT',
    3001,
  );;

  await app.listen(port);

  console.log(`CORS enabled NestJS web server is running on port ${port}`);
}

void bootstrap();
