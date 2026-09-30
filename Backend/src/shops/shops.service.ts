import {
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';

import type { JwtPayload } from '../auth/interfaces/jwt-payload.interface';

import type { CreateShopDto } from './dto/create-shop.dto';
import type { UpdateShopDto } from './dto/update-shop.dto';

@Injectable()
export class ShopsService {
  constructor(private readonly prisma: PrismaService) { }

  create(
    currentUser: JwtPayload,
    createShopDto: CreateShopDto,
  ) {
    if (currentUser.role === 2) {
      throw new ForbiddenException(
        'You do not have permission to create shops',
      );
    }

    return this.prisma.db.orm.public.Shops.create(
      createShopDto,
    );
  }

  findAll() {
    return this.prisma.db.orm.public.Shops.all();
  }

  async findOne(id: number) {
    const shop =
      await this.prisma.db.orm.public.Shops
        .where({ id })
        .first();

    if (!shop) {
      throw new NotFoundException(
        'Shop not found',
      );
    }

    return shop;
  }

  async update(
    id: number,
    currentUser: JwtPayload,
    updateShopDto: UpdateShopDto,
  ) {
    if (currentUser.role === 2) {
      throw new ForbiddenException(
        'You do not have permission to update shops',
      );
    }

    const shop =
      await this.prisma.db.orm.public.Shops
        .where({ id })
        .first();

    if (!shop) {
      throw new NotFoundException(
        'Shop not found',
      );
    }

    await this.prisma.db.orm.public.Shops
      .where({ id })
      .update(updateShopDto);

    return {
      success: true,
      message: 'Shop updated successfully',
    };
  }

  async remove(
    id: number,
    currentUser: JwtPayload,
  ) {
    if (currentUser.role === 2) {
      throw new ForbiddenException(
        'You do not have permission to delete shops',
      );
    }

    const shop =
      await this.prisma.db.orm.public.Shops
        .where({ id })
        .first();

    if (!shop) {
      throw new NotFoundException(
        'Shop not found',
      );
    }

    await this.prisma.db.orm.public.Shops
      .where({ id })
      .delete();

    return {
      message: 'Shop deleted successfully',
    };
  }

  async removeAll(
    currentUser: JwtPayload,
  ): Promise<{
    message: string;
    deletedCount: number;
  }> {
    if (currentUser.role === 2) {
      throw new ForbiddenException(
        'You do not have permission to delete all shops',
      );
    }

    const deletedCount =
      await this.prisma.db.orm.public.Shops
        .where({})
        .deleteAndCount();

    return {
      message: 'All shops deleted successfully',
      deletedCount,
    };
  }
}
