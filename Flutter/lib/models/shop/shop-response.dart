// lib/models/shop/shop-response.dart
import 'shop-model.dart';

class ShopResponse {
  final List<ShopModel> shops;

  const ShopResponse({required this.shops});

  factory ShopResponse.fromJson(List<dynamic> json) {
    return ShopResponse(
      shops: json
          .map((item) => ShopModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
