import { Injectable } from '@nestjs/common';

import { PrismaService } from '../../prisma/prisma.service';

import type { CreateUserAddressDto } from './dto/create-user-address.dto';
import type { UpdateUserAddressDto } from './dto/update-user-address.dto';

@Injectable()
export class UserAddressesService {
    constructor(private readonly prisma: PrismaService) { }

    create(createUserAddressDto: CreateUserAddressDto) {
        return this.prisma.db.orm.public.UserAddresses.create(createUserAddressDto);
    }

    findAll() {
        return this.prisma.db.orm.public.UserAddresses.all();
    }

    findOne(id: number) {
        return this.prisma.db.orm.public.UserAddresses.where({ id }).first();
    }

    update(id: number, updateUserAddressDto: UpdateUserAddressDto) {
        return this.prisma.db.orm.public.UserAddresses.where({ id }).update(updateUserAddressDto);
    }

    async remove(id: number) {
        await this.prisma.db.orm.public.UserAddresses.where({ id }).delete();
        return {
            message: 'Address deleted successfully',
        };
    }

    async removeAll(): Promise<{
        message: string;
        deletedCount: number;
    }> {
        const deletedCount = await this.prisma.db.orm.public.UserAddresses.where({}).deleteAndCount();

        return {
            message: 'All user addresses deleted successfully',
            deletedCount: deletedCount,
        };
    }
}
