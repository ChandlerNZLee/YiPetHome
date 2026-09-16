import { Module } from '@nestjs/common';

import { AddressesController } from './addresses.controller';
import { AddressesService } from './addresses.service';
import { UserAddressesController } from './user-addresses/user-addresses.controller';
import { UserAddressesService } from './user-addresses/user-addresses.service';

@Module({
  controllers: [AddressesController, UserAddressesController],
  providers: [AddressesService, UserAddressesService],
  exports: [AddressesService, UserAddressesService],
})
export class AddressesModule { }
