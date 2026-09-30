import {
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';

import type { JwtPayload } from '../auth/interfaces/jwt-payload.interface';

import { PrismaService } from '../prisma/prisma.service';

import type { CreateUserDto } from './dto/create-user.dto';
import type { UpdateUserDto } from './dto/update-user.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) { }

  private sanitizeUser(user: any) {
    const safeUser = {
      ...user,
    };

    delete safeUser.password;
    delete safeUser.resetToken;
    delete safeUser.resetExpires;

    return safeUser;
  }

  async create(
    currentUser: JwtPayload,
    createUserDto: CreateUserDto,
  ) {
    if (currentUser.role === 2) {
      throw new ForbiddenException(
        'You do not have permission to create users',
      );
    }

    return this.prisma.db.orm.public.Users
      .create(createUserDto);
  }

  async findAll(
    currentUser: JwtPayload,
  ) {
    if (currentUser.role === 2) {
      throw new ForbiddenException(
        'You do not have permission to view all users',
      );
    }

    const users = await this.prisma.db.orm.public.Users.all();

    return users.map((user) => this.sanitizeUser(user));
  }

  async findOne(id: number) {
    const user = await this.prisma.db.orm.public.Users.where({ id }).first();

    if (!user) {
      throw new NotFoundException('User not found');
    }

    return this.sanitizeUser(user);
  }

  async findOneForAdmin(
    id: number,
    currentUser: JwtPayload,
  ) {
    if (currentUser.role === 2) {
      throw new ForbiddenException(
        'You do not have permission to view this user',
      );
    }

    return this.findOne(id);
  }

  async updateProfile(
    id: number,
    updateProfileDto: UpdateProfileDto,
  ) {
    const user =
      await this.prisma.db.orm.public.Users
        .where({ id })
        .first();

    if (!user) {
      throw new NotFoundException(
        'User not found',
      );
    }

    if (
      updateProfileDto.email &&
      updateProfileDto.email !== user.email
    ) {
      const existingUser =
        await this.prisma.db.orm.public.Users
          .where((item) =>
            item.email.ilike(
              updateProfileDto.email!,
            ),
          )
          .first();

      if (
        existingUser &&
        existingUser.id !== id
      ) {
        throw new ConflictException(
          'Email is already in use',
        );
      }
    }

    await this.prisma.db.orm.public.Users
      .where({ id })
      .update(updateProfileDto);

    return this.findOne(id);
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

  async update(
    id: number,
    currentUser: JwtPayload,
    updateUserDto: UpdateUserDto,
  ) {
    if (currentUser.role === 2) {
      throw new ForbiddenException(
        'You do not have permission to update users',
      );
    }

    const user =
      await this.prisma.db.orm.public.Users
        .where({ id })
        .first();

    if (!user) {
      throw new NotFoundException(
        'User not found',
      );
    }

    await this.prisma.db.orm.public.Users
      .where({ id })
      .update(updateUserDto);

    return this.findOne(id);
  }

  async remove(
    id: number,
    currentUser: JwtPayload,
  ) {
    if (currentUser.role === 2) {
      throw new ForbiddenException(
        'You do not have permission to delete users',
      );
    }

    const user =
      await this.prisma.db.orm.public.Users
        .where({ id })
        .first();

    if (!user) {
      throw new NotFoundException(
        'User not found',
      );
    }

    await this.prisma.db.orm.public.Users
      .where({ id })
      .delete();

    return {
      message: 'User deleted successfully',
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
        'You do not have permission to delete all users',
      );
    }

    const deletedCount = await this.prisma.db.orm.public.Users.where({}).deleteAndCount();
    return {
      message: 'All users deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
