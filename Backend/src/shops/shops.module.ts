import { Module } from '@nestjs/common';

import { JwtAuthModule } from '../common/auth/jwt-auth.module';

import { ShopsController } from './shops.controller';
import { ShopsService } from './shops.service';

@Module({
  imports: [JwtAuthModule],
  controllers: [ShopsController],
  providers: [ShopsService],
  exports: [ShopsService],
})
export class ShopsModule { }
