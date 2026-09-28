import { Module } from '@nestjs/common';

import { JwtAuthModule } from '../common/auth/jwt-auth.module';

import { PaymentsController } from './payments.controller';
import { PaymentsService } from './payments.service';
import { StripeProvider } from './providers/stripe.provider';

@Module({
    imports: [JwtAuthModule],
    controllers: [PaymentsController],
    providers: [PaymentsService, StripeProvider],
    exports: [PaymentsService, StripeProvider],
})
export class PaymentsModule { }