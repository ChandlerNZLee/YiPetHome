import { Injectable } from '@nestjs/common';

import { PrismaService } from '../../prisma/prisma.service';

import type { CreateProductImageDto } from './dto/create-product-image.dto';
import type { UpdateProductImageDto } from './dto/update-product-image.dto';

@Injectable()
export class ProductImagesService {
  constructor(private readonly prisma: PrismaService) { }

  create(createProductImageDto: CreateProductImageDto) {
    return this.prisma.db.orm.public.ProductImages.create(createProductImageDto);
  }

  findAll() {
    return this.prisma.db.orm.public.ProductImages.all();
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.ProductImages.where({ id }).first();
  }

  update(id: number, updateProductImageDto: UpdateProductImageDto) {
    return this.prisma.db.orm.public.ProductImages.where({ id }).update(updateProductImageDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.ProductImages.where({ id }).delete();
    return {
      message: 'Product image deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.ProductImages.where({}).deleteAndCount();
    return {
      message: 'All product images deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
