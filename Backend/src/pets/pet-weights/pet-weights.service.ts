import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';

import { PrismaService } from '../../prisma/prisma.service';

import type { JwtPayload } from '../../auth/interfaces/jwt-payload.interface';

import type { CreatePetWeightDto } from './dto/create-pet-weight.dto';
import type { UpdatePetWeightDto } from './dto/update-pet-weight.dto';

@Injectable()
export class PetWeightsService {
  constructor(private readonly prisma: PrismaService) { }

  async create(
    currentUser: JwtPayload,
    dto: CreatePetWeightDto,
  ) {
    const pet =
      currentUser.role === 2
        ? await this.prisma.db.orm.public.Pets
          .where({
            id: dto.petId,
            userId: currentUser.userId,
          })
          .first()
        : await this.prisma.db.orm.public.Pets
          .where({
            id: dto.petId,
          })
          .first();

    if (!pet) {
      throw new NotFoundException(
        'Pet not found',
      );
    }

    return this.prisma.db.orm.public.PetWeights
      .create(dto);
  }

  async findAll(
    currentUser: JwtPayload,
  ) {
    if (currentUser.role !== 2) {
      return this.prisma.db.orm.public.PetWeights.all();
    }

    const pets =
      await this.prisma.db.orm.public.Pets
        .where({
          userId: currentUser.userId,
        })
        .all();

    const petIds = pets.map(
      (pet) => pet.id,
    );

    const allWeights =
      await this.prisma.db.orm.public.PetWeights.all();

    return allWeights.filter(
      (weight) =>
        petIds.includes(weight.petId),
    );
  }

  async findOne(
    id: number,
    currentUser: JwtPayload,
  ) {
    const petWeight =
      await this.prisma.db.orm.public.PetWeights
        .where({ id })
        .first();

    if (!petWeight) {
      throw new NotFoundException(
        'Pet weight not found',
      );
    }

    if (currentUser.role === 2) {
      const pet =
        await this.prisma.db.orm.public.Pets
          .where({
            id: petWeight.petId,
            userId: currentUser.userId,
          })
          .first();

      if (!pet) {
        throw new NotFoundException(
          'Pet weight not found',
        );
      }
    }

    return petWeight;
  }

  async update(
    id: number,
    currentUser: JwtPayload,
    dto: UpdatePetWeightDto,
  ) {
    const petWeight =
      await this.prisma.db.orm.public.PetWeights
        .where({ id })
        .first();

    if (!petWeight) {
      throw new NotFoundException(
        'Pet weight not found',
      );
    }

    if (currentUser.role === 2) {
      const currentPet =
        await this.prisma.db.orm.public.Pets
          .where({
            id: petWeight.petId,
            userId: currentUser.userId,
          })
          .first();

      if (!currentPet) {
        throw new NotFoundException(
          'Pet weight not found',
        );
      }
    }

    const targetPet =
      currentUser.role === 2
        ? await this.prisma.db.orm.public.Pets
          .where({
            id: dto.petId,
            userId: currentUser.userId,
          })
          .first()
        : await this.prisma.db.orm.public.Pets
          .where({
            id: dto.petId,
          })
          .first();

    if (!targetPet) {
      throw new BadRequestException(
        'Pet not found',
      );
    }

    return this.prisma.db.orm.public.PetWeights
      .where({ id })
      .update(dto);
  }

  async remove(
    id: number,
    currentUser: JwtPayload,
  ) {
    const petWeight =
      await this.prisma.db.orm.public.PetWeights
        .where({ id })
        .first();

    if (!petWeight) {
      throw new NotFoundException(
        'Pet weight not found',
      );
    }

    if (currentUser.role === 2) {
      const pet =
        await this.prisma.db.orm.public.Pets
          .where({
            id: petWeight.petId,
            userId: currentUser.userId,
          })
          .first();

      if (!pet) {
        throw new NotFoundException(
          'Pet weight not found',
        );
      }
    }

    await this.prisma.db.orm.public.PetWeights
      .where({ id })
      .delete();

    return {
      message: 'Pet weight deleted successfully',
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
        'You do not have permission to delete all pet weights',
      );
    }

    const deletedCount =
      await this.prisma.db.orm.public.PetWeights
        .where({})
        .deleteAndCount();

    return {
      message: 'All pet weights deleted successfully',
      deletedCount,
    };
  }
}
