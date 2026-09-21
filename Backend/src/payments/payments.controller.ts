import {
    BadRequestException,
    Body,
    Controller,
    Get,
    Headers,
    Param,
    Post,
    Req,
} from '@nestjs/common';

import type { RawBodyRequest } from '@nestjs/common';
import { Request } from 'express';
import Stripe from 'stripe';

import { CreatePaymentDto } from './dto/create-payment.dto';
import { PaymentsService } from './payments.service';
import { StripeProvider } from './providers/stripe.provider';

@Controller('payments')
export class PaymentsController {
    constructor(
        private readonly paymentsService: PaymentsService,
        private readonly stripeProvider: StripeProvider,
    ) { }

    @Post('checkout')
    async createCheckout(
        @Body() dto: CreatePaymentDto,
    ) {
        return this.paymentsService.createCheckoutSession(
            dto.orderId,
            dto.orderType,
            dto.userId,
        );
    }

    @Get('checkout/:id')
    async getCheckout(
        @Param('id') id: string,
    ) {
        return this.paymentsService.getCheckoutSession(id);
    }

    @Post('webhook')
    async webhook(
        @Req() req: RawBodyRequest<Request>,
        @Headers('stripe-signature') signature: string,
    ) {
        if (!signature) {
            throw new BadRequestException(
                'Stripe signature is missing',
            );
        }

        if (!req.rawBody) {
            throw new BadRequestException(
                'Raw request body is missing',
            );
        }

        let event: Stripe.Event;

        try {
            event = this.stripeProvider.constructWebhookEvent(
                req.rawBody,
                signature,
            );
        } catch {
            throw new BadRequestException(
                'Invalid Stripe webhook signature',
            );
        }

        await this.paymentsService.handleWebhook(event);

        return {
            received: true,
        };
    }

    @Post('appointments/:id/refund')
    async refundAppointment(
        @Param('id') id: string,
        @Body() body: { userId: number },
    ) {
        return this.paymentsService.refundAppointment(
            Number(id),
            Number(body.userId),
        );
    }
}