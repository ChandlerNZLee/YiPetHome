import {
    Body,
    Controller,
    Delete,
    Get,
    Param,
    ParseIntPipe,
    Post,
    Put,
    Req,
    UseGuards,
} from '@nestjs/common';

import { JwtAuthGuard } from '../common/auth/jwt-auth.guard';
import type { AuthenticatedRequest } from '../common/auth/authenticated-request.interface';

import { GroomersService } from './groomers.service';
import { CreateGroomerDto } from './dto/create-groomer.dto';
import { UpdateGroomerDto } from './dto/update-groomer.dto';

@Controller('groomers')
export class GroomersController {
    constructor(
        private readonly groomersService: GroomersService,
    ) { }

    @Post()
    @UseGuards(JwtAuthGuard)
    async create(
        @Req() request: AuthenticatedRequest,
        @Body() createGroomerDto: CreateGroomerDto,
    ) {
        return this.groomersService.create(
            request.user,
            createGroomerDto,
        );
    }

    @Get()
    async findAll() {
        return this.groomersService.findAll();
    }

    @Get('/shop/:id')
    async findByShopId(
        @Param('id', ParseIntPipe) id: number,
    ) {
        return this.groomersService.findByShopId(id);
    }

    @Get(':id')
    async findOne(
        @Param('id', ParseIntPipe) id: number,
    ) {
        return this.groomersService.findOne(id);
    }

    @Put(':id')
    @UseGuards(JwtAuthGuard)
    async update(
        @Param('id', ParseIntPipe) id: number,
        @Req() request: AuthenticatedRequest,
        @Body() updateGroomerDto: UpdateGroomerDto,
    ) {
        return this.groomersService.update(
            id,
            request.user,
            updateGroomerDto,
        );
    }

    @Delete(':id')
    @UseGuards(JwtAuthGuard)
    async remove(
        @Param('id', ParseIntPipe) id: number,
        @Req() request: AuthenticatedRequest,
    ): Promise<{ message: string }> {
        return this.groomersService.remove(
            id,
            request.user,
        );
    }

    @Delete()
    @UseGuards(JwtAuthGuard)
    async removeAll(
        @Req() request: AuthenticatedRequest,
    ) {
        return this.groomersService.removeAll(
            request.user,
        );
    }
}
