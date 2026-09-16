import { Injectable } from '@nestjs/common';

import { PrismaService } from '../../prisma/prisma.service';

import type { CreateOrderProductDto } from './dto/create-order-product.dto';
import type { UpdateOrderProductDto } from './dto/update-order-product.dto';

@Injectable()
export class OrderProductsService {
  constructor(private readonly prisma: PrismaService) { }

  create(createOrderProductDto: CreateOrderProductDto) {
    return this.prisma.db.orm.public.OrderProducts.create(createOrderProductDto);
  }

  findAll() {
    return this.prisma.db.orm.public.OrderProducts.all();
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.OrderProducts.where({ id }).first();
  }

  update(id: number, updateOrderProductDto: UpdateOrderProductDto) {
    return this.prisma.db.orm.public.OrderProducts.where({ id }).update(updateOrderProductDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.OrderProducts.where({ id }).delete();
    return {
      message: 'Order product deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.OrderProducts.where({}).deleteAndCount();
    return {
      message: 'All order products deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
