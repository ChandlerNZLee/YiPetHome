import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put, Req, UseGuards } from '@nestjs/common';

import { JwtAuthGuard } from '../../common/auth/jwt-auth.guard';
import type { AuthenticatedRequest } from '../../common/auth/authenticated-request.interface';

import { ServicePricesService } from './service-prices.service';
import { CreateServicePriceDto } from './dto/create-service-price.dto';
import { UpdateServicePriceDto } from './dto/update-service-price.dto';

@Controller('service-prices')
export class ServicePricesController {
  constructor(
    private readonly servicePricesService: ServicePricesService,
  ) { }

  @Post()
  @UseGuards(JwtAuthGuard)
  async create(
    @Req() request: AuthenticatedRequest,
    @Body() createServicePriceDto: CreateServicePriceDto,
  ) {
    return this.servicePricesService.create(request.user, createServicePriceDto);
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
  @UseGuards(JwtAuthGuard)
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
    @Body() updateServicePriceDto: UpdateServicePriceDto,
  ) {
    return this.servicePricesService.update(
      id,
      request.user,
      updateServicePriceDto,
    );
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  async remove(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ): Promise<{ message: string }> {
    return this.servicePricesService.remove(id, request.user);
  }

  @Delete()
  @UseGuards(JwtAuthGuard)
  async removeAll(
    @Req() request: AuthenticatedRequest
  ): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.servicePricesService.removeAll(request.user);
  }
}
