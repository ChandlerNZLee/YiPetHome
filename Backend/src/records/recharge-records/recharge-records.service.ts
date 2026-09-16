import { Injectable } from '@nestjs/common';

import { PrismaService } from '../../prisma/prisma.service';

import type { CreateRechargeRecordDto } from './dto/create-recharge-record.dto';
import type { UpdateRechargeRecordDto } from './dto/update-recharge-record.dto';

@Injectable()
export class RechargeRecordsService {
  constructor(private readonly prisma: PrismaService) { }

  create(createRechargeRecordDto: CreateRechargeRecordDto) {
    return this.prisma.db.orm.public.RechargeRecords.create(createRechargeRecordDto);
  }

  findAll() {
    return this.prisma.db.orm.public.RechargeRecords.all();
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.RechargeRecords.where({ id }).first();
  }

  update(id: number, updateRechargeRecordDto: UpdateRechargeRecordDto) {
    return this.prisma.db.orm.public.RechargeRecords.where({ id }).update(updateRechargeRecordDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.RechargeRecords.where({ id }).delete();
    return {
      message: 'Recharge record deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.RechargeRecords.where({}).deleteAndCount();
    return {
      message: 'All recharge records deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
