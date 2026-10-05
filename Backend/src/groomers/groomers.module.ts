import { Module } from '@nestjs/common';

import { JwtAuthModule } from '../common/auth/jwt-auth.module';

import { GroomersController } from './groomers.controller';
import { GroomersService } from './groomers.service';

@Module({
  imports: [JwtAuthModule],
  controllers: [GroomersController],
  providers: [GroomersService],
  exports: [GroomersService],
})
export class GroomersModule { }
