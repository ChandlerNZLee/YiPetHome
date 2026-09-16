import { Module } from '@nestjs/common';

import { ProductsController } from './products.controller';
import { ProductsService } from './products.service';
import { ProductImagesController } from './product-images/product-images.controller';
import { ProductImagesService } from './product-images/product-images.service';
import { ProductStocksController } from './product-stocks/product-stocks.controller';
import { ProductStocksService } from './product-stocks/product-stocks.service';

@Module({
  controllers: [ProductsController, ProductImagesController, ProductStocksController],
  providers: [ProductsService, ProductImagesService, ProductStocksService],
  exports: [ProductsService, ProductImagesService, ProductStocksService],
})
export class ProductsModule {}
