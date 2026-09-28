import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put, Req, UseGuards } from '@nestjs/common';

import { JwtAuthGuard } from '../common/auth/jwt-auth.guard';
import type { AuthenticatedRequest } from '../common/auth/authenticated-request.interface';

import { AddressesService } from './addresses.service';
import { CreateAddressDto } from './dto/create-address.dto';
import { UpdateAddressDto } from './dto/update-address.dto';

@Controller('addresses')
@UseGuards(JwtAuthGuard)
export class AddressesController {
  constructor(
    private readonly addressesService: AddressesService,
  ) { }

  @Post()
  async create(
    @Req() request: AuthenticatedRequest,
    @Body() createAddressDto: CreateAddressDto,
  ) {
    return this.addressesService.create(request.user, createAddressDto);
  }

  @Get()
  async findAll(
    @Req() request: AuthenticatedRequest
  ) {
    return this.addressesService.findAll(request.user);
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ) {
    return this.addressesService.findOne(id, request.user);
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

    return this.addressesService.findByUserId(targetUserId);
  }

  @Put(':id/default')
  async setDefault(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ) {
    return this.addressesService.setDefault(
      id,
      request.user,
    );
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
    @Body() updateAddressDto: UpdateAddressDto,
  ) {
    return this.addressesService.update(
      id,
      request.user,
      updateAddressDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ): Promise<{ message: string }> {
    return this.addressesService.remove(id, request.user);
  }

  @Delete()
  async removeAll(
    @Req() request: AuthenticatedRequest
  ): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.addressesService.removeAll(request.user);
  }
}
