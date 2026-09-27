import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put, Req, UseGuards } from '@nestjs/common';

import { JwtAuthGuard } from '../common/auth/jwt-auth.guard';
import type { AuthenticatedRequest } from '../common/auth/authenticated-request.interface';

import { PetsService } from './pets.service';
import { CreatePetDto } from './dto/create-pet.dto';
import { UpdatePetDto } from './dto/update-pet.dto';

@Controller('pets')
@UseGuards(JwtAuthGuard)
export class PetsController {
  constructor(
    private readonly petsService: PetsService,
  ) { }

  @Post()
  async create(
    @Req() request: AuthenticatedRequest,
    @Body() createPetDto: CreatePetDto,
  ) {
    return this.petsService.create(request.user.userId, createPetDto);
  }

  @Get()
  async findAll(
    @Req() request: AuthenticatedRequest,
  ) {
    return this.petsService.findAll(request.user);
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ) {
    return this.petsService.findOne(id, request.user);
  }

  @Get('/user/:id')
  async findByUserId(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ) {
    const targetUserId =
      request.user.role === 2
        ? request.user.userId
        : id;

    return this.petsService.findByUserId(
      targetUserId,
    );
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
    @Body() updatePetDto: UpdatePetDto,
  ) {
    return this.petsService.update(
      id,
      request.user,
      updatePetDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ): Promise<{ message: string }> {
    return this.petsService.remove(id, request.user);
  }

  @Delete()
  async removeAll(
    @Req() request: AuthenticatedRequest,
  ): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.petsService.removeAll(request.user);
  }
}
