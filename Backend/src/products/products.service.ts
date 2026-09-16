import { Injectable, NotFoundException } from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';

import type { CreateProductDto } from './dto/create-product.dto';
import type { UpdateProductDto } from './dto/update-product.dto';
import type { QueryProductDto } from './dto/query-product.dto';

@Injectable()
export class ProductsService {
  constructor(private readonly prisma: PrismaService) { }

  create(createProductDto: CreateProductDto) {
    return this.prisma.db.orm.public.Products.create(createProductDto);
  }

  async findAll() {
    const products = await this.prisma.db.orm.public.Products.all();
    const productImages = await this.prisma.db.orm.public.ProductImages.all();

    return products.map((product) => {
      const latestImage = productImages
        .filter((item) => item.productId === product.id)
        .sort((a, b) => b.id - a.id)[0];

      return {
        ...product,
        image: latestImage?.url ?? null,
      };
    });
  }

  async findOne(id: number) {
    return this.prisma.db.orm.public.Products.where({ id }).first();
  }

  async findByShopId(id: number) {
    const products = await this.prisma.db.orm.public.Products.all();
    const productStocks = await this.prisma.db.orm.public.ProductStocks.where({ shopId: id }).all();
    const productImages = await this.prisma.db.orm.public.ProductImages.all();
    const productIds = new Set(
      productStocks.map((stock) => stock.productId),
    );

    return products
      .filter((product) => productIds.has(product.id))
      .map((product) => {
        const latestImage = productImages
          .filter((image) => image.productId === product.id)
          .sort((a, b) => b.sortOrder - a.sortOrder)[0];
        const latestStock = productStocks
          .filter((stock) => stock.productId === product.id)
          .sort((a, b) => b.id - a.id)[0];

        return {
          ...product,
          image: latestImage?.url ?? null,
          stock: latestStock ?? null,
        };
      });
  }

  async findRecommendByType(type: number, queryProductDto: QueryProductDto) {
    const pet = await this.prisma.db.orm.public.Pets.where({ id: queryProductDto.petId }).first();

    if (!pet) {
      throw new NotFoundException('Pet not found');
    }

    let products = await this.prisma.db.orm.public.Products.where({ category: pet.category }).all();
    products = products.sort((a, b) => b.id - a.id);

    if (pet.category === type || pet.category === 0) {
      products = products.slice(0, 3);
    }

    const productImages = await this.prisma.db.orm.public.ProductImages.all();
    const productStocks = await this.prisma.db.orm.public.ProductStocks.where({ shopId: queryProductDto.shopId }).all();

    return products.map((product) => {
      const latestImage = productImages
        .filter((image) => image.productId === product.id)
        .sort((a, b) => b.sortOrder - a.sortOrder)[0];
      const latestStock = productStocks
        .filter((stock) => stock.productId === product.id)
        .sort((a, b) => b.id - a.id)[0];

      return {
        ...product,
        image: latestImage?.url ?? null,
        stock: latestStock ?? null,
      };
    });
  }

  async findByKeyword(queryProductDto: QueryProductDto) {
    const keyword = queryProductDto.keyword?.trim().toLowerCase() ?? '';
    const allProducts = await this.prisma.db.orm.public.Products.all();
    const products = allProducts.filter((product) => {
      const name = product.name?.toLowerCase() ?? '';
      const nameZh = product.nameZh?.toLowerCase() ?? '';

      return name.includes(keyword) || nameZh.includes(keyword);
    });

    const productImages = await this.prisma.db.orm.public.ProductImages.all();
    const productStocks = await this.prisma.db.orm.public.ProductStocks.where({ shopId: queryProductDto.shopId }).all();

    return products.map((product) => {
      const latestImage = productImages
        .filter((image) => image.productId === product.id)
        .sort((a, b) => b.sortOrder - a.sortOrder)[0];
      const latestStock = productStocks
        .filter((stock) => stock.productId === product.id)
        .sort((a, b) => b.id - a.id)[0];

      return {
        ...product,
        image: latestImage?.url ?? null,
        stock: latestStock ?? null,
      };
    });
  }

  async findOneByShop(queryProductDto: QueryProductDto) {
    const product = await this.prisma.db.orm.public.Products.where({ id: queryProductDto.productId }).first();

    if (!product) {
      throw new NotFoundException('Product not found');
    }

    const productImages = await this.prisma.db.orm.public.ProductImages.where({ productId: product.id }).all();
    const productStocks = await this.prisma.db.orm.public.ProductStocks
      .where({
        productId: product.id,
        shopId: queryProductDto.shopId,
      })
      .all();

    const sortedImages = productImages.sort((a, b) => b.sortOrder - a.sortOrder);
    const sortedStocks = productStocks.sort((a, b) => b.id - a.id);

    return {
      ...product,
      image: sortedImages[0]?.url ?? null,
      stock: sortedStocks[0] ?? null,
      product_images: sortedImages,
      product_stocks: sortedStocks,

    };
  }

  async update(id: number, updateProductDto: UpdateProductDto) {
    return this.prisma.db.orm.public.Products.where({ id }).update(updateProductDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.Products.where({ id }).delete();
    return {
      message: 'Product deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.Products.where({}).deleteAndCount();
    return {
      message: 'All products deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
