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
        orderType: number,
        userId: number,
    ) {
        let lineItems: Stripe.Checkout.SessionCreateParams.LineItem[] = [];
        let totalPrice = 0;
        if (orderType === 0) {
            const order = await this.prisma.db.orm.public.ShopOrders.where({ id: orderId }).first();

            if (!order) {
                throw new NotFoundException('Order not found');
            }

            if (order.userId !== userId) {
                throw new BadRequestException(
                    'This order does not belong to the current user',
                );
            }

            const succeededPayment = await this.prisma.db.orm.public.Payments.where({
                paymentType: 0,
                shopOrderId: order.id,
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

            const orderProducts = await this.prisma.db.orm.public.ShopOrderProducts.where({ orderId: order.id }).all();

            for (const item of orderProducts) {
                const stock = await this.prisma.db.orm.public.ProductStocks.where({ id: item.stockId }).first();

                if (!stock || stock.stock < item.amount) {
                    throw new BadRequestException(
                        `Insufficient stock for stock ID ${item.stockId}`,
                    );
                }
            }

            totalPrice = Number(order.totalPrice);
            lineItems = [
                {
                    quantity: 1,
                    price_data: {
                        currency:
                            this.configService.get<string>(
                                'STRIPE_CURRENCY',
                            ) ?? 'nzd',
                        unit_amount: Math.round(
                            totalPrice * 100,
                        ),
                        product_data: {
                            name: `Order #${orderId}`,
                            metadata: {
                                orderId: String(orderId),
                            },
                        },
                    },
                },
            ];
        } else if (orderType === 1) {
            const rechargeOrder = await this.prisma.db.orm.public.RechargeOrders.where({ id: orderId }).first();

            if (!rechargeOrder) {
                throw new NotFoundException('Recharge Order not found');
            }

            if (rechargeOrder.userId !== userId) {
                throw new BadRequestException(
                    'This order does not belong to the current user',
                );
            }

            const succeededPayment = await this.prisma.db.orm.public.Payments.where({
                paymentType: 1,
                rechargeOrderId: rechargeOrder.id,
                status: PAYMENT_STATUS.SUCCEEDED,
            }).first();

            if (succeededPayment) {
                throw new BadRequestException(
                    'Order has already been paid',
                );
            }

            if (rechargeOrder.paymentStatus === PAYMENT_STATUS.SUCCEEDED) {
                throw new BadRequestException('Order has already been paid');
            }

            totalPrice = Number(rechargeOrder.amount);
            lineItems = [
                {
                    quantity: 1,
                    price_data: {
                        currency:
                            this.configService.get<string>(
                                'STRIPE_CURRENCY',
                            ) ?? 'nzd',
                        unit_amount: Math.round(
                            totalPrice * 100,
                        ),
                        product_data: {
                            name: `Order #${orderId}`,
                            metadata: {
                                orderId: String(orderId),
                            },
                        },
                    },
                },
            ];
        } else {
            throw new BadRequestException('Appointment payment is not implemented yet');
        }

        const payment = await this.prisma.db.orm.public.Payments.create({
            paymentType: orderType,
            shopOrderId: orderType === 0 ? orderId : null,
            rechargeOrderId: orderType === 1 ? orderId : null,
            provider: 'STRIPE',
            amount: totalPrice,
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
                        orderId: String(orderId),
                        orderType: String(orderType),
                        paymentId: String(payment.id),
                    },
                    payment_intent_data: {
                        metadata: {
                            orderId: String(orderId),
                            orderType: String(orderType),
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
                orderId,
                orderType,
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
        switch (event.type) {
            case 'checkout.session.completed':
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
        if (session.payment_status !== 'paid') {
            return;
        }

        const orderId = Number(session.metadata?.orderId);
        const orderType = Number(session.metadata?.orderType);
        const paymentId = Number(session.metadata?.paymentId);

        if (!orderId || !paymentId) {
            throw new BadRequestException(
                'Stripe metadata is missing',
            );
        }

        if (orderType === 0) {
            return this.handleShopPaymentCompleted(
                session,
                orderId,
                paymentId,
            );
        } else if (orderType === 1) {
            return this.handleRechargePaymentCompleted(
                session,
                orderId,
                paymentId,
            );
        } else {
            return this.handleAppointmentPaymentCompleted(
                session,
                orderId,
                paymentId,
            );
        }

        throw new BadRequestException('Unsupported payment type');
    }

    private async handleShopPaymentCompleted(session: Stripe.Checkout.Session, orderId: number, paymentId: number) {
        const paymentIntentId =
            typeof session.payment_intent === 'string'
                ? session.payment_intent
                : session.payment_intent?.id ?? null;

        await this.prisma.db.transaction(async (tx) => {
            const payment = await tx.orm.public.Payments.where({ id: paymentId }).first();

            if (!payment) {
                throw new NotFoundException(
                    `Payment ${paymentId} not found`,
                );
            }

            if (payment.paymentType !== 0) {
                throw new BadRequestException(
                    'Invalid payment type',
                );
            }

            if (payment.shopOrderId !== orderId) {
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

            const orderProducts = await tx.orm.public.ShopOrderProducts.where({ orderId }).all();
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

            await tx.orm.public.Payments.where({ id: paymentId }).update({
                status: PAYMENT_STATUS.SUCCEEDED,
                stripeCheckoutSessionId: session.id,
                stripePaymentIntentId: paymentIntentId,
                updatedAt: Temporal.Now.instant(),
            });

            await tx.orm.public.ShopOrders.where({ id: orderId }).update({
                paymentStatus: PAYMENT_STATUS.SUCCEEDED,
                orderStatus: ORDER_STATUS.PENDING,
            });
        });
    }

    private async handleRechargePaymentCompleted(session: Stripe.Checkout.Session, orderId: number, paymentId: number) {
        const paymentIntentId =
            typeof session.payment_intent === 'string'
                ? session.payment_intent
                : session.payment_intent?.id ?? null;

        await this.prisma.db.transaction(async (tx) => {
            const payment = await tx.orm.public.Payments.where({ id: paymentId }).first();

            if (!payment) {
                throw new NotFoundException(
                    `Payment ${paymentId} not found`,
                );
            }

            if (payment.paymentType !== 1) {
                throw new BadRequestException(
                    'Invalid payment type',
                );
            }

            if (payment.rechargeOrderId !== orderId) {
                throw new BadRequestException(
                    'Payment does not belong to this recharge order',
                );
            }

            if (payment.status === PAYMENT_STATUS.SUCCEEDED) {
                return;
            }

            const rechargeOrder = await tx.orm.public.RechargeOrders.where({ id: orderId }).first();
            if (!rechargeOrder) {
                throw new NotFoundException(
                    `Recharge order ${orderId} not found`,
                );
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

            const user = await tx.orm.public.Users.where({ id: rechargeOrder.userId }).first();
            if (!user) {
                throw new NotFoundException(
                    `User ${rechargeOrder.userId} not found`,
                );
            }

            const balanceBefore = Number(user.balance);
            const balanceAfter = balanceBefore + Number(rechargeOrder.rechargeAmount);

            await tx.orm.public.Payments.where({ id: paymentId }).update({
                status: PAYMENT_STATUS.SUCCEEDED,
                stripeCheckoutSessionId: session.id,
                stripePaymentIntentId: paymentIntentId,
                updatedAt: Temporal.Now.instant(),
            });

            await tx.orm.public.RechargeOrders.where({ id: orderId }).update({
                paymentStatus: PAYMENT_STATUS.SUCCEEDED,
                transactionId: paymentIntentId,
            });

            await tx.orm.public.Users.where({ id: user.id }).update({
                balance: balanceAfter,
            });

            await tx.orm.public.RechargeRecords.create({
                userId: user.id,
                bonusId: rechargeOrder.bonusId,
                balanceBefore,
                balanceAfter,
                createTime: new Date().toISOString(),
            });
        });
    }

    private async handleAppointmentPaymentCompleted(session: Stripe.Checkout.Session, orderId: number, paymentId: number) {

    }

    private async handleCheckoutExpired(
        session: Stripe.Checkout.Session,
    ) {
        const paymentId = Number(session.metadata?.paymentId);

        if (!paymentId) {
            return;
        }

        const payment = await this.prisma.db.orm.public.Payments.where({ id: paymentId }).first();

        if (!payment) {
            return;
        }

        if (payment.status === PAYMENT_STATUS.SUCCEEDED) {
            return;
        }

        await this.prisma.db.orm.public.Payments.where({
            id: paymentId,
        }).update({
            status: ORDER_STATUS.CANCELLED,
            updatedAt: Temporal.Now.instant(),
        });
    }

    private async handlePaymentFailed(
        paymentIntent: Stripe.PaymentIntent,
    ) {
        const paymentId = Number(paymentIntent.metadata?.paymentId);

        if (!paymentId) {
            return;
        }

        const payment = await this.prisma.db.orm.public.Payments.where({ id: paymentId }).first();

        if (!payment) {
            throw new NotFoundException(`Payment ${paymentId} not found`);
        }

        if (payment.status === PAYMENT_STATUS.SUCCEEDED) {
            return;
        }

        if (payment.status === PAYMENT_STATUS.FAILED) {
            return;
        }

        await this.prisma.db.orm.public.Payments.where({ id: paymentId }).update({
            status: PAYMENT_STATUS.FAILED,
            stripePaymentIntentId: paymentIntent.id,
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

        if (
            payment.status ===
            PAYMENT_STATUS.REFUNDED
        ) {
            return;
        }

        if (payment.paymentType === 0) {
            await this.handleShopRefunded(payment.id);

            return;
        } else if (payment.paymentType === 1) {
            await this.handleRechargeRefunded(payment.id);

            return;
        } else {
            await this.handleAppointmentRefunded(payment.id);

            return;
        }
    }

    private async handleShopRefunded(paymentId: number) {
        await this.prisma.db.transaction(async (tx) => {
            const payment = await tx.orm.public.Payments.where({ id: paymentId }).first();

            if (!payment) {
                throw new NotFoundException(`Payment ${paymentId} not found`);
            }

            if (payment.paymentType !== 0) {
                throw new BadRequestException('Invalid payment type');
            }

            if (!payment.shopOrderId) {
                throw new BadRequestException('Payment order ID is missing');
            }

            if (payment.status === PAYMENT_STATUS.REFUNDED) {
                return;
            }

            await tx.orm.public.Payments.where({ id: payment.id }).update({
                status: PAYMENT_STATUS.REFUNDED,
                updatedAt: Temporal.Now.instant(),
            });

            await tx.orm.public.ShopOrders.where({ id: payment.shopOrderId }).update({
                paymentStatus: PAYMENT_STATUS.REFUNDED,
            });
        });
    }

    private async handleRechargeRefunded(paymentId: number) {
        await this.prisma.db.transaction(async (tx) => {
            const payment = await tx.orm.public.Payments.where({ id: paymentId }).first();

            if (!payment) {
                throw new NotFoundException(`Payment ${paymentId} not found`);
            }

            if (payment.paymentType !== 1) {
                throw new BadRequestException('Invalid payment type');
            }

            if (!payment.rechargeOrderId) {
                throw new BadRequestException('Recharge order ID is missing');
            }

            if (payment.status === PAYMENT_STATUS.REFUNDED) {
                return;
            }

            const rechargeOrder = await tx.orm.public.RechargeOrders.where({ id: payment.rechargeOrderId }).first();

            if (!rechargeOrder) {
                throw new NotFoundException(`Recharge order ${payment.rechargeOrderId} not found`);
            }

            await tx.orm.public.Payments.where({ id: payment.id }).update({
                status: PAYMENT_STATUS.REFUNDED,
                updatedAt: Temporal.Now.instant(),
            });

            await tx.orm.public.RechargeOrders.where({ id: rechargeOrder.id }).update({
                paymentStatus: PAYMENT_STATUS.REFUNDED,
            });
        });
    }

    private async handleAppointmentRefunded(paymentId: number) { }
}