import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { ServicePricesService } from './service-prices.service';
import { CreateServicePriceDto } from './dto/create-service-price.dto';
import { UpdateServicePriceDto } from './dto/update-service-price.dto';

@Controller('service-prices')
export class ServicePricesController {
  constructor(
    private readonly servicePricesService: ServicePricesService,
  ) {}

  @Post()
  async create(
    @Body() createServicePriceDto: CreateServicePriceDto,
  ) {
    return this.servicePricesService.create(createServicePriceDto);
  }

  @Get()
  async findAll() {
    return this.servicePricesService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.servicePricesService.findOne(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateServicePriceDto: UpdateServicePriceDto,
  ) {
    return this.servicePricesService.update(
      id,
      updateServicePriceDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.servicePricesService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.servicePricesService.removeAll();
  }
}
