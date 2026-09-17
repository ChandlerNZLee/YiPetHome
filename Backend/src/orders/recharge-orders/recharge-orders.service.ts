import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';

import { PrismaService } from '../../prisma/prisma.service';

import type { CreateRechargeOrderDto } from './dto/create-recharge-order.dto';

@Injectable()
export class RechargeOrdersService {
    constructor(private readonly prisma: PrismaService) { }

    async create(createRechargeOrderDto: CreateRechargeOrderDto) {
        const { userId, bonusId } = createRechargeOrderDto;

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

    findAll() {
        return this.prisma.db.orm.public.RechargeOrders.all();
    }

    findOne(id: number) {
        return this.prisma.db.orm.public.RechargeOrders.where({ id }).first();
    }

    async remove(id: number) {
        await this.prisma.db.orm.public.RechargeOrders.where({ id }).delete();
        return {
            message: 'Recharge order deleted successfully',
        };
    }

    async removeAll(): Promise<{
        message: string;
        deletedCount: number;
    }> {
        const deletedCount = await this.prisma.db.orm.public.RechargeOrders.where({}).deleteAndCount();
        return {
            message: 'All recharge orders deleted successfully',
            deletedCount: deletedCount,
        };
    }
}
