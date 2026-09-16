import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { OrderProductsService } from './order-products.service';
import { CreateOrderProductDto } from './dto/create-order-product.dto';
import { UpdateOrderProductDto } from './dto/update-order-product.dto';

@Controller('order-products')
export class OrderProductsController {
  constructor(
    private readonly orderProductsService: OrderProductsService,
  ) {}

  @Post()
  async create(
    @Body() createOrderProductDto: CreateOrderProductDto,
  ) {
    return this.orderProductsService.create(createOrderProductDto);
  }

  @Get()
  async findAll() {
    return this.orderProductsService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.orderProductsService.findOne(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateOrderProductDto: UpdateOrderProductDto,
  ) {
    return this.orderProductsService.update(
      id,
      updateOrderProductDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.orderProductsService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.orderProductsService.removeAll();
  }
}
