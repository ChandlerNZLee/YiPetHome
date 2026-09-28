import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Req, UseGuards } from '@nestjs/common';

import { JwtAuthGuard } from '../../common/auth/jwt-auth.guard';
import type { AuthenticatedRequest } from '../../common/auth/authenticated-request.interface';

import { RechargeOrdersService } from './recharge-orders.service';
import { CreateRechargeOrderDto } from './dto/create-recharge-order.dto';

@Controller('recharge-orders')
@UseGuards(JwtAuthGuard)
export class RechargeOrdersController {
    constructor(
        private readonly rechargeOrdersService: RechargeOrdersService,
    ) { }

    @Post()
    async create(
        @Req() request: AuthenticatedRequest,
        @Body() createRechargeOrderDto: CreateRechargeOrderDto,
    ) {
        return this.rechargeOrdersService.create(request.user, createRechargeOrderDto);
    }

    @Get()
    async findAll(
        @Req() request: AuthenticatedRequest,
    ) {
        return this.rechargeOrdersService.findAll(request.user);
    }

    @Get(':id')
    async findOne(
        @Param('id', ParseIntPipe) id: number,
        @Req() request: AuthenticatedRequest,
    ) {
        return this.rechargeOrdersService.findOne(id, request.user);
    }

    @Delete(':id')
    async remove(
        @Param('id', ParseIntPipe) id: number,
        @Req() request: AuthenticatedRequest,
    ): Promise<{ message: string }> {
        return this.rechargeOrdersService.remove(id, request.user);
    }

    @Delete()
    async removeAll(
        @Req() request: AuthenticatedRequest,
    ): Promise<{
        message: string;
        deletedCount: number;
    }> {
        return this.rechargeOrdersService.removeAll(request.user);
    }
}
