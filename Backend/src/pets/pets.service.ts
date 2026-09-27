import { ForbiddenException, Injectable } from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';

import type { JwtPayload } from '../auth/interfaces/jwt-payload.interface';

import type { CreatePetDto } from './dto/create-pet.dto';
import type { UpdatePetDto } from './dto/update-pet.dto';

@Injectable()
export class PetsService {
  constructor(private readonly prisma: PrismaService) { }

  create(userId: number, createPetDto: CreatePetDto) {
    return this.prisma.db.orm.public.Pets.create({ ...createPetDto, userId });
  }

  async findAll(
    currentUser: JwtPayload,
  ) {
    const pets =
      currentUser.role === 2
        ? await this.prisma.db.orm.public.Pets
          .where({
            userId: currentUser.userId,
          })
          .all()
        : await this.prisma.db.orm.public.Pets.all();

    const petWeights =
      await this.prisma.db.orm.public.PetWeights.all();

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

  async findOne(
    id: number,
    currentUser: JwtPayload,
  ) {
    if (currentUser.role === 2) {
      return this.prisma.db.orm.public.Pets
        .where({
          id,
          userId: currentUser.userId,
        })
        .first();
    }

    return this.prisma.db.orm.public.Pets
      .where({
        id,
      })
      .first();
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

  async update(
    id: number,
    currentUser: JwtPayload,
    updatePetDto: UpdatePetDto,
  ) {
    if (currentUser.role === 2) {
      return this.prisma.db.orm.public.Pets
        .where({
          id,
          userId: currentUser.userId,
        })
        .update(updatePetDto);
    }

    return this.prisma.db.orm.public.Pets
      .where({
        id,
      })
      .update(updatePetDto);
  }

  async remove(id: number, currentUser: JwtPayload) {
    if (currentUser.role === 2) {
      await this.prisma.db.orm.public.Pets
        .where({
          id,
          userId: currentUser.userId,
        })
        .delete();
    } else {
      await this.prisma.db.orm.public.Pets
        .where({
          id,
        })
        .delete();
    }

    return {
      message: 'Pet deleted successfully',
    };
  }

  async removeAll(
    currentUser: JwtPayload,
  ): Promise<{
    message: string;
    deletedCount: number;
  }> {
    if (currentUser.role === 2) {
      throw new ForbiddenException(
        'You do not have permission to perform this action',
      );
    }

    const deletedCount =
      await this.prisma.db.orm.public.Pets
        .where({})
        .deleteAndCount();

    return {
      message: 'All pets deleted successfully',
      deletedCount,
    };
  }
}
