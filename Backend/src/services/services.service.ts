import { Injectable, NotFoundException } from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';

import type { CreateServiceDto } from './dto/create-service.dto';
import type { UpdateServiceDto } from './dto/update-service.dto';

@Injectable()
export class ServicesService {
  constructor(private readonly prisma: PrismaService) { }

  create(createServiceDto: CreateServiceDto) {
    return this.prisma.db.orm.public.Services.create(createServiceDto);
  }

  async findAll() {
    const services = await this.prisma.db.orm.public.Services.all();
    const servicePrices = await this.prisma.db.orm.public.ServicePrices.all();

    return services.map((service) => ({
      ...service,
      prices: servicePrices.filter((price) => price.serviceId === service.id),
    }));
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.Services.where({ id }).first();
  }

  async findByPetId(id: number) {
    const pet = await this.prisma.db.orm.public.Pets.where({ id }).first();

    if (!pet) {
      throw new NotFoundException('Pet not found');
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

  update(id: number, updateServiceDto: UpdateServiceDto) {
    return this.prisma.db.orm.public.Services.where({ id }).update(updateServiceDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.Services.where({ id }).delete();
    return {
      message: 'Service deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.Services.where({}).deleteAndCount();
    return {
      message: 'All services deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
