import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { RechargeRecordsService } from './recharge-records.service';
import { CreateRechargeRecordDto } from './dto/create-recharge-record.dto';
import { UpdateRechargeRecordDto } from './dto/update-recharge-record.dto';

@Controller('recharge-records')
export class RechargeRecordsController {
  constructor(
    private readonly rechargeRecordsService: RechargeRecordsService,
  ) {}

  @Post()
  async create(
    @Body() createRechargeRecordDto: CreateRechargeRecordDto,
  ) {
    return this.rechargeRecordsService.create(createRechargeRecordDto);
  }

  @Get()
  async findAll() {
    return this.rechargeRecordsService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.rechargeRecordsService.findOne(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateRechargeRecordDto: UpdateRechargeRecordDto,
  ) {
    return this.rechargeRecordsService.update(
      id,
      updateRechargeRecordDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.rechargeRecordsService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.rechargeRecordsService.removeAll();
  }
}
