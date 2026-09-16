import { Injectable } from '@nestjs/common';

import { PrismaService } from '../../prisma/prisma.service';

import type { CreateSpendRecordDto } from './dto/create-spend-record.dto';
import type { UpdateSpendRecordDto } from './dto/update-spend-record.dto';

@Injectable()
export class SpendRecordsService {
  constructor(private readonly prisma: PrismaService) { }

  create(createSpendRecordDto: CreateSpendRecordDto) {
    return this.prisma.db.orm.public.SpendRecords.create(createSpendRecordDto);
  }

  findAll() {
    return this.prisma.db.orm.public.SpendRecords.all();
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.SpendRecords.where({ id }).first();
  }

  update(id: number, updateSpendRecordDto: UpdateSpendRecordDto) {
    return this.prisma.db.orm.public.SpendRecords.where({ id }).update(updateSpendRecordDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.SpendRecords.where({ id }).delete();
    return {
      message: 'Spend record deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.SpendRecords.where({}).deleteAndCount();
    return {
      message: 'All spend records deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
