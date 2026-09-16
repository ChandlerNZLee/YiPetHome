import { Injectable } from '@nestjs/common';

import { PrismaService } from '../../prisma/prisma.service';

import type { CreateServicePriceDto } from './dto/create-service-price.dto';
import type { UpdateServicePriceDto } from './dto/update-service-price.dto';

@Injectable()
export class ServicePricesService {
  constructor(private readonly prisma: PrismaService) { }

  create(createServicePriceDto: CreateServicePriceDto) {
    return this.prisma.db.orm.public.ServicePrices.create(createServicePriceDto);
  }

  findAll() {
    return this.prisma.db.orm.public.ServicePrices.all();
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.ServicePrices.where({ id }).first();
  }

  update(id: number, updateServicePriceDto: UpdateServicePriceDto) {
    return this.prisma.db.orm.public.ServicePrices.where({ id }).update(updateServicePriceDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.ServicePrices.where({ id }).delete();
    return {
      message: 'Service price deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.ServicePrices.where({}).deleteAndCount();
    return {
      message: 'All service prices deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
