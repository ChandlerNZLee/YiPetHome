import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

import Stripe from 'stripe';

@Injectable()
export class StripeProvider {
    readonly client: Stripe;

    constructor(private readonly configService: ConfigService) {
        this.client = new Stripe(
            this.configService.getOrThrow<string>('STRIPE_SECRET_KEY'),
        );
    }

    createCheckoutSession(
        params: Stripe.Checkout.SessionCreateParams,
    ) {
        return this.client.checkout.sessions.create(params);
    }

    retrieveCheckoutSession(sessionId: string) {
        return this.client.checkout.sessions.retrieve(sessionId);
    }

    expireCheckoutSession(
        sessionId: string,
    ) {
        return this.client.checkout.sessions.expire(
            sessionId,
        );
    }

    async createRefund(
        paymentIntentId: string,
    ) {
        return this.client.refunds.create({
            payment_intent: paymentIntentId,
        });
    }

    constructWebhookEvent(
        payload: Buffer,
        signature: string,
    ): Stripe.Event {
        return this.client.webhooks.constructEvent(
            payload,
            signature,
            this.configService.getOrThrow<string>(
                'STRIPE_WEBHOOK_SECRET',
            ),
        );
    }
}