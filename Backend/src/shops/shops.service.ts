import { Injectable } from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';

import type { CreateShopDto } from './dto/create-shop.dto';
import type { UpdateShopDto } from './dto/update-shop.dto';

@Injectable()
export class ShopsService {
  constructor(private readonly prisma: PrismaService) { }

  create(createShopDto: CreateShopDto) {
    return this.prisma.db.orm.public.Shops.create(createShopDto);
  }

  findAll() {
    return this.prisma.db.orm.public.Shops.all();
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.Shops.where({ id }).first();
  }

  update(id: number, updateShopDto: UpdateShopDto) {
    return this.prisma.db.orm.public.Shops.where({ id }).update(updateShopDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.Shops.where({ id }).delete();
    return {
      message: 'Shop deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.Shops.where({}).deleteAndCount();
    return {
      message: 'All shops deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
