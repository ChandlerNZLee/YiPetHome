import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { OrdersService } from './orders.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { UpdateOrderDto } from './dto/update-order.dto';

@Controller('orders')
export class OrdersController {
  constructor(
    private readonly ordersService: OrdersService,
  ) { }

  @Post()
  async create(
    @Body() createOrderDto: CreateOrderDto,
  ) {
    return this.ordersService.create(createOrderDto);
  }

  @Post('/process/:id')
  async process(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.ordersService.process(id);
  }

  @Get()
  async findAll() {
    return this.ordersService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.ordersService.findOne(id);
  }

  @Get('/user/:id')
  async findByUserId(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.ordersService.findByUserId(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateOrderDto: UpdateOrderDto,
  ) {
    return this.ordersService.update(
      id,
      updateOrderDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.ordersService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.ordersService.removeAll();
  }
}
