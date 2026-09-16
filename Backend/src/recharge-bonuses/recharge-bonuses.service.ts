import { Injectable } from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';

import type { CreateRechargeBonusDto } from './dto/create-recharge-bonus.dto';
import type { UpdateRechargeBonusDto } from './dto/update-recharge-bonus.dto';

@Injectable()
export class RechargeBonusesService {
  constructor(private readonly prisma: PrismaService) { }

  create(createRechargeBonusDto: CreateRechargeBonusDto) {
    return this.prisma.db.orm.public.RechargeBonuses.create(createRechargeBonusDto);
  }

  findAll() {
    return this.prisma.db.orm.public.RechargeBonuses.all();
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.RechargeBonuses.where({ id }).first();
  }

  update(id: number, updateRechargeBonusDto: UpdateRechargeBonusDto) {
    return this.prisma.db.orm.public.RechargeBonuses.where({ id }).update(updateRechargeBonusDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.RechargeBonuses.where({ id }).delete();
    return {
      message: 'Recharge bonus deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.RechargeBonuses.where({}).deleteAndCount();
    return {
      message: 'All recharge bonuses deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
