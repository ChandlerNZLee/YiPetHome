import { Injectable } from '@nestjs/common';

import { PrismaService } from '../../prisma/prisma.service';

import type { CreatePetVaccineDto } from './dto/create-pet-vaccine.dto';
import type { UpdatePetVaccineDto } from './dto/update-pet-vaccine.dto';

@Injectable()
export class PetVaccinesService {
  constructor(private readonly prisma: PrismaService) { }

  create(createPetVaccineDto: CreatePetVaccineDto) {
    return this.prisma.db.orm.public.PetVaccines.create(createPetVaccineDto);
  }

  async findAll() {
    return this.prisma.db.orm.public.PetVaccines.all();
  }

  async findOne(id: number) {
    return this.prisma.db.orm.public.PetVaccines.where({ id }).first();
  }

  async update(id: number, updatePetVaccineDto: UpdatePetVaccineDto) {
    return this.prisma.db.orm.public.PetVaccines.where({ id }).update(updatePetVaccineDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.PetVaccines.where({ id }).delete();
    return {
      message: 'Pet vaccine deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.PetVaccines.where({}).deleteAndCount();
    return {
      message: 'All pet vaccines deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
