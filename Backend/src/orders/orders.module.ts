import { Module } from '@nestjs/common';

import { OrdersController } from './orders.controller';
import { OrdersService } from './orders.service';
import { OrderProductsController } from './order-products/order-products.controller';
import { OrderProductsService } from './order-products/order-products.service';

@Module({
  controllers: [OrdersController, OrderProductsController],
  providers: [OrdersService, OrderProductsService],
  exports: [OrdersService, OrderProductsService],
})
export class OrdersModule {}
