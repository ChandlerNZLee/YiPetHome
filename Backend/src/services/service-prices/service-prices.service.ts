import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';

import { PrismaService } from '../../prisma/prisma.service';

import type { JwtPayload } from '../../auth/interfaces/jwt-payload.interface';

import type { CreateServicePriceDto } from './dto/create-service-price.dto';
import type { UpdateServicePriceDto } from './dto/update-service-price.dto';

@Injectable()
export class ServicePricesService {
  constructor(private readonly prisma: PrismaService) { }

  async create(
    currentUser: JwtPayload,
    dto: CreateServicePriceDto,
  ) {
    if (currentUser.role === 2) {
      throw new ForbiddenException(
        'You do not have permission to create service prices',
      );
    }

    const service =
      await this.prisma.db.orm.public.Services
        .where({
          id: dto.serviceId,
        })
        .first();

    if (!service) {
      throw new BadRequestException(
        'Service not found',
      );
    }

    if (dto.weightFrom > dto.weightTo) {
      throw new BadRequestException(
        'Weight From cannot be greater than Weight To',
      );
    }

    return this.prisma.db.orm.public.ServicePrices
      .create(dto);
  }

  findAll() {
    return this.prisma.db.orm.public.ServicePrices.all();
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.ServicePrices.where({ id }).first();
  }

  async update(
    id: number,
    currentUser: JwtPayload,
    dto: UpdateServicePriceDto,
  ) {
    if (currentUser.role === 2) {
      throw new ForbiddenException(
        'You do not have permission to update service prices',
      );
    }

    const servicePrice =
      await this.prisma.db.orm.public.ServicePrices
        .where({ id })
        .first();

    if (!servicePrice) {
      throw new NotFoundException(
        'Service price not found',
      );
    }

    const service =
      await this.prisma.db.orm.public.Services
        .where({
          id: dto.serviceId,
        })
        .first();

    if (!service) {
      throw new BadRequestException(
        'Service not found',
      );
    }

    if (dto.weightFrom > dto.weightTo) {
      throw new BadRequestException(
        'Weight From cannot be greater than Weight To',
      );
    }

    return this.prisma.db.orm.public.ServicePrices
      .where({ id })
      .update(dto);
  }

  async remove(id: number, currentUser: JwtPayload) {
    if (currentUser.role === 2) {
      throw new ForbiddenException('You do not have permission to delete all service prices');
    }

    await this.prisma.db.orm.public.ServicePrices.where({ id }).delete();
    return {
      message: 'Service price deleted successfully',
    };
  }

  async removeAll(
    currentUser: JwtPayload
  ): Promise<{
    message: string;
    deletedCount: number;
  }> {
    if (currentUser.role === 2) {
      throw new ForbiddenException('You do not have permission to delete all service prices');
    }

    const deletedCount = await this.prisma.db.orm.public.ServicePrices.where({}).deleteAndCount();
    return {
      message: 'All service prices deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
