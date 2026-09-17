import { Injectable } from '@nestjs/common';

import { PrismaService } from '../../../prisma/prisma.service';

import type { CreateShopOrderProductDto } from './dto/create-shop-order-product.dto';
import type { UpdateShopOrderProductDto } from './dto/update-shop-order-product.dto';

@Injectable()
export class ShopOrderProductsService {
  constructor(private readonly prisma: PrismaService) { }

  create(createShopOrderProductDto: CreateShopOrderProductDto) {
    return this.prisma.db.orm.public.ShopOrderProducts.create(createShopOrderProductDto);
  }

  findAll() {
    return this.prisma.db.orm.public.ShopOrderProducts.all();
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.ShopOrderProducts.where({ id }).first();
  }

  update(id: number, updateShopOrderProductDto: UpdateShopOrderProductDto) {
    return this.prisma.db.orm.public.ShopOrderProducts.where({ id }).update(updateShopOrderProductDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.ShopOrderProducts.where({ id }).delete();
    return {
      message: 'Shop order product deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.ShopOrderProducts.where({}).deleteAndCount();
    return {
      message: 'All shop order products deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
