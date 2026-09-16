import { Module } from '@nestjs/common';

import { ServicesController } from './services.controller';
import { ServicesService } from './services.service';
import { ServicePricesController } from './service-prices/service-prices.controller';
import { ServicePricesService } from './service-prices/service-prices.service';

@Module({
  controllers: [ServicesController, ServicePricesController],
  providers: [ServicesService, ServicePricesService],
  exports: [ServicesService, ServicePricesService],
})
export class ServicesModule {}
