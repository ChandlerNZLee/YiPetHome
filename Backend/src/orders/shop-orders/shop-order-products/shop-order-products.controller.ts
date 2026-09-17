import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { ShopOrderProductsService } from './shop-order-products.service';
import { CreateShopOrderProductDto } from './dto/create-shop-order-product.dto';
import { UpdateShopOrderProductDto } from './dto/update-shop-order-product.dto';

@Controller('shop-order-products')
export class ShopOrderProductsController {
  constructor(
    private readonly shopOrderProductsService: ShopOrderProductsService,
  ) { }

  @Post()
  async create(
    @Body() createShopOrderProductDto: CreateShopOrderProductDto,
  ) {
    return this.shopOrderProductsService.create(createShopOrderProductDto);
  }

  @Get()
  async findAll() {
    return this.shopOrderProductsService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.shopOrderProductsService.findOne(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateShopOrderProductDto: UpdateShopOrderProductDto,
  ) {
    return this.shopOrderProductsService.update(
      id,
      updateShopOrderProductDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.shopOrderProductsService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.shopOrderProductsService.removeAll();
  }
}
