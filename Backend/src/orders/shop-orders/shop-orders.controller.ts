import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { ShopOrdersService } from './shop-orders.service';
import { CreateShopOrderDto } from './dto/create-shop-order.dto';
import { UpdateShopOrderDto } from './dto/update-shop-order.dto';

@Controller('shop-orders')
export class ShopOrdersController {
  constructor(
    private readonly shopOrdersService: ShopOrdersService,
  ) { }

  @Post()
  async create(
    @Body() createShopOrderDto: CreateShopOrderDto,
  ) {
    return this.shopOrdersService.create(createShopOrderDto);
  }

  @Post('/process/:id')
  async process(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.shopOrdersService.process(id);
  }

  @Get()
  async findAll() {
    return this.shopOrdersService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.shopOrdersService.findOne(id);
  }

  @Get('/user/:id')
  async findByUserId(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.shopOrdersService.findByUserId(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateShopOrderDto: UpdateShopOrderDto,
  ) {
    return this.shopOrdersService.update(
      id,
      updateShopOrderDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.shopOrdersService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.shopOrdersService.removeAll();
  }
}
