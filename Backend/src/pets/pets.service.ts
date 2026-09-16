import { Injectable } from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';

import type { CreatePetDto } from './dto/create-pet.dto';
import type { UpdatePetDto } from './dto/update-pet.dto';

@Injectable()
export class PetsService {
  constructor(private readonly prisma: PrismaService) { }

  create(createPetDto: CreatePetDto) {
    return this.prisma.db.orm.public.Pets.create(createPetDto);
  }

  async findAll() {
    const pets = await this.prisma.db.orm.public.Pets.all();
    const petWeights = await this.prisma.db.orm.public.PetWeights.all();

    return pets.map((pet) => {
      const latestWeight = petWeights
        .filter((item) => item.petId === pet.id)
        .sort((a, b) => b.id - a.id)[0];

      return {
        ...pet,
        weight: latestWeight?.weight ?? null,
      };
    });
  }

  async findOne(id: number) {
    return this.prisma.db.orm.public.Pets.where({ id }).first();
  }

  async findByUserId(id: number) {
    const pets = await this.prisma.db.orm.public.Pets.where({ userId: id }).all();
    const petWeights = await this.prisma.db.orm.public.PetWeights.all();

    return pets.map((pet) => {
      const latestWeight = petWeights
        .filter((item) => item.petId === pet.id)
        .sort((a, b) => b.id - a.id)[0];

      return {
        ...pet,
        weight: latestWeight?.weight ?? null,
      };
    });
  }

  async update(id: number, updatePetDto: UpdatePetDto) {
    return this.prisma.db.orm.public.Pets.where({ id }).update(updatePetDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.Pets.where({ id }).delete();
    return {
      message: 'Pet deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.Pets.where({}).deleteAndCount();
    return {
      message: 'All pets deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
