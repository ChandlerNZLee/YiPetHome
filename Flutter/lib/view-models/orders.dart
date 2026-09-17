// lib/view-models/orders.dart
import 'package:flutter/material.dart';

import '../models/shop/order-model.dart';

enum ShopOrderStatus { toPay, processing, shipped, delivered, cancelled }

class ShopOrderData {
  final int id;
  final int userId;
  final int addressId;
  final String time;
  final double totalPrice;
  final int paymentStatus;
  final int orderStatus;
  final String trackingNumber;
  final List<ShopOrderProductData> products;

  const ShopOrderData({
    required this.id,
    required this.userId,
    required this.addressId,
    required this.time,
    required this.totalPrice,
    required this.paymentStatus,
    required this.orderStatus,
    required this.trackingNumber,
    required this.products,
  });

  factory ShopOrderData.fromModel(ShopOrderModel model) {
    final products = model.products
        .map((product) => ShopOrderProductData.fromModel(product))
        .toList();

    return ShopOrderData(
      id: model.id,
      userId: model.userId,
      addressId: model.addressId,
      time: model.time,
      totalPrice: model.totalPrice,
      paymentStatus: model.paymentStatus,
      orderStatus: model.orderStatus,
      trackingNumber: model.trackingNumber,
      products: products,
    );
  }
}

class ShopOrderProductData {
  final int id;
  final int orderId;
  final int productId;
  final int amount;
  final double price;
  final int stockId;
  final String image;

  ShopOrderProductData({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.amount,
    required this.price,
    required this.stockId,
    required this.image,
  });

  factory ShopOrderProductData.fromModel(ShopOrderProductModel model) {
    return ShopOrderProductData(
      id: model.id,
      orderId: model.orderId,
      productId: model.productId,
      amount: model.amount,
      price: model.price,
      stockId: model.stockId,
      image: model.image,
    );
  }
}

class OrderStatusStyle {
  final String text;
  final Color foreground;
  final Color background;

  const OrderStatusStyle({
    required this.text,
    required this.foreground,
    required this.background,
  });
}

class OrdersColors {
  static const primary = Color(0xFF22C55E);
  static const textPrimary = Color(0xFF17191D);
  static const textSecondary = Color(0xFF747982);
  static const border = Color(0xFFECEFEC);
}
