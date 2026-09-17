import { Module } from '@nestjs/common';

import { ShopOrdersController } from './shop-orders/shop-orders.controller';
import { ShopOrdersService } from './shop-orders/shop-orders.service';
import { ShopOrderProductsController } from './shop-orders/shop-order-products/shop-order-products.controller';
import { ShopOrderProductsService } from './shop-orders/shop-order-products/shop-order-products.service';
import { RechargeOrdersController } from './recharge-orders/recharge-orders.controller';
import { RechargeOrdersService } from './recharge-orders/recharge-orders.service';

@Module({
  controllers: [ShopOrdersController, ShopOrderProductsController, RechargeOrdersController],
  providers: [ShopOrdersService, ShopOrderProductsService, RechargeOrdersService],
  exports: [ShopOrdersService, ShopOrderProductsService, RechargeOrdersService],
})
export class OrdersModule { }
