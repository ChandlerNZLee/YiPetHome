import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { RechargeBonusesService } from './recharge-bonuses.service';
import { CreateRechargeBonusDto } from './dto/create-recharge-bonus.dto';
import { UpdateRechargeBonusDto } from './dto/update-recharge-bonus.dto';

@Controller('recharge-bonuses')
export class RechargeBonusesController {
  constructor(
    private readonly rechargeBonusesService: RechargeBonusesService,
  ) {}

  @Post()
  async create(
    @Body() createRechargeBonusDto: CreateRechargeBonusDto,
  ) {
    return this.rechargeBonusesService.create(createRechargeBonusDto);
  }

  @Get()
  async findAll() {
    return this.rechargeBonusesService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.rechargeBonusesService.findOne(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateRechargeBonusDto: UpdateRechargeBonusDto,
  ) {
    return this.rechargeBonusesService.update(
      id,
      updateRechargeBonusDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.rechargeBonusesService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.rechargeBonusesService.removeAll();
  }
}
