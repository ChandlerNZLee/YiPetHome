import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { RechargeOrdersService } from './recharge-orders.service';
import { CreateRechargeOrderDto } from './dto/create-recharge-order.dto';

@Controller('recharge-orders')
export class RechargeOrdersController {
    constructor(
        private readonly rechargeOrdersService: RechargeOrdersService,
    ) { }

    @Post()
    async create(
        @Body() createRechargeOrderDto: CreateRechargeOrderDto,
    ) {
        return this.rechargeOrdersService.create(createRechargeOrderDto);
    }

    @Get()
    async findAll() {
        return this.rechargeOrdersService.findAll();
    }

    @Get(':id')
    async findOne(
        @Param('id', ParseIntPipe) id: number,
    ) {
        return this.rechargeOrdersService.findOne(id);
    }

    @Delete(':id')
    async remove(
        @Param('id', ParseIntPipe) id: number,
    ): Promise<{ message: string }> {
        return this.rechargeOrdersService.remove(id);
    }

    @Delete()
    async removeAll(): Promise<{
        message: string;
        deletedCount: number;
    }> {
        return this.rechargeOrdersService.removeAll();
    }
}
