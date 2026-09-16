// lib/models/shop/order-response.dart
import 'order-model.dart';

class OrderListResponse {
  final List<OrderModel> orders;

  const OrderListResponse({required this.orders});

  factory OrderListResponse.fromJson(List<dynamic> json) {
    return OrderListResponse(
      orders: json
          .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OrderResponse {
  final bool success;
  final String message;
  final OrderModel order;

  const OrderResponse({
    required this.order,
    required this.success,
    required this.message,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      success: json['success'] == true,
      message: json['message'] ?? '',
      order: OrderModel.fromJson(json['data'] ?? {}),
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
