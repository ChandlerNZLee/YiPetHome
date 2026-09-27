import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put, Req, UseGuards } from '@nestjs/common';

import { JwtAuthGuard } from '../../common/auth/jwt-auth.guard';
import type { AuthenticatedRequest } from '../../common/auth/authenticated-request.interface';

import { ShopOrdersService } from './shop-orders.service';
import { CreateShopOrderDto } from './dto/create-shop-order.dto';
import { UpdateShopOrderDto } from './dto/update-shop-order.dto';

@Controller('shop-orders')
@UseGuards(JwtAuthGuard)
export class ShopOrdersController {
  constructor(
    private readonly shopOrdersService: ShopOrdersService,
  ) { }

  @Post()
  async create(
    @Req() request: AuthenticatedRequest,
    @Body() createShopOrderDto: CreateShopOrderDto,
  ) {
    return this.shopOrdersService.create(request.user, createShopOrderDto);
  }

  @Post('/process/:id')
  async process(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ) {
    return this.shopOrdersService.process(id, request.user);
  }

  @Get()
  async findAll(
    @Req() request: AuthenticatedRequest
  ) {
    return this.shopOrdersService.findAll(request.user);
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ) {
    return this.shopOrdersService.findOne(id, request.user);
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

    return this.shopOrdersService.findByUserId(targetUserId);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
    @Body() updateShopOrderDto: UpdateShopOrderDto,
  ) {
    return this.shopOrdersService.update(
      id,
      request.user,
      updateShopOrderDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ): Promise<{ message: string }> {
    return this.shopOrdersService.remove(id, request.user);
  }

  @Delete()
  async removeAll(
    @Req() request: AuthenticatedRequest
  ): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.shopOrdersService.removeAll(request.user);
  }
}
