// lib/models/shop/order-model.dart
class OrderModel {
  final int id;
  final int userId;
  final int addressId;
  final String time;
  final double totalPrice;
  final int paymentStatus;
  final int orderStatus;
  final String trackingNumber;
  final List<OrderProductModel> products;

  OrderModel({
    this.id = 0,
    required this.userId,
    required this.addressId,
    this.time = '',
    this.totalPrice = 0.00,
    this.paymentStatus = 0,
    this.orderStatus = 0,
    this.trackingNumber = '',
    required this.products,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      addressId: json['addressId'] ?? 0,
      time: json['time'] ?? '',
      totalPrice: double.parse(json['totalPrice'].toString()),
      paymentStatus: json['paymentStatus'] ?? 0,
      orderStatus: json['orderStatus'] ?? 0,
      trackingNumber: json['trackingNumber'] ?? '',
      products: (json['orderProducts'] as List<dynamic>? ?? [])
          .map(
            (item) => OrderProductModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class OrderProductModel {
  final int id;
  final int orderId;
  final int productId;
  final int amount;
  final double price;
  final int stockId;
  final String image;

  OrderProductModel({
    this.id = 0,
    this.orderId = 0,
    required this.productId,
    required this.amount,
    required this.price,
    required this.stockId,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'amount': amount,
      'price': price,
      'stockId': stockId,
      'image': image,
    };
  }

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      id: json['id'] ?? 0,
      orderId: json['orderId'] ?? 0,
      productId: json['productId'] ?? 0,
      amount: json['amount'] ?? 0,
      price: json['price'].toDouble() ?? 0.00,
      stockId: json['stockId'] ?? 0,
      image: json['product']['image']['url'] ?? '',
    );
  }
}

class PaymentModel {
  final int paymentId;
  final int orderId;
  final String checkoutSessionId;
  final String checkoutUrl;

  PaymentModel({
    required this.paymentId,
    required this.orderId,
    required this.checkoutSessionId,
    required this.checkoutUrl,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      paymentId: json['paymentId'] ?? 0,
      orderId: json['orderId'] ?? 0,
      checkoutSessionId: json['checkoutSessionId'] ?? '',
      checkoutUrl: json['checkoutUrl'] ?? '',
    );
  }
}
