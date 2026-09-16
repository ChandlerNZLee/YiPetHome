import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { PetVaccinesService } from './pet-vaccines.service';
import { CreatePetVaccineDto } from './dto/create-pet-vaccine.dto';
import { UpdatePetVaccineDto } from './dto/update-pet-vaccine.dto';

@Controller('pet-vaccines')
export class PetVaccinesController {
  constructor(
    private readonly petVaccinesService: PetVaccinesService,
  ) {}

  @Post()
  async create(
    @Body() createPetVaccineDto: CreatePetVaccineDto,
  ) {
    return this.petVaccinesService.create(createPetVaccineDto);
  }

  @Get()
  async findAll() {
    return this.petVaccinesService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.petVaccinesService.findOne(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updatePetVaccineDto: UpdatePetVaccineDto,
  ) {
    return this.petVaccinesService.update(
      id,
      updatePetVaccineDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.petVaccinesService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.petVaccinesService.removeAll();
  }
}
