import { Injectable } from '@nestjs/common';

import { PrismaService } from '../../prisma/prisma.service';

import type { CreateOperationRecordDto } from './dto/create-operation-record.dto';
import type { UpdateOperationRecordDto } from './dto/update-operation-record.dto';

@Injectable()
export class OperationRecordsService {
  constructor(private readonly prisma: PrismaService) { }

  create(createOperationRecordDto: CreateOperationRecordDto) {
    return this.prisma.db.orm.public.OperationRecords.create(createOperationRecordDto);
  }

  findAll() {
    return this.prisma.db.orm.public.OperationRecords.all();
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.OperationRecords.where({ id }).first();
  }

  update(id: number, updateOperationRecordDto: UpdateOperationRecordDto) {
    return this.prisma.db.orm.public.OperationRecords.where({ id }).update(updateOperationRecordDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.OperationRecords.where({ id }).delete();
    return {
      message: 'Operation record deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.OperationRecords.where({}).deleteAndCount();
    return {
      message: 'All operation records deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
