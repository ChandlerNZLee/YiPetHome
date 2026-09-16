import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { PetWeightsService } from './pet-weights.service';
import { CreatePetWeightDto } from './dto/create-pet-weight.dto';
import { UpdatePetWeightDto } from './dto/update-pet-weight.dto';

@Controller('pet-weights')
export class PetWeightsController {
  constructor(
    private readonly petWeightsService: PetWeightsService,
  ) {}

  @Post()
  async create(
    @Body() createPetWeightDto: CreatePetWeightDto,
  ) {
    return this.petWeightsService.create(createPetWeightDto);
  }

  @Get()
  async findAll() {
    return this.petWeightsService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.petWeightsService.findOne(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updatePetWeightDto: UpdatePetWeightDto,
  ) {
    return this.petWeightsService.update(
      id,
      updatePetWeightDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.petWeightsService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.petWeightsService.removeAll();
  }
}
