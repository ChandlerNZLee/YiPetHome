import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { PetGroomsService } from './pet-grooms.service';
import { CreatePetGroomDto } from './dto/create-pet-groom.dto';
import { UpdatePetGroomDto } from './dto/update-pet-groom.dto';

@Controller('pet-grooms')
export class PetGroomsController {
  constructor(
    private readonly petGroomsService: PetGroomsService,
  ) {}

  @Post()
  async create(
    @Body() createPetGroomDto: CreatePetGroomDto,
  ) {
    return this.petGroomsService.create(createPetGroomDto);
  }

  @Get()
  async findAll() {
    return this.petGroomsService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.petGroomsService.findOne(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updatePetGroomDto: UpdatePetGroomDto,
  ) {
    return this.petGroomsService.update(
      id,
      updatePetGroomDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.petGroomsService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.petGroomsService.removeAll();
  }
}
