import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { ProductImagesService } from './product-images.service';
import { CreateProductImageDto } from './dto/create-product-image.dto';
import { UpdateProductImageDto } from './dto/update-product-image.dto';

@Controller('product-images')
export class ProductImagesController {
  constructor(
    private readonly productImagesService: ProductImagesService,
  ) {}

  @Post()
  async create(
    @Body() createProductImageDto: CreateProductImageDto,
  ) {
    return this.productImagesService.create(createProductImageDto);
  }

  @Get()
  async findAll() {
    return this.productImagesService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.productImagesService.findOne(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateProductImageDto: UpdateProductImageDto,
  ) {
    return this.productImagesService.update(
      id,
      updateProductImageDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.productImagesService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.productImagesService.removeAll();
  }
}
