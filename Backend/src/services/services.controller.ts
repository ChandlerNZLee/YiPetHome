import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put, Req, UseGuards } from '@nestjs/common';

import { JwtAuthGuard } from '../common/auth/jwt-auth.guard';
import type { AuthenticatedRequest } from '../common/auth/authenticated-request.interface';

import { ServicesService } from './services.service';
import { CreateServiceDto } from './dto/create-service.dto';
import { UpdateServiceDto } from './dto/update-service.dto';

@Controller('services')
export class ServicesController {
  constructor(
    private readonly servicesService: ServicesService,
  ) { }

  @Post()
  @UseGuards(JwtAuthGuard)
  async create(
    @Req() request: AuthenticatedRequest,
    @Body() createServiceDto: CreateServiceDto,
  ) {
    return this.servicesService.create(
      request.user,
      createServiceDto,
    );
  }

  @Get()
  async findAll() {
    return this.servicesService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.servicesService.findOne(id);
  }

  @Get('/pet/:id')
  @UseGuards(JwtAuthGuard)
  async findByPetId(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ) {
    return this.servicesService.findByPetId(
      id,
      request.user,
    );
  }

  @Put(':id')
  @UseGuards(JwtAuthGuard)
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
    @Body() updateServiceDto: UpdateServiceDto,
  ) {
    return this.servicesService.update(
      id,
      request.user,
      updateServiceDto,
    );
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  async remove(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ) {
    return this.servicesService.remove(
      id,
      request.user,
    );
  }

  @Delete()
  @UseGuards(JwtAuthGuard)
  async removeAll(
    @Req() request: AuthenticatedRequest,
  ) {
    return this.servicesService.removeAll(
      request.user,
    );
  }
}
