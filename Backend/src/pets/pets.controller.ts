import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { PetsService } from './pets.service';
import { CreatePetDto } from './dto/create-pet.dto';
import { UpdatePetDto } from './dto/update-pet.dto';

@Controller('pets')
export class PetsController {
  constructor(
    private readonly petsService: PetsService,
  ) { }

  @Post()
  async create(
    @Body() createPetDto: CreatePetDto,
  ) {
    return this.petsService.create(createPetDto);
  }

  @Get()
  async findAll() {
    return this.petsService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.petsService.findOne(id);
  }

  @Get('/user/:id')
  async findByUserId(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.petsService.findByUserId(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updatePetDto: UpdatePetDto,
  ) {
    return this.petsService.update(
      id,
      updatePetDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.petsService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.petsService.removeAll();
  }
}
