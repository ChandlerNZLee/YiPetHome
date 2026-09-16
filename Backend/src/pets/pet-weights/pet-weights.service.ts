import { Injectable } from '@nestjs/common';

import { PrismaService } from '../../prisma/prisma.service';

import type { CreatePetWeightDto } from './dto/create-pet-weight.dto';
import type { UpdatePetWeightDto } from './dto/update-pet-weight.dto';

@Injectable()
export class PetWeightsService {
  constructor(private readonly prisma: PrismaService) { }

  create(createPetWeightDto: CreatePetWeightDto) {
    return this.prisma.db.orm.public.PetWeights.create(createPetWeightDto);
  }

  async findAll() {
    return this.prisma.db.orm.public.PetWeights.all();
  }

  async findOne(id: number) {
    return this.prisma.db.orm.public.PetWeights.where({ id }).first();
  }

  async update(id: number, updatePetWeightDto: UpdatePetWeightDto) {
    return this.prisma.db.orm.public.PetWeights.where({ id }).update(updatePetWeightDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.PetWeights.where({ id }).delete();
    return {
      message: 'Pet weight deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.PetWeights.where({}).deleteAndCount();
    return {
      message: 'All pet weights deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
