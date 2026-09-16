import {
    BadRequestException,
    Injectable,
    NotFoundException,
} from '@nestjs/common';

import { ConfigService } from '@nestjs/config';

import { Temporal } from 'temporal-polyfill';

import { PAYMENT_STATUS, ORDER_STATUS } from './constants/payment-status.constant';
import Stripe from 'stripe';

import { PrismaService } from '../prisma/prisma.service';
import { StripeProvider } from './providers/stripe.provider';

@Injectable()
export class PaymentsService {
    constructor(
        private readonly prisma: PrismaService,
        private readonly stripeProvider: StripeProvider,
        private readonly configService: ConfigService,
    ) { }

    async createCheckoutSession(
        orderId: number,
        userId: number,
    ) {
        const order = await this.prisma.db.orm.public.Orders.where({ id: orderId }).first();

        if (!order) {
            throw new NotFoundException('Order not found');
        }

        if (order.userId !== userId) {
            throw new BadRequestException(
                'This order does not belong to the current user',
            );
        }

        const succeededPayment = await this.prisma.db.orm.public.Payments.where({
            orderId: order.id,
            status: PAYMENT_STATUS.SUCCEEDED,
        }).first();

        if (succeededPayment) {
            throw new BadRequestException(
                'Order has already been paid',
            );
        }

        if (order.paymentStatus === PAYMENT_STATUS.SUCCEEDED) {
            throw new BadRequestException('Order has already been paid');
        }

        if (order.orderStatus === ORDER_STATUS.CANCELLED) {
            throw new BadRequestException('Cancelled order cannot be paid');
        }

        const orderProducts = await this.prisma.db.orm.public.OrderProducts.where({ orderId: order.id }).all();

        for (const item of orderProducts) {
            const stock = await this.prisma.db.orm.public.ProductStocks.where({ id: item.stockId }).first();

            if (!stock || stock.stock < item.amount) {
                throw new BadRequestException(
                    `Insufficient stock for stock ID ${item.stockId}`,
                );
            }
        }

        const lineItems: Stripe.Checkout.SessionCreateParams.LineItem[] = [
            {
                quantity: 1,
                price_data: {
                    currency:
                        this.configService.get<string>(
                            'STRIPE_CURRENCY',
                        ) ?? 'nzd',
                    unit_amount: Math.round(
                        Number(order.totalPrice) * 100,
                    ),
                    product_data: {
                        name: `Order #${order.id}`,
                        metadata: {
                            orderId: String(order.id),
                        },
                    },
                },
            },
        ];

        const payment = await this.prisma.db.orm.public.Payments.create({
            orderId: order.id,
            provider: 'STRIPE',
            amount: order.totalPrice,
            currency:
                this.configService.get<string>(
                    'STRIPE_CURRENCY',
                ) ?? 'nzd',
            status: PAYMENT_STATUS.PENDING,
            updatedAt: Temporal.Now.instant(),
        });

        try {
            const session =
                await this.stripeProvider.createCheckoutSession({
                    mode: 'payment',
                    line_items: lineItems,
                    success_url:
                        this.configService.getOrThrow<string>(
                            'STRIPE_SUCCESS_URL',
                        ),
                    cancel_url:
                        this.configService.getOrThrow<string>(
                            'STRIPE_CANCEL_URL',
                        ),
                    metadata: {
                        orderId: String(order.id),
                        paymentId: String(payment.id),
                    },
                    payment_intent_data: {
                        metadata: {
                            orderId: String(order.id),
                            paymentId: String(payment.id),
                        },
                    },
                });

            await this.prisma.db.orm.public.Payments.where({
                id: payment.id,
            }).update({
                stripeCheckoutSessionId: session.id,
                updatedAt: Temporal.Now.instant(),
            });

            return {
                paymentId: payment.id,
                orderId: order.id,
                checkoutSessionId: session.id,
                checkoutUrl: session.url,
            };
        } catch (error) {
            await this.prisma.db.orm.public.Payments.where({
                id: payment.id,
            }).update({
                status: PAYMENT_STATUS.FAILED,
                failureMessage:
                    error instanceof Error
                        ? error.message
                        : 'Unable to create Stripe checkout session',
                updatedAt: Temporal.Now.instant(),
            });

            throw error;
        }
    }

    async getCheckoutSession(sessionId: string) {
        const session =
            await this.stripeProvider.retrieveCheckoutSession(
                sessionId,
            );

        return {
            id: session.id,
            paymentStatus: session.payment_status,
            status: session.status,
            orderId: session.metadata?.orderId,
            paymentId: session.metadata?.paymentId,
        };
    }

    async handleWebhook(event: Stripe.Event) {
        console.log('================================');
        console.log('Stripe webhook received');
        console.log('event.type:', event.type);
        console.log('event.id:', event.id);
        console.log('================================');

        switch (event.type) {
            case 'checkout.session.completed':
                console.log('Handling checkout.session.completed');

                await this.handleCheckoutCompleted(
                    event.data.object,
                );

                break;
            case 'checkout.session.expired':
                await this.handleCheckoutExpired(
                    event.data.object,
                );

                break;
            case 'payment_intent.payment_failed':
                await this.handlePaymentFailed(
                    event.data.object,
                );

                break;
            case 'charge.refunded':
                await this.handleChargeRefunded(
                    event.data.object,
                );

                break;
            default:
                break;
        }
    }

    private async handleCheckoutCompleted(session: Stripe.Checkout.Session) {
        console.log('checkout.session.completed received');
        if (session.payment_status !== 'paid') {
            console.log('Session is not paid, skipping update');
            return;
        }

        const orderId = Number(session.metadata?.orderId);
        const paymentId = Number(session.metadata?.paymentId);

        console.log('[Stripe] Parsed metadata', { orderId, paymentId });

        if (!orderId || !paymentId) {
            throw new BadRequestException(
                'Stripe metadata is missing',
            );
        }

        const paymentIntentId =
            typeof session.payment_intent === 'string'
                ? session.payment_intent
                : session.payment_intent?.id ?? null;

        await this.prisma.db.transaction(async (tx) => {
            const payment = await tx.orm.public.Payments.where({ id: paymentId }).first();

            console.log('[Stripe] Payment record:', payment);

            if (!payment) {
                throw new NotFoundException(
                    `Payment ${paymentId} not found`,
                );
            }

            if (payment.orderId !== orderId) {
                throw new BadRequestException(
                    'Payment does not belong to this order',
                );
            }

            if (payment.status === PAYMENT_STATUS.SUCCEEDED) {
                return;
            }

            const expectedAmount = Math.round(Number(payment.amount) * 100);
            if (session.amount_total !== expectedAmount) {
                throw new BadRequestException(
                    'Stripe payment amount does not match the order amount',
                );
            }

            if (session.currency?.toLowerCase() !== payment.currency.toLowerCase()) {
                throw new BadRequestException(
                    'Stripe payment currency does not match',
                );
            }

            const orderProducts = await tx.orm.public.OrderProducts.where({ orderId }).all();
            for (const product of orderProducts) {
                const stock = await tx.orm.public.ProductStocks.where({ id: product.stockId }).first();

                if (!stock) {
                    throw new NotFoundException(`Stock ${product.stockId} not found`);
                }

                if (stock.stock < product.amount) {
                    throw new BadRequestException(
                        `Insufficient stock for product ${product.productId}`,
                    );
                }

                await tx.orm.public.ProductStocks.where({ id: product.stockId }).update({
                    stock: stock.stock - product.amount,
                });
            }

            console.log(`[Stripe] Updating payment ${paymentId} → PAID`);

            await tx.orm.public.Payments.where({ id: paymentId }).update({
                status: PAYMENT_STATUS.SUCCEEDED,
                stripeCheckoutSessionId: session.id,
                stripePaymentIntentId: paymentIntentId,
                updatedAt: Temporal.Now.instant(),
            });

            console.log(`[Stripe] Updating order ${orderId} paymentStatus → PAID`);

            await tx.orm.public.Orders.where({ id: orderId }).update({
                paymentStatus: PAYMENT_STATUS.SUCCEEDED,
                orderStatus: ORDER_STATUS.PENDING,
            });

            console.log(`[Stripe] Order ${orderId} payment completed successfully`);
        });
    }

    private async handleCheckoutExpired(
        session: Stripe.Checkout.Session,
    ) {
        const paymentId = Number(
            session.metadata?.paymentId,
        );

        if (!paymentId) {
            return;
        }

        await this.prisma.db.orm.public.Payments.where({
            id: paymentId,
            status: ORDER_STATUS.PENDING,
        }).update({
            status: ORDER_STATUS.CANCELLED,
        });
    }

    private async handlePaymentFailed(
        paymentIntent: Stripe.PaymentIntent,
    ) {
        const paymentId = Number(
            paymentIntent.metadata?.paymentId,
        );

        if (!paymentId) {
            return;
        }

        const payment = await this.prisma.db.orm.public.Payments
            .where({
                id: paymentId,
            })
            .first();

        if (!payment) {
            throw new NotFoundException(`Payment ${paymentId} not found`);
        }

        if (payment.status === PAYMENT_STATUS.FAILED) {
            return;
        }

        await this.prisma.db.orm.public.Payments.where({ id: paymentId }).update({
            status: PAYMENT_STATUS.FAILED,
            stripePaymentIntentId:
                paymentIntent.id,
            failureMessage:
                paymentIntent.last_payment_error
                    ?.message ?? 'Payment failed',
            updatedAt: Temporal.Now.instant(),
        });
    }

    private async handleChargeRefunded(charge: Stripe.Charge) {
        if (!charge.refunded) {
            return;
        }

        const paymentIntentId =
            typeof charge.payment_intent === 'string'
                ? charge.payment_intent
                : charge.payment_intent?.id;

        if (!paymentIntentId) {
            return;
        }

        const payment = await this.prisma.db.orm.public.Payments.where({ stripePaymentIntentId: paymentIntentId }).first();

        if (!payment) {
            return;
        }

        await this.prisma.db.transaction(async (tx) => {
            await tx.orm.public.Payments.where({ id: payment.id }).update({
                status: PAYMENT_STATUS.REFUNDED,
                updatedAt: Temporal.Now.instant(),
            });
            await tx.orm.public.Orders.where({ id: payment.orderId }).update({
                paymentStatus: PAYMENT_STATUS.REFUNDED,
            });
        });
    }
}