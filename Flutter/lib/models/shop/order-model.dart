// lib/models/shop/order-model.dart
class ShopOrderModel {
  final int id;
  final int userId;
  final int addressId;
  final String time;
  final double totalPrice;
  final int paymentStatus;
  final int orderStatus;
  final String trackingNumber;
  final List<ShopOrderProductModel> products;

  ShopOrderModel({
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

  factory ShopOrderModel.fromJson(Map<String, dynamic> json) {
    return ShopOrderModel(
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
            (item) =>
                ShopOrderProductModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class ShopOrderProductModel {
  final int id;
  final int orderId;
  final int productId;
  final int amount;
  final double price;
  final int stockId;
  final String image;

  ShopOrderProductModel({
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

  factory ShopOrderProductModel.fromJson(Map<String, dynamic> json) {
    return ShopOrderProductModel(
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

class RechargeOrderModel {
  final int id;
  final int userId;
  final int bonusId;
  final int amount;
  final int rechargeAmount;
  final int paymentStatus;
  final String transactionId;
  final RechargeBonusModel bonus;

  RechargeOrderModel({
    this.id = 0,
    required this.userId,
    required this.bonusId,
    this.amount = 0,
    this.rechargeAmount = 0,
    this.paymentStatus = 0,
    this.transactionId = '',
    required this.bonus,
  });

  factory RechargeOrderModel.fromJson(Map<String, dynamic> json) {
    return RechargeOrderModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      bonusId: json['bonusId'] ?? 0,
      amount: json['amount'] ?? 0,
      rechargeAmount: json['amount'] ?? 0,
      paymentStatus: json['paymentStatus'] ?? 0,
      transactionId: json['trackingNumber'] ?? '',
      bonus: RechargeBonusModel.fromJson(
        json['bonus'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class RechargeBonusModel {
  final int id;
  final String name;
  final int rechargeAmount;
  final int giftAmount;
  final int sortOrder;
  final int activationStatus;

  RechargeBonusModel({
    this.id = 0,
    required this.name,
    required this.rechargeAmount,
    required this.giftAmount,
    required this.sortOrder,
    required this.activationStatus,
  });

  factory RechargeBonusModel.fromJson(Map<String, dynamic> json) {
    return RechargeBonusModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      rechargeAmount: json['rechargeAmount'] ?? 0,
      giftAmount: json['giftAmount'] ?? 0,
      sortOrder: json['sortOrder'] ?? 0,
      activationStatus: json['stockId'] ?? 0,
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
