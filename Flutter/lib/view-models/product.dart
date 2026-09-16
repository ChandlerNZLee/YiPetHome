// lib/view-models/product.dart
import 'package:flutter/material.dart';

import '../models/shop/product-model.dart';

class CategoryData {
  const CategoryData({
    required this.id,
    required this.title,
    this.icon,
    this.imagePath,
  });

  final int id;
  final String title;
  final IconData? icon;
  final String? imagePath;
}

class ProductData {
  ProductData({
    required this.id,
    required this.category,
    required this.type,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.stock,
    this.images = const [],
    this.stocks = const [],
    this.isFavorite = false,
  });

  final int id;
  final int category;
  final int type;
  final String name;
  final String description;
  final String imagePath;
  final ProductStockData stock;
  List<ProductImageData> images;
  List<ProductStockData> stocks;

  bool isFavorite;

  factory ProductData.fromModel(ProductModel model) {
    return ProductData(
      id: model.id,
      category: model.category,
      type: model.type,
      name: model.name,
      description: model.description,
      imagePath: model.image,
      stock: ProductStockData.fromModel(model.stock),
      images: (model.images ?? [])
          .map((item) => ProductImageData.fromModel(item))
          .toList(),
      stocks: (model.stocks ?? [])
          .map((item) => ProductStockData.fromModel(item))
          .toList(),
    );
  }
}

class ProductImageData {
  ProductImageData({required this.url});

  final String url;

  factory ProductImageData.fromModel(ProductImageModel model) {
    return ProductImageData(url: model.url);
  }
}

class ProductStockData {
  ProductStockData({
    required this.id,
    required this.size,
    required this.price,
    required this.discount,
    required this.stock,
  });

  final int id;
  final String size;
  final double price;
  final double discount;
  final int stock;

  factory ProductStockData.fromModel(ProductStockModel model) {
    return ProductStockData(
      id: model.id,
      size: model.size,
      price: model.price.toDouble(),
      discount: model.discount.toDouble(),
      stock: model.stock,
    );
  }
}
