import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Put,
  Req,
  UseGuards,
} from '@nestjs/common';

import { JwtAuthGuard } from '../common/auth/jwt-auth.guard';

import type { AuthenticatedRequest } from '../common/auth/authenticated-request.interface';

import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';

@Controller('users')
export class UsersController {
  constructor(
    private readonly usersService: UsersService,
  ) { }

  @Post()
  @UseGuards(JwtAuthGuard)
  async create(
    @Req() request: AuthenticatedRequest,
    @Body() createUserDto: CreateUserDto,
  ) {
    return this.usersService.create(
      request.user,
      createUserDto,
    );
  }

  @Get()
  @UseGuards(JwtAuthGuard)
  async findAll(
    @Req() request: AuthenticatedRequest,
  ) {
    return this.usersService.findAll(
      request.user,
    );
  }

  @Get('me')
  @UseGuards(JwtAuthGuard)
  async getMe(
    @Req() request: AuthenticatedRequest,
  ) {
    return this.usersService.findOne(
      request.user.userId,
    );
  }

  @Put('me')
  @UseGuards(JwtAuthGuard)
  async updateMe(
    @Req() request: AuthenticatedRequest,
    @Body() updateProfileDto: UpdateProfileDto,
  ) {
    return this.usersService.updateProfile(
      request.user.userId,
      updateProfileDto,
    );
  }

  @Get(':id')
  @UseGuards(JwtAuthGuard)
  async findOne(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ) {
    return this.usersService.findOneForAdmin(
      id,
      request.user,
    );
  }

  @Put(':id')
  @UseGuards(JwtAuthGuard)
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
    @Body() updateUserDto: UpdateUserDto,
  ) {
    return this.usersService.update(
      id,
      request.user,
      updateUserDto,
    );
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  async remove(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ): Promise<{ message: string }> {
    return this.usersService.remove(
      id,
      request.user,
    );
  }

  @Delete()
  @UseGuards(JwtAuthGuard)
  async removeAll(
    @Req() request: AuthenticatedRequest,
  ) {
    return this.usersService.removeAll(
      request.user,
    );
  }
}
