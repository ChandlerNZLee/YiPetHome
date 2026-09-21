import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ScheduleModule } from '@nestjs/schedule';

import { AppController } from './app.controller';
import { PrismaModule } from './prisma/prisma.module';

import { AuthModule } from './auth/auth.module';
import { AddressesModule } from './addresses/addresses.module';
import { AppointmentsModule } from './appointments/appointments.module';
import { AIModule } from './ai/ai.module';
import { BannersModule } from './banners/banners.module';
import { GroomersModule } from './groomers/groomers.module';
import { OrdersModule } from './orders/orders.module';
import { PaymentsModule } from './payments/payments.module';
import { PetsModule } from './pets/pets.module';
import { ProductsModule } from './products/products.module';
import { RechargeBonusesModule } from './recharge-bonuses/recharge-bonuses.module';
import { RecordsModule } from './records/records.module';
import { ServicesModule } from './services/services.module';
import { ShopsModule } from './shops/shops.module';
import { UsersModule } from './users/users.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      cache: true,
    }),
    ScheduleModule.forRoot(),
    PrismaModule,
    AuthModule,
    AddressesModule,
    AppointmentsModule,
    AIModule,
    BannersModule,
    GroomersModule,
    OrdersModule,
    PaymentsModule,
    PetsModule,
    ProductsModule,
    RechargeBonusesModule,
    RecordsModule,
    ServicesModule,
    ShopsModule,
    UsersModule,
  ],
  controllers: [AppController]
})
export class AppModule { }
