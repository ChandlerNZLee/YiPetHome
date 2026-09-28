import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';

import type { JwtPayload } from '../auth/interfaces/jwt-payload.interface';

import type { CreateAddressDto } from './dto/create-address.dto';
import type { UpdateAddressDto } from './dto/update-address.dto';

@Injectable()
export class AddressesService {
  constructor(private readonly prisma: PrismaService) { }

  async create(
    currentUser: JwtPayload,
    createAddressDto: CreateAddressDto,
  ) {
    return this.prisma.db.transaction(
      async (tx) => {
        const address =
          await tx.orm.public.Addresses.create(
            createAddressDto,
          );

        const existingAddresses =
          await tx.orm.public.UserAddresses
            .where({
              userId: currentUser.userId,
            })
            .all();

        await tx.orm.public.UserAddresses.create({
          userId: currentUser.userId,
          addressId: address.id,

          isDefault:
            existingAddresses.length === 0
              ? 1
              : 0,
        });

        return address;
      },
    );
  }

  findAll(
    currentUser: JwtPayload
  ) {
    if (currentUser.role === 2) {
      return this.findByUserId(
        currentUser.userId
      );
    }

    return this.prisma.db.orm.public.Addresses.all();
  }

  async findOne(
    id: number,
    currentUser: JwtPayload,
  ) {
    if (currentUser.role === 2) {
      const userAddress =
        await this.prisma.db.orm.public.UserAddresses
          .where({
            userId: currentUser.userId,
            addressId: id,
          })
          .first();

      if (!userAddress) {
        throw new NotFoundException(
          'Address not found',
        );
      }
    }

    const address =
      await this.prisma.db.orm.public.Addresses
        .where({ id })
        .first();

    if (!address) {
      throw new NotFoundException(
        'Address not found',
      );
    }

    return address;
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

  async setDefault(
    id: number,
    currentUser: JwtPayload,
  ) {
    // --------------------------------------------------
    // 1. Find address ownership
    // --------------------------------------------------

    const userAddress =
      await this.prisma.db.orm.public.UserAddresses
        .where({
          userId: currentUser.userId,
          addressId: id,
        })
        .first();

    if (!userAddress) {
      throw new NotFoundException(
        'Address not found',
      );
    }

    // --------------------------------------------------
    // 2. Already default
    // --------------------------------------------------

    if (userAddress.isDefault === 1) {
      return {
        success: true,
        message: 'Address is already the default address',
      };
    }

    // --------------------------------------------------
    // 3. Change default atomically
    // --------------------------------------------------

    await this.prisma.db.transaction(
      async (tx) => {
        const userAddresses =
          await tx.orm.public.UserAddresses
            .where({
              userId: currentUser.userId,
            })
            .all();

        for (const item of userAddresses) {
          await tx.orm.public.UserAddresses
            .where({
              id: item.id,
            })
            .update({
              isDefault:
                item.addressId === id
                  ? 1
                  : 0,
            });
        }
      },
    );

    return {
      success: true,
      message: 'Default address updated successfully',
    };
  }

  async update(
    id: number,
    currentUser: JwtPayload,
    updateAddressDto: UpdateAddressDto,
  ) {
    if (currentUser.role === 2) {
      const userAddress =
        await this.prisma.db.orm.public.UserAddresses
          .where({
            userId: currentUser.userId,
            addressId: id,
          })
          .first();

      if (!userAddress) {
        throw new NotFoundException(
          'Address not found',
        );
      }
    }

    const address =
      await this.prisma.db.orm.public.Addresses
        .where({ id })
        .first();

    if (!address) {
      throw new NotFoundException(
        'Address not found',
      );
    }

    await this.prisma.db.orm.public.Addresses
      .where({ id })
      .update(updateAddressDto);

    return {
      success: true,
      message: 'Address updated successfully',
    };
  }

  async remove(
    id: number,
    currentUser: JwtPayload,
  ) {
    // --------------------------------------------------
    // 1. Find ownership
    // --------------------------------------------------

    let ownerUserId: number | null = null;

    const userAddress =
      currentUser.role === 2
        ? await this.prisma.db.orm.public.UserAddresses
          .where({
            userId: currentUser.userId,
            addressId: id,
          })
          .first()
        : await this.prisma.db.orm.public.UserAddresses
          .where({
            addressId: id,
          })
          .first();

    if (!userAddress) {
      throw new NotFoundException(
        'Address not found',
      );
    }

    ownerUserId = userAddress.userId;

    const wasDefault =
      userAddress.isDefault === 1;

    // --------------------------------------------------
    // 2. Check address
    // --------------------------------------------------

    const address =
      await this.prisma.db.orm.public.Addresses
        .where({
          id,
        })
        .first();

    if (!address) {
      throw new NotFoundException(
        'Address not found',
      );
    }

    // --------------------------------------------------
    // 3. Delete
    // --------------------------------------------------

    await this.prisma.db.transaction(
      async (tx) => {
        await tx.orm.public.UserAddresses
          .where({
            userId: ownerUserId!,
            addressId: id,
          })
          .deleteAll();

        await tx.orm.public.Addresses
          .where({
            id,
          })
          .delete();

        // ----------------------------------------------
        // 4. Select a new default
        // ----------------------------------------------

        if (wasDefault) {
          const remainingAddresses =
            await tx.orm.public.UserAddresses
              .where({
                userId: ownerUserId!,
              })
              .all();

          if (remainingAddresses.length > 0) {
            const newDefault =
              remainingAddresses[0];

            await tx.orm.public.UserAddresses
              .where({
                id: newDefault.id,
              })
              .update({
                isDefault: 1,
              });
          }
        }
      },
    );

    return {
      success: true,
      message: 'Address deleted successfully',
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
        'You do not have permission to delete all addresses',
      );
    }

    const addresses =
      await this.prisma.db.orm.public.Addresses.all();

    const deletedCount = addresses.length;

    await this.prisma.db.transaction(
      async (tx) => {
        await tx.orm.public.UserAddresses
          .where({})
          .deleteAll();

        await tx.orm.public.Addresses
          .where({})
          .deleteAndCount();
      },
    );

    return {
      message: 'All addresses deleted successfully',
      deletedCount,
    };
  }
}
