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

import { ProductsService } from './products.service';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { QueryProductDto } from './dto/query-product.dto';

@Controller('products')
export class ProductsController {
  constructor(
    private readonly productsService: ProductsService,
  ) { }

  @Post()
  @UseGuards(JwtAuthGuard)
  async create(
    @Req() request: AuthenticatedRequest,
    @Body() createProductDto: CreateProductDto,
  ) {
    return this.productsService.create(
      request.user,
      createProductDto,
    );
  }

  @Get()
  async findAll() {
    return this.productsService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.productsService.findOne(id);
  }

  @Get('/shop/:id')
  async findByShopId(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.productsService.findByShopId(id);
  }

  @Get('/recent/:id')
  async findByUserId(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.productsService.findByShopId(id);
  }

  @Post('/recommend/:type')
  @UseGuards(JwtAuthGuard)
  async findRecommendByType(
    @Param('type', ParseIntPipe) type: number,
    @Req() request: AuthenticatedRequest,
    @Body() queryProductDto: QueryProductDto,
  ) {
    return this.productsService.findRecommendByType(
      type,
      request.user,
      queryProductDto,
    );
  }

  @Post('/search')
  async findByKeyword(
    @Body() queryProductDto: QueryProductDto,
  ) {
    return this.productsService.findByKeyword(queryProductDto);
  }

  @Post('/shop')
  async findOneByShop(
    @Body() queryProductDto: QueryProductDto,
  ) {
    return this.productsService.findOneByShop(queryProductDto);
  }

  @Put(':id')
  @UseGuards(JwtAuthGuard)
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
    @Body() updateProductDto: UpdateProductDto,
  ) {
    return this.productsService.update(
      id,
      request.user,
      updateProductDto,
    );
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  async remove(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ) {
    return this.productsService.remove(
      id,
      request.user,
    );
  }

  @Delete()
  @UseGuards(JwtAuthGuard)
  async removeAll(
    @Req() request: AuthenticatedRequest,
  ) {
    return this.productsService.removeAll(
      request.user,
    );
  }
}
