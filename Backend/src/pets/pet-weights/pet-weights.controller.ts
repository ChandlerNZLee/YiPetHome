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

import { JwtAuthGuard } from '../../common/auth/jwt-auth.guard';
import type { AuthenticatedRequest } from '../../common/auth/authenticated-request.interface';

import { PetWeightsService } from './pet-weights.service';
import { CreatePetWeightDto } from './dto/create-pet-weight.dto';
import { UpdatePetWeightDto } from './dto/update-pet-weight.dto';

@Controller('pet-weights')
@UseGuards(JwtAuthGuard)
export class PetWeightsController {
  constructor(
    private readonly petWeightsService: PetWeightsService,
  ) { }

  @Post()
  async create(
    @Req() request: AuthenticatedRequest,
    @Body() dto: CreatePetWeightDto,
  ) {
    return this.petWeightsService.create(
      request.user,
      dto,
    );
  }

  @Get()
  async findAll(
    @Req() request: AuthenticatedRequest,
  ) {
    return this.petWeightsService.findAll(
      request.user,
    );
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ) {
    return this.petWeightsService.findOne(
      id,
      request.user,
    );
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
    @Body() dto: UpdatePetWeightDto,
  ) {
    return this.petWeightsService.update(
      id,
      request.user,
      dto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
    @Req() request: AuthenticatedRequest,
  ) {
    return this.petWeightsService.remove(
      id,
      request.user,
    );
  }

  @Delete()
  async removeAll(
    @Req() request: AuthenticatedRequest,
  ) {
    return this.petWeightsService.removeAll(
      request.user,
    );
  }
}