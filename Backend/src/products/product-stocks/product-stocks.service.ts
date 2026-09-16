import { Injectable } from '@nestjs/common';

import { PrismaService } from '../../prisma/prisma.service';

import type { CreateProductStockDto } from './dto/create-product-stock.dto';
import type { UpdateProductStockDto } from './dto/update-product-stock.dto';

@Injectable()
export class ProductStocksService {
  constructor(private readonly prisma: PrismaService) { }

  create(createProductStockDto: CreateProductStockDto) {
    return this.prisma.db.orm.public.ProductStocks.create(createProductStockDto);
  }

  findAll() {
    return this.prisma.db.orm.public.ProductStocks.all();
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.ProductStocks.where({ id }).first();
  }

  update(id: number, updateProductStockDto: UpdateProductStockDto) {
    return this.prisma.db.orm.public.ProductStocks.where({ id }).update(updateProductStockDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.ProductStocks.where({ id }).delete();
    return {
      message: 'Product stock deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.ProductStocks.where({}).deleteAndCount();
    return {
      message: 'All product stocks deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
