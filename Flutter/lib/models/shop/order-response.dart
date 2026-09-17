// lib/models/shop/order-response.dart
import 'order-model.dart';

class ShopOrderListResponse {
  final List<ShopOrderModel> orders;

  const ShopOrderListResponse({required this.orders});

  factory ShopOrderListResponse.fromJson(List<dynamic> json) {
    return ShopOrderListResponse(
      orders: json
          .map((item) => ShopOrderModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ShopOrderResponse {
  final bool success;
  final String message;
  final ShopOrderModel order;

  const ShopOrderResponse({
    required this.order,
    required this.success,
    required this.message,
  });

  factory ShopOrderResponse.fromJson(Map<String, dynamic> json) {
    return ShopOrderResponse(
      success: json['success'] == true,
      message: json['message'] ?? '',
      order: ShopOrderModel.fromJson(json['data'] ?? {}),
    );
  }
}

class RechargeOrderResponse {
  final bool success;
  final String message;
  final RechargeOrderModel order;

  const RechargeOrderResponse({
    required this.order,
    required this.success,
    required this.message,
  });

  factory RechargeOrderResponse.fromJson(Map<String, dynamic> json) {
    return RechargeOrderResponse(
      success: json['success'] == true,
      message: json['message'] ?? '',
      order: RechargeOrderModel.fromJson(json['data'] ?? {}),
    );
  }
}

class PaymentResponse {
  final PaymentModel payment;

  const PaymentResponse({required this.payment});

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(payment: PaymentModel.fromJson(json));
  }
}
