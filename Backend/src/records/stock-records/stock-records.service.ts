import { Injectable } from '@nestjs/common';

import { PrismaService } from '../../prisma/prisma.service';

import type { CreateStockRecordDto } from './dto/create-stock-record.dto';
import type { UpdateStockRecordDto } from './dto/update-stock-record.dto';

@Injectable()
export class StockRecordsService {
  constructor(private readonly prisma: PrismaService) { }

  create(createStockRecordDto: CreateStockRecordDto) {
    return this.prisma.db.orm.public.StockRecords.create(createStockRecordDto);
  }

  findAll() {
    return this.prisma.db.orm.public.StockRecords.all();
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.StockRecords.where({ id }).first();
  }

  update(id: number, updateStockRecordDto: UpdateStockRecordDto) {
    return this.prisma.db.orm.public.StockRecords.where({ id }).update(updateStockRecordDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.StockRecords.where({ id }).delete();
    return {
      message: 'Stock record deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.StockRecords.where({}).deleteAndCount();
    return {
      message: 'All stock records deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
