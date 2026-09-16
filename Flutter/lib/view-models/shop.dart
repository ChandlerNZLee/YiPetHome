// lib/view-models/shop.dart
import 'package:flutter/material.dart';

import '../models/shop/shop-model.dart';

class ShopData {
  final int id;
  final String name;
  final String address;
  final String openingTime;
  final String closingTime;
  final String image;

  const ShopData({
    required this.id,
    required this.name,
    required this.address,
    required this.openingTime,
    required this.closingTime,
    required this.image,
  });

  factory ShopData.fromModel(ShopModel model) {
    return ShopData(
      id: model.id,
      name: model.name,
      address: model.address,
      openingTime: model.openingTime,
      closingTime: model.closingTime,
      image: model.image,
    );
  }
}

class ShopColors {
  static const primary = Color(0xFF22C55E);
  static const textPrimary = Color(0xFF17191C);
  static const textSecondary = Color(0xFF727780);
}
