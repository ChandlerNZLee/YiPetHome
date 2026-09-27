import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import {
    ConfigModule,
    ConfigService,
} from '@nestjs/config';

import { JwtAuthGuard } from './jwt-auth.guard';

@Module({
    imports: [
        ConfigModule,

        JwtModule.registerAsync({
            inject: [ConfigService],

            useFactory: (config: ConfigService) => ({
                secret: config.get<string>('JWT_SECRET'),

                signOptions: {
                    expiresIn: '24h',
                },
            }),
        }),
    ],

    providers: [
        JwtAuthGuard,
    ],

    exports: [
        JwtModule,
        JwtAuthGuard,
    ],
})
export class JwtAuthModule { }