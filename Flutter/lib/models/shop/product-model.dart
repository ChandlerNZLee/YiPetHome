// lib/models/shop/product-model.dart
class ProductModel {
  final int id;
  final int category;
  final int type;
  final String name;
  final String description;
  final String image;
  final ProductStockModel stock;
  List<ProductImageModel>? images;
  List<ProductStockModel>? stocks;

  ProductModel({
    required this.id,
    required this.category,
    required this.type,
    required this.name,
    required this.description,
    required this.image,
    required this.stock,
    this.images = const [],
    this.stocks = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      category: json['category'] ?? 0,
      type: json['_type'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      stock: ProductStockModel.fromJson(json['stock'] as Map<String, dynamic>),
      images: (json['product_images'] as List<dynamic>? ?? [])
          .map(
            (item) => ProductImageModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      stocks: (json['product_stocks'] as List<dynamic>? ?? [])
          .map(
            (item) => ProductStockModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class ProductImageModel {
  final String url;

  ProductImageModel({required this.url});

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(url: json['url'] ?? '');
  }
}

class ProductStockModel {
  final int id;
  final String size;
  final double price;
  final double discount;
  final int stock;

  ProductStockModel({
    required this.id,
    required this.size,
    required this.price,
    required this.discount,
    required this.stock,
  });

  factory ProductStockModel.fromJson(Map<String, dynamic> json) {
    return ProductStockModel(
      id: json['id'] ?? 0,
      size: json['size'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
    );
  }
}
