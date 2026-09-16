import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { StockRecordsService } from './stock-records.service';
import { CreateStockRecordDto } from './dto/create-stock-record.dto';
import { UpdateStockRecordDto } from './dto/update-stock-record.dto';

@Controller('stock-records')
export class StockRecordsController {
  constructor(
    private readonly stockRecordsService: StockRecordsService,
  ) {}

  @Post()
  async create(
    @Body() createStockRecordDto: CreateStockRecordDto,
  ) {
    return this.stockRecordsService.create(createStockRecordDto);
  }

  @Get()
  async findAll() {
    return this.stockRecordsService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.stockRecordsService.findOne(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateStockRecordDto: UpdateStockRecordDto,
  ) {
    return this.stockRecordsService.update(
      id,
      updateStockRecordDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.stockRecordsService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.stockRecordsService.removeAll();
  }
}
