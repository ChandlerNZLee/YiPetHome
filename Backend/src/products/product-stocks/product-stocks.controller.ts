import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { ProductStocksService } from './product-stocks.service';
import { CreateProductStockDto } from './dto/create-product-stock.dto';
import { UpdateProductStockDto } from './dto/update-product-stock.dto';

@Controller('product-stocks')
export class ProductStocksController {
  constructor(
    private readonly productStocksService: ProductStocksService,
  ) {}

  @Post()
  async create(
    @Body() createProductStockDto: CreateProductStockDto,
  ) {
    return this.productStocksService.create(createProductStockDto);
  }

  @Get()
  async findAll() {
    return this.productStocksService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.productStocksService.findOne(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateProductStockDto: UpdateProductStockDto,
  ) {
    return this.productStocksService.update(
      id,
      updateProductStockDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.productStocksService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.productStocksService.removeAll();
  }
}
