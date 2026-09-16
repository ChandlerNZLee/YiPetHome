import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';

import type { CreateUserDto } from './dto/create-user.dto';
import type { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) { }

  create(createUserDto: CreateUserDto) {
    return this.prisma.db.orm.public.Users.create(createUserDto);
  }

  async findAll() {
    const users = await this.prisma.db.orm.public.Users.all();
    return users.map(({ password, ...user }) => user);

  }

  async findOne(id: number) {
    const user = await this.prisma.db.orm.public.Users.where({ id }).first();

    if (!user) {
      throw new NotFoundException('User not found');
    }

    const { password: _, ...result } = user;
    return result;
  }

  async findByUsername(username: string) {
    const user = await this.prisma.db.orm.public.Users.where({ username }).first();

    if (!user) {
      return null;
    }

    return {
      id: user.id,
      username: user.username,
      email: user.email,
      password: user.password,
      role: user.role,
      shop_id: user.shopId,
      avatar: user.avatar,
      mobile: user.mobile,
      first_name: user.firstName,
      last_name: user.lastName,
      balance: user.balance,
    };
  }

  async findByEmail(email: string) {
    const user = await this.prisma.db.orm.public.Users.where((user) => user.email.ilike(email)).first();

    if (!user) {
      return null;
    }

    return {
      id: user.id,
      username: user.username,
      email: user.email,
      password: user.password,
      role: user.role,
      shop_id: user.shopId,
      avatar: user.avatar,
      mobile: user.mobile,
      first_name: user.firstName,
      last_name: user.lastName,
      balance: user.balance,
    };
  }

  update(id: number, updateUserDto: UpdateUserDto) {
    return this.prisma.db.orm.public.Users.where({ id }).update(updateUserDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.Users.where({ id }).delete();
    return {
      message: 'User deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.Users.where({}).deleteAndCount();
    return {
      message: 'All users deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
