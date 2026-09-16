// lib/services/shop-service.dart
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api-client.dart';

import '../models/shop/shop-response.dart';
import '../models/shop/product-response.dart';
import '../models/shop/order-response.dart';

class ShopService {
  ShopService._();

  static final ShopService instance = ShopService._();

  final ApiClient _api = ApiClient.instance;

  Future<ShopResponse> getShopList() async {
    final result = await _api.get<ShopResponse>(
      '/shops',
      parser: (data) {
        return ShopResponse.fromJson(data as List<dynamic>);
      },
    );

    return result;
  }

  Future<ProductListResponse> getProductList() async {
    final prefs = await SharedPreferences.getInstance();
    final shopId = prefs.getInt('shop_id');

    final result = await _api.get<ProductListResponse>(
      '/products/shop/$shopId',
      parser: (data) {
        return ProductListResponse.fromJson(data as List<dynamic>);
      },
    );

    return result;
  }

  Future<ProductListResponse> getRecentProductList() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    final result = await _api.get<ProductListResponse>(
      '/products/recent/$userId',
      parser: (data) {
        return ProductListResponse.fromJson(data as List<dynamic>);
      },
    );

    return result;
  }

  Future<ProductListResponse> getRecommendProductList(int type) async {
    final prefs = await SharedPreferences.getInstance();
    final petId = prefs.getInt('pet_id');
    final shopId = prefs.getInt('shop_id');

    final result = await _api.post<ProductListResponse>(
      '/products/recommend/$type',
      data: {'petId': petId, 'shopId': shopId},
      parser: (data) {
        return ProductListResponse.fromJson(data as List<dynamic>);
      },
    );

    return result;
  }

  Future<ProductListResponse> getSearchProductList(String keyword) async {
    final prefs = await SharedPreferences.getInstance();
    final shopId = prefs.getInt('shop_id');

    final result = await _api.post<ProductListResponse>(
      '/products/search',
      data: {'shopId': shopId, 'keyword': keyword},
      parser: (data) {
        return ProductListResponse.fromJson(data as List<dynamic>);
      },
    );

    return result;
  }

  Future<ProductResponse> getProduct(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final shopId = prefs.getInt('shop_id');

    final result = await _api.post<ProductResponse>(
      '/products/shop',
      data: {'shopId': shopId, 'productId': productId},
      parser: (data) {
        return ProductResponse.fromJson(data);
      },
    );

    return result;
  }

  Future<OrderResponse> createOrder(Map<String, dynamic> order) async {
    final result = await _api.post<OrderResponse>(
      '/orders',
      data: order,
      parser: (data) {
        return OrderResponse.fromJson(data);
      },
    );

    return result;
  }

  Future<PaymentResponse> checkPayment(int orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    final result = await _api.post<PaymentResponse>(
      '/payments/checkout',
      data: {'orderId': orderId, 'userId': userId},
      parser: (data) {
        return PaymentResponse.fromJson(data);
      },
    );

    return result;
  }

  Future<OrderListResponse> getOrderList() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    final result = await _api.get<OrderListResponse>(
      '/orders/user/$userId',
      parser: (data) {
        return OrderListResponse.fromJson(data as List<dynamic>);
      },
    );

    return result;
  }
}
