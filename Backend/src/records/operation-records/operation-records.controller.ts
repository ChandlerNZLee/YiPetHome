import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { OperationRecordsService } from './operation-records.service';
import { CreateOperationRecordDto } from './dto/create-operation-record.dto';
import { UpdateOperationRecordDto } from './dto/update-operation-record.dto';

@Controller('operation-records')
export class OperationRecordsController {
  constructor(
    private readonly operationRecordsService: OperationRecordsService,
  ) {}

  @Post()
  async create(
    @Body() createOperationRecordDto: CreateOperationRecordDto,
  ) {
    return this.operationRecordsService.create(createOperationRecordDto);
  }

  @Get()
  async findAll() {
    return this.operationRecordsService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.operationRecordsService.findOne(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateOperationRecordDto: UpdateOperationRecordDto,
  ) {
    return this.operationRecordsService.update(
      id,
      updateOperationRecordDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.operationRecordsService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.operationRecordsService.removeAll();
  }
}
