// lib/models/shop/product-response.dart
import 'product-model.dart';

class ProductListResponse {
  final List<ProductModel> products;

  const ProductListResponse({required this.products});

  factory ProductListResponse.fromJson(List<dynamic> json) {
    return ProductListResponse(
      products: json
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProductResponse {
  final ProductModel product;

  const ProductResponse({required this.product});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(product: ProductModel.fromJson(json));
  }
}
