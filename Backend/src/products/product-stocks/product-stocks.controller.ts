import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put, Req, UseGuards } from '@nestjs/common';

import { JwtAuthGuard } from '../../common/auth/jwt-auth.guard';
import type { AuthenticatedRequest } from '../../common/auth/authenticated-request.interface';

import { ProductStocksService } from './product-stocks.service';
import { CreateProductStockDto } from './dto/create-product-stock.dto';
import { UpdateProductStockDto } from './dto/update-product-stock.dto';

@Controller('product-stocks')
export class ProductStocksController {
  constructor(
    private readonly productStocksService: ProductStocksService,
  ) { }

  @Post()
  @UseGuards(JwtAuthGuard)
  async create(
    @Req() request: AuthenticatedRequest,
    @Body() dto: CreateProductStockDto,
  ) {
    return this.productStocksService.create(
      request.user,
      dto,
    );
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
  @UseGuards(JwtAuthGuard)
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
    @Body() dto: UpdateProductStockDto,
  ) {
    return this.productStocksService.update(
      id,
      request.user,
      dto,
    );
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  async remove(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ) {
    return this.productStocksService.remove(
      id,
      request.user,
    );
  }

  @Delete()
  @UseGuards(JwtAuthGuard)
  async removeAll(
    @Req() request: AuthenticatedRequest,
  ) {
    return this.productStocksService.removeAll(
      request.user,
    );
  }
}
