import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';

import type { JwtPayload } from '../auth/interfaces/jwt-payload.interface';

import type { CreateServiceDto } from './dto/create-service.dto';
import type { UpdateServiceDto } from './dto/update-service.dto';

@Injectable()
export class ServicesService {
  constructor(private readonly prisma: PrismaService) { }

  create(
    currentUser: JwtPayload,
    dto: CreateServiceDto,
  ) {
    if (currentUser.role === 2) {
      throw new ForbiddenException(
        'You do not have permission to create services',
      );
    }

    return this.prisma.db.orm.public.Services.create(dto);
  }

  async findAll() {
    const services = await this.prisma.db.orm.public.Services.all();
    const servicePrices = await this.prisma.db.orm.public.ServicePrices.all();

    return services.map((service) => ({
      ...service,
      prices: servicePrices.filter((price) => price.serviceId === service.id),
    }));
  }

  async findOne(id: number) {
    const service =
      await this.prisma.db.orm.public.Services
        .where({ id })
        .first();

    if (!service) {
      throw new NotFoundException('Service not found');
    }

    return service;
  }

  async findByPetId(id: number, currentUser: JwtPayload) {
    const pet =
      currentUser.role === 2
        ? await this.prisma.db.orm.public.Pets
          .where({
            id,
            userId: currentUser.userId,
          })
          .first()
        : await this.prisma.db.orm.public.Pets
          .where({
            id,
          })
          .first();

    if (!pet) {
      throw new NotFoundException(
        'Pet not found',
      );
    }

    const petWeights = await this.prisma.db.orm.public.PetWeights.where({ petId: pet.id }).all();
    const latestWeight = petWeights.sort((a, b) => b.id - a.id)[0];

    if (!latestWeight) {
      throw new NotFoundException('Pet weight not found');
    }

    const weight = Number(latestWeight.weight);
    const allServicePrices = await this.prisma.db.orm.public.ServicePrices.all();
    const servicePrices = allServicePrices.filter((item) => {
      return (
        item.category === pet.category &&
        item.furType === pet.furType &&
        Number(item.weightFrom) <= weight &&
        Number(item.weightTo) >= weight
      );
    })
      .sort((a, b) => a.id - b.id);

    const services = await this.prisma.db.orm.public.Services.all();

    return servicePrices.map((item) => {
      const service = services.find((service) => service.id === item.serviceId);

      if (!service) {
        return null;
      }

      return {
        id: service.id,
        type: service._type,
        name: service.name,
        description: service.description,
        image: service.image,
        priceId: item.id,
        price: item.price,
        duration: item.duration,
        weight_from: item.weightFrom,
        weight_to: item.weightTo,
      };
    })
      .filter((item) => item !== null);
  }

  async update(
    id: number,
    currentUser: JwtPayload,
    dto: UpdateServiceDto,
  ) {
    if (currentUser.role === 2) {
      throw new ForbiddenException(
        'You do not have permission to update services',
      );
    }

    const service =
      await this.prisma.db.orm.public.Services
        .where({ id })
        .first();

    if (!service) {
      throw new NotFoundException('Service not found');
    }

    return this.prisma.db.orm.public.Services
      .where({ id })
      .update(dto);
  }

  async remove(
    id: number,
    currentUser: JwtPayload,
  ) {
    if (currentUser.role === 2) {
      throw new ForbiddenException(
        'You do not have permission to delete services',
      );
    }

    const service =
      await this.prisma.db.orm.public.Services
        .where({ id })
        .first();

    if (!service) {
      throw new NotFoundException('Service not found');
    }

    await this.prisma.db.orm.public.Services
      .where({ id })
      .delete();

    return {
      message: 'Service deleted successfully',
    };
  }

  async removeAll(
    currentUser: JwtPayload
  ): Promise<{
    message: string;
    deletedCount: number;
  }> {
    if (currentUser.role === 2) {
      throw new ForbiddenException(
        'You do not have permission to delete all services',
      );
    }

    const deletedCount = await this.prisma.db.orm.public.Services.where({}).deleteAndCount();
    return {
      message: 'All services deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
