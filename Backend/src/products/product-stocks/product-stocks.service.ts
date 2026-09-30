import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';

import { PrismaService } from '../../prisma/prisma.service';

import type { JwtPayload } from '../../auth/interfaces/jwt-payload.interface';

import type { CreateProductStockDto } from './dto/create-product-stock.dto';
import type { UpdateProductStockDto } from './dto/update-product-stock.dto';

@Injectable()
export class ProductStocksService {
  constructor(private readonly prisma: PrismaService) { }

  async create(
    currentUser: JwtPayload,
    dto: CreateProductStockDto,
  ) {
    if (currentUser.role === 2) {
      throw new ForbiddenException(
        'You do not have permission to create product stocks',
      );
    }

    const product =
      await this.prisma.db.orm.public.Products
        .where({ id: dto.productId })
        .first();

    if (!product) {
      throw new BadRequestException('Product not found');
    }

    const shop =
      await this.prisma.db.orm.public.Shops
        .where({ id: dto.shopId })
        .first();

    if (!shop) {
      throw new BadRequestException('Shop not found');
    }

    return this.prisma.db.orm.public.ProductStocks
      .create(dto);
  }

  findAll() {
    return this.prisma.db.orm.public.ProductStocks.all();
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.ProductStocks.where({ id }).first();
  }

  async update(
    id: number,
    currentUser: JwtPayload,
    dto: UpdateProductStockDto,
  ) {
    if (currentUser.role === 2) {
      throw new ForbiddenException(
        'You do not have permission to update product stocks',
      );
    }

    const existing =
      await this.prisma.db.orm.public.ProductStocks
        .where({ id })
        .first();

    if (!existing) {
      throw new NotFoundException(
        'Product stock not found',
      );
    }

    const product =
      await this.prisma.db.orm.public.Products
        .where({ id: dto.productId })
        .first();

    if (!product) {
      throw new BadRequestException('Product not found');
    }

    const shop =
      await this.prisma.db.orm.public.Shops
        .where({ id: dto.shopId })
        .first();

    if (!shop) {
      throw new BadRequestException('Shop not found');
    }

    return this.prisma.db.orm.public.ProductStocks
      .where({ id })
      .update(dto);
  }

  async remove(id: number, currentUser: JwtPayload) {
    if (currentUser.role === 2) {
      throw new ForbiddenException("You do not have permission to delete product stocks");
    }

    await this.prisma.db.orm.public.ProductStocks.where({ id }).delete();
    return {
      message: 'Product stock deleted successfully',
    };
  }

  async removeAll(
    currentUser: JwtPayload
  ): Promise<{
    message: string;
    deletedCount: number;
  }> {
    if (currentUser.role === 2) {
      throw new ForbiddenException("You do not have permission to delete product stocks");
    }

    const deletedCount = await this.prisma.db.orm.public.ProductStocks.where({}).deleteAndCount();
    return {
      message: 'All product stocks deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
