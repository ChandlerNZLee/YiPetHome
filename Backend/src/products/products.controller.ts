import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

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
  async create(
    @Body() createProductDto: CreateProductDto,
  ) {
    return this.productsService.create(createProductDto);
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
  async findRecommendByType(
    @Param('type', ParseIntPipe) type: number,
    @Body() queryProductDto: QueryProductDto,
  ) {
    return this.productsService.findRecommendByType(type, queryProductDto);
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
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateProductDto: UpdateProductDto,
  ) {
    return this.productsService.update(
      id,
      updateProductDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.productsService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.productsService.removeAll();
  }
}
