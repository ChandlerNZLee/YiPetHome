import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put } from '@nestjs/common';

import { AddressesService } from './addresses.service';
import { CreateAddressDto } from './dto/create-address.dto';
import { UpdateAddressDto } from './dto/update-address.dto';

@Controller('addresses')
export class AddressesController {
  constructor(
    private readonly addressesService: AddressesService,
  ) { }

  @Post()
  async create(
    @Body() createAddressDto: CreateAddressDto,
  ) {
    return this.addressesService.create(createAddressDto);
  }

  @Get()
  async findAll() {
    return this.addressesService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.addressesService.findOne(id);
  }

  @Get('/user/:id')
  async findByUserId(
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.addressesService.findByUserId(id);
  }

  @Put(':id')
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateAddressDto: UpdateAddressDto,
  ) {
    return this.addressesService.update(
      id,
      updateAddressDto,
    );
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<{ message: string }> {
    return this.addressesService.remove(id);
  }

  @Delete()
  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    return this.addressesService.removeAll();
  }
}
