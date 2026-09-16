import { Injectable } from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';

import type { CreateAddressDto } from './dto/create-address.dto';
import type { UpdateAddressDto } from './dto/update-address.dto';

@Injectable()
export class AddressesService {
  constructor(private readonly prisma: PrismaService) { }

  create(createAddressDto: CreateAddressDto) {
    return this.prisma.db.orm.public.Addresses.create(createAddressDto);
  }

  findAll() {
    return this.prisma.db.orm.public.Addresses.all();
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.Addresses.where({ id }).first();
  }

  async findByUserId(id: number) {
    const userAddresses = await this.prisma.db.orm.public.UserAddresses.where({ userId: id }).all();
    const addresses = await this.prisma.db.orm.public.Addresses.all();

    return userAddresses.map((userAddress) => {
      const address = addresses.find((address) => address.id === userAddress.addressId);

      if (!address) {
        return null;
      }

      return {
        ...address,
        isDefault: userAddress.isDefault,
      };
    })
      .filter((item) => item !== null);
  }

  async update(id: number, updateAddressDto: UpdateAddressDto) {
    await this.prisma.db.orm.public.Addresses.where({ id }).update(updateAddressDto);
    return {
      success: true,
      message:
        'Address updated successfully',
    };
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.Addresses.where({ id }).delete();
    return {
      message: 'Address deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.Addresses.where({}).deleteAndCount();

    return {
      message: 'All addresses deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
