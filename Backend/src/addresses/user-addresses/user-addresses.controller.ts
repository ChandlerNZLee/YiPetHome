import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { UserAddressesService } from './user-addresses.service';
import { CreateUserAddressDto } from './dto/create-user-address.dto';
import { UpdateUserAddressDto } from './dto/update-user-address.dto';

@Controller('addresses')
export class UserAddressesController {
    constructor(
        private readonly userAddressesService: UserAddressesService,
    ) { }

    @Post()
    async create(
        @Body() createUserAddressDto: CreateUserAddressDto,
    ) {
        return this.userAddressesService.create(createUserAddressDto);
    }

    @Get()
    async findAll() {
        return this.userAddressesService.findAll();
    }

    @Get(':id')
    async findOne(
        @Param('id', ParseIntPipe) id: number,
    ) {
        return this.userAddressesService.findOne(id);
    }

    @Put(':id')
    async update(
        @Param('id', ParseIntPipe) id: number,
        @Body() updateUserAddressDto: UpdateUserAddressDto,
    ) {
        return this.userAddressesService.update(
            id,
            updateUserAddressDto,
        );
    }

    @Delete(':id')
    async remove(
        @Param('id', ParseIntPipe) id: number,
    ): Promise<{ message: string }> {
        return this.userAddressesService.remove(id);
    }

    @Delete()
    async removeAll(): Promise<{
        message: string;
        deletedCount: number;
    }> {
        return this.userAddressesService.removeAll();
    }
}
