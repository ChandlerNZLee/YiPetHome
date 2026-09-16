import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';

import type { CreateOrderDto } from './dto/create-order.dto';
import type { UpdateOrderDto } from './dto/update-order.dto';

@Injectable()
export class OrdersService {
  constructor(private readonly prisma: PrismaService) { }

  private generateTrackingNumber(): string {
    const now = new Date();
    const date = now.getFullYear().toString() + (now.getMonth() + 1).toString().padStart(2, '0') + now.getDate().toString().padStart(2, '0');
    const time = now.getHours().toString().padStart(2, '0') + now.getMinutes().toString().padStart(2, '0') + now.getSeconds().toString().padStart(2, '0');
    const random = Math.floor(1000 + Math.random() * 9000);

    return `TRK${date}${time}${random}`;
  }

  async create(createOrderDto: CreateOrderDto) {
    const { userId, addressId, products } = createOrderDto;

    if (!products || products.length === 0) {
      throw new BadRequestException('Order must contain at least one product');
    }

    let totalPrice = 0;

    const orderProducts: {
      productId: number;
      stockId: number;
      quantity: number;
      price: number;
    }[] = [];

    for (const product of products) {
      const stock = await this.prisma.db.orm.public.ProductStocks.where({ id: product.stockId }).first();

      if (!stock) {
        throw new NotFoundException(`Stock ${product.stockId} not found`);
      }

      if (stock.stock < product.quantity) {
        throw new BadRequestException(`Insufficient stock for stock ID ${product.stockId}`);
      }

      totalPrice += stock.price * product.quantity;

      orderProducts.push({
        productId: product.productId,
        stockId: product.stockId,
        quantity: product.quantity,
        price: stock.price,
      });
    }

    const result = await this.prisma.db.transaction(async (tx) => {
      const order = await tx.orm.public.Orders.create({
        userId,
        addressId,
        time: new Date().toISOString(),
        totalPrice: Number(totalPrice.toFixed(2)),
        paymentStatus: 0,
        orderStatus: 0,
        trackingNumber: null,
      });

      for (const product of orderProducts) {
        await tx.orm.public.OrderProducts.create({
          orderId: order.id,
          productId: product.productId,
          stockId: product.stockId,
          amount: product.quantity,
          price: product.price,
        });
      }

      return order;
    });

    return {
      success: true,
      message: 'Order created successfully',
      data: {
        ...result,
        products: orderProducts,
      },
    };
  }

  async process(id: number) {
    const order = await this.prisma.db.orm.public.Orders.where({ id }).first();

    if (!order) {
      throw new NotFoundException(`Order ${id} not found`);
    }

    if (!order.trackingNumber) {
      await this.prisma.db.orm.public.Orders.where({ id }).update({
        trackingNumber: this.generateTrackingNumber(),
      });
    }

    await this.prisma.db.orm.public.Orders.where({ id }).update({
      orderStatus: order.orderStatus + 1,
    });

    return {
      success: true,
      message: 'Order paid successfully',
    };
  }

  async findAll() {
    const orders = await this.prisma.db.orm.public.Orders.all();
    return Promise.all(
      orders.map(async (order) => {
        const user = await this.prisma.db.orm.public.Users.where({ id: order.userId }).first();
        const address = await this.prisma.db.orm.public.Addresses.where({ id: order.addressId }).first();

        if (!user) {
          throw new NotFoundException('User not found');
        }

        if (!address) {
          throw new NotFoundException('Address not found');
        }

        return {
          ...order,
          user: `${user.firstName} ${user.lastName}`,
          address: `${address.details}, ${address.city}, ${address.province}`,
        };
      }),
    );
  }

  findOne(id: number) {
    return this.prisma.db.orm.public.Orders.where({ id }).first();
  }

  async findByUserId(id: number) {
    const orders = await this.prisma.db.orm.public.Orders.where({ userId: id }).all();

    const result = [];

    for (const order of orders) {
      const orderProducts = await this.prisma.db.orm.public.OrderProducts.where({ orderId: order.id }).all();
      const productsWithDetails = [];

      for (const orderProduct of orderProducts) {
        const product = await this.prisma.db.orm.public.Products.where({ id: orderProduct.productId }).first();
        const productImage = await this.prisma.db.orm.public.ProductImages.where({ productId: orderProduct.productId }).first();

        productsWithDetails.push({
          ...orderProduct,
          product: product
            ? {
              ...product,
              image: productImage ?? null,
            }
            : null,
        });
      }

      result.push({
        ...order,
        orderProducts: productsWithDetails,
      });
    }

    return result;
  }

  update(id: number, updateOrderDto: UpdateOrderDto) {
    return this.prisma.db.orm.public.Orders.where({ id }).update(updateOrderDto);
  }

  async remove(id: number) {
    await this.prisma.db.orm.public.Orders.where({ id }).delete();
    return {
      message: 'Order deleted successfully',
    };
  }

  async removeAll(): Promise<{
    message: string;
    deletedCount: number;
  }> {
    const deletedCount = await this.prisma.db.orm.public.Orders.where({}).deleteAndCount();
    return {
      message: 'All orders deleted successfully',
      deletedCount: deletedCount,
    };
  }
}
