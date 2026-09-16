import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { GroomersService } from './groomers.service';
import { CreateGroomerDto } from './dto/create-groomer.dto';
import { UpdateGroomerDto } from './dto/update-groomer.dto';

@Controller('groomers')
export class GroomersController {
    constructor(
        private readonly groomersService: GroomersService,
    ) { }

    @Post()
    async create(
        @Body() createGroomerDto: CreateGroomerDto,
    ) {
        return this.groomersService.create(createGroomerDto);
    }

    @Get()
    async findAll() {
        return this.groomersService.findAll();
    }

    @Get(':id')
    async findOne(
        @Param('id', ParseIntPipe) id: number,
    ) {
        return this.groomersService.findOne(id);
    }

    @Get('/shop/:id')
    async findByShopId(
        @Param('id', ParseIntPipe) id: number,
    ) {
        return this.groomersService.findByShopId(id);
    }

    @Put(':id')
    async update(
        @Param('id', ParseIntPipe) id: number,
        @Body() updateGroomerDto: UpdateGroomerDto,
    ) {
        return this.groomersService.update(
            id,
            updateGroomerDto,
        );
    }

    @Delete(':id')
    async remove(
        @Param('id', ParseIntPipe) id: number,
    ): Promise<{ message: string }> {
        return this.groomersService.remove(id);
    }

    @Delete()
    async removeAll(): Promise<{
        message: string;
        deletedCount: number;
    }> {
        return this.groomersService.removeAll();
    }
}
