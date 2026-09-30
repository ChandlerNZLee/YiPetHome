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

import { ShopsService } from './shops.service';
import { CreateShopDto } from './dto/create-shop.dto';
import { UpdateShopDto } from './dto/update-shop.dto';

@Controller('shops')
export class ShopsController {
  constructor(
    private readonly shopsService: ShopsService,
  ) { }

  @Post()
  @UseGuards(JwtAuthGuard)
  async create(
    @Req() request: AuthenticatedRequest,
    @Body() createShopDto: CreateShopDto,
  ) {
    return this.shopsService.create(
      request.user,
      createShopDto,
    );
  }

  @Get()
  async findAll() {
    return this.shopsService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.shopsService.findOne(id);
  }

  @Put(':id')
  @UseGuards(JwtAuthGuard)
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
    @Body() updateShopDto: UpdateShopDto,
  ) {
    return this.shopsService.update(
      id,
      request.user,
      updateShopDto,
    );
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  async remove(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ): Promise<{ message: string }> {
    return this.shopsService.remove(
      id,
      request.user,
    );
  }

  @Delete()
  @UseGuards(JwtAuthGuard)
  async removeAll(
    @Req() request: AuthenticatedRequest,
  ): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.shopsService.removeAll(
      request.user,
    );
  }
}