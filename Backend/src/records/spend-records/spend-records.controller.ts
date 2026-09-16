import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { SpendRecordsService } from './spend-records.service';
import { CreateSpendRecordDto } from './dto/create-spend-record.dto';
import { UpdateSpendRecordDto } from './dto/update-spend-record.dto';

@Controller('spend-records')
export class SpendRecordsController {
  constructor(
    private readonly spendRecordsService: SpendRecordsService,
  ) {}

  @Post()
  async create(
    @Body() createSpendRecordDto: CreateSpendRecordDto,
  ) {
    return this.spendRecordsService.create(createSpendRecordDto);
  }

  @Get()
  async findAll() {
    return this.spendRecordsService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.spendRecordsService.findOne(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateSpendRecordDto: UpdateSpendRecordDto,
  ) {
    return this.spendRecordsService.update(
      id,
      updateSpendRecordDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.spendRecordsService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.spendRecordsService.removeAll();
  }
}
