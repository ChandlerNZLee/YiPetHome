import { BadRequestException, ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';

import { PrismaService } from '../../prisma/prisma.service';

import type { JwtPayload } from '../../auth/interfaces/jwt-payload.interface';

import type { CreateRechargeOrderDto } from './dto/create-recharge-order.dto';

@Injectable()
export class RechargeOrdersService {
    constructor(private readonly prisma: PrismaService) { }

    async create(currentUser: JwtPayload, createRechargeOrderDto: CreateRechargeOrderDto) {
        const { bonusId } = createRechargeOrderDto;

        const userId =
            currentUser.role === 2
                ? currentUser.userId
                : createRechargeOrderDto.userId;

        if (!userId) {
            throw new BadRequestException(
                'User ID is required',
            );
        }

        const user =
            await this.prisma.db.orm.public.Users
                .where({
                    id: userId,
                })
                .first();

        if (!user) {
            throw new NotFoundException(
                `User ${userId} not found`,
            );
        }

        const bonus = await this.prisma.db.orm.public.RechargeBonuses.where({ id: bonusId }).first();
        if (!bonus) {
            throw new NotFoundException(`Recharge bonus ${bonusId} not found`);
        }

        if (bonus.activationStatus !== 1) {
            throw new BadRequestException('Recharge bonus is not available');
        }

        const amount = bonus.rechargeAmount;
        const rechargeAmount = bonus.rechargeAmount + bonus.giftAmount;

        const result = await this.prisma.db.transaction(async (tx) => {
            const rechargeOrder = await tx.orm.public.RechargeOrders.create({
                userId,
                bonusId,
                amount,
                rechargeAmount,
                paymentStatus: 0,
                transactionId: null,
            });

            return rechargeOrder;
        });

        return {
            success: true,
            message: 'Recharge order created successfully',
            data: {
                ...result,
                bonus: bonus,
            },
        };
    }

    async findAll(currentUser: JwtPayload) {
        const orders = currentUser.role === 2
            ? await this.prisma.db.orm.public.RechargeOrders
                .where({
                    userId: currentUser.userId,
                })
                .all()
            : await this.prisma.db.orm.public.RechargeOrders.all();

        return orders;
    }

    async findOne(
        id: number,
        currentUser: JwtPayload,
    ) {
        const order =
            currentUser.role === 2
                ? await this.prisma.db.orm.public.RechargeOrders
                    .where({
                        id,
                        userId: currentUser.userId,
                    })
                    .first()
                : await this.prisma.db.orm.public.RechargeOrders
                    .where({
                        id,
                    })
                    .first();

        if (!order) {
            throw new NotFoundException(
                'Recharge order not found',
            );
        }

        return order;
    }

    async remove(id: number, currentUser: JwtPayload) {
        if (currentUser.role === 2) {
            throw new ForbiddenException(
                'You do not have permission to delete orders',
            );
        }

        await this.prisma.db.orm.public.RechargeOrders.where({ id }).delete();
        return {
            message: 'Recharge order deleted successfully',
        };
    }

    async removeAll(
        currentUser: JwtPayload
    ): Promise<{
        message: string;
        deletedCount: number;
    }> {
        if (currentUser.role === 2) {
            throw new ForbiddenException(
                'You do not have permission to delete orders',
            );
        }

        const deletedCount = await this.prisma.db.orm.public.RechargeOrders.where({}).deleteAndCount();
        return {
            message: 'All recharge orders deleted successfully',
            deletedCount: deletedCount,
        };
    }
}
