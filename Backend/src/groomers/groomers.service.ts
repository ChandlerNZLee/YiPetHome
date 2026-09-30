import {
    BadRequestException,
    ForbiddenException,
    Injectable,
    NotFoundException,
} from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';

import type { JwtPayload } from '../auth/interfaces/jwt-payload.interface';

import type { CreateGroomerDto } from './dto/create-groomer.dto';
import type { UpdateGroomerDto } from './dto/update-groomer.dto';

@Injectable()
export class GroomersService {
    constructor(private readonly prisma: PrismaService) { }

    async create(
        currentUser: JwtPayload,
        createGroomerDto: CreateGroomerDto,
    ) {
        if (currentUser.role === 2) {
            throw new ForbiddenException(
                'You do not have permission to create groomers',
            );
        }

        const shop =
            await this.prisma.db.orm.public.Shops
                .where({
                    id: createGroomerDto.shopId,
                })
                .first();

        if (!shop) {
            throw new BadRequestException(
                'Shop not found',
            );
        }

        return this.prisma.db.orm.public.Groomers
            .create(createGroomerDto);
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

    async findOne(id: number) {
        const groomer =
            await this.prisma.db.orm.public.Groomers
                .where({ id })
                .first();

        if (!groomer) {
            throw new NotFoundException(
                'Groomer not found',
            );
        }

        return groomer;
    }

    async findByShopId(id: number) {
        return this.prisma.db.orm.public.Groomers.where({ shopId: id }).all();
    }

    async update(
        id: number,
        currentUser: JwtPayload,
        updateGroomerDto: UpdateGroomerDto,
    ) {
        if (currentUser.role === 2) {
            throw new ForbiddenException(
                'You do not have permission to update groomers',
            );
        }

        const groomer =
            await this.prisma.db.orm.public.Groomers
                .where({ id })
                .first();

        if (!groomer) {
            throw new NotFoundException(
                'Groomer not found',
            );
        }

        const shop =
            await this.prisma.db.orm.public.Shops
                .where({
                    id: updateGroomerDto.shopId,
                })
                .first();

        if (!shop) {
            throw new BadRequestException(
                'Shop not found',
            );
        }

        await this.prisma.db.orm.public.Groomers
            .where({ id })
            .update(updateGroomerDto);

        return {
            success: true,
            message: 'Groomer updated successfully',
        };
    }

    async remove(
        id: number,
        currentUser: JwtPayload,
    ) {
        if (currentUser.role === 2) {
            throw new ForbiddenException(
                'You do not have permission to delete groomers',
            );
        }

        const groomer =
            await this.prisma.db.orm.public.Groomers
                .where({ id })
                .first();

        if (!groomer) {
            throw new NotFoundException(
                'Groomer not found',
            );
        }

        await this.prisma.db.orm.public.Groomers
            .where({ id })
            .delete();

        return {
            message: 'Groomer deleted successfully',
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
                'You do not have permission to delete all groomers',
            );
        }

        const deletedCount = await this.prisma.db.orm.public.Groomers.where({}).deleteAndCount();
        return {
            message: 'All groomers deleted successfully',
            deletedCount: deletedCount,
        };
    }
}
