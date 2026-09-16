import { Injectable } from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';

import type { CreateBannerDto } from './dto/create-banner.dto';
import type { UpdateBannerDto } from './dto/update-banner.dto';

@Injectable()
export class BannersService {
  constructor(private readonly prisma: PrismaService) { }

  create(createBannerDto: CreateBannerDto) {
    return this.prisma.db.orm.public.Banners.create(createBannerDto);
  }

  findAll() {
    return this.prisma.db.orm.public.Banners.all();
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.Banners.where({ id }).first();
  }

  update(id: number, updateBannerDto: UpdateBannerDto) {
    return this.prisma.db.orm.public.Banners.where({ id }).update(updateBannerDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.Banners.where({ id }).delete();
    return {
      message: 'Banner deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.Banners.where({}).deleteAndCount();
    return {
      message: 'All banners deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
