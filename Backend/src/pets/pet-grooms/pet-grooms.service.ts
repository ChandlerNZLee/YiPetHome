import { Injectable } from '@nestjs/common';

import { PrismaService } from '../../prisma/prisma.service';

import type { CreatePetGroomDto } from './dto/create-pet-groom.dto';
import type { UpdatePetGroomDto } from './dto/update-pet-groom.dto';

@Injectable()
export class PetGroomsService {
  constructor(private readonly prisma: PrismaService) { }

  create(createPetGroomDto: CreatePetGroomDto) {
    return this.prisma.db.orm.public.PetGrooms.create(createPetGroomDto);
  }

  findAll() {
    return this.prisma.db.orm.public.PetGrooms.all();
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.PetGrooms.where({ id }).first();
  }

  update(id: number, updatePetGroomDto: UpdatePetGroomDto) {
    return this.prisma.db.orm.public.PetGrooms.where({ id }).update(updatePetGroomDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.PetGrooms.where({ id }).delete();
    return {
      message: 'Pet groom deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.PetGrooms.where({}).deleteAndCount();
    return {
      message: 'All pet grooms deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
