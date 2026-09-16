import { Injectable } from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';

import type { CreateGroomerDto } from './dto/create-groomer.dto';
import type { UpdateGroomerDto } from './dto/update-groomer.dto';

@Injectable()
export class GroomersService {
    constructor(private readonly prisma: PrismaService) { }

    create(createGroomerDto: CreateGroomerDto) {
        return this.prisma.db.orm.public.Groomers.create(createGroomerDto);
    }

    async findAll() {
        const groomers = await this.prisma.db.orm.public.Groomers.all();
        const shops = await this.prisma.db.orm.public.Shops.all();

        return groomers.map((groomer) => {
            const shop = shops.find((shop) => shop.id === groomer.shopId);
            return {
                ...groomer,
                shop_name: shop?.name ?? null,
            };
        });
    }

    findOne(id: number) {
        return this.prisma.db.orm.public.Groomers.where({ id }).first();
    }

    async findByShopId(id: number) {
        return this.prisma.db.orm.public.Groomers.where({ shopId: id }).all();
    }

    update(id: number, updateGroomerDto: UpdateGroomerDto) {
        return this.prisma.db.orm.public.Groomers.where({ id }).update(updateGroomerDto);
    }

    async remove(id: number) {
        await this.prisma.db.orm.public.Groomers.where({ id }).delete();
        return {
            message: 'Groomer deleted successfully',
        };
    }

    async removeAll(): Promise<{
        message: string;
        deletedCount: number;
    }> {
        const deletedCount = await this.prisma.db.orm.public.Groomers.where({}).deleteAndCount();
        return {
            message: 'All groomers deleted successfully',
            deletedCount: deletedCount,
        };
    }
}
