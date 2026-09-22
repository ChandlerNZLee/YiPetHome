// lib/models/appointment/appointment-model.dart
class ServiceModel {
  final int id;
  final int type;
  final String name;
  final String description;
  final String image;
  final int duration;
  final int priceId;
  final double price;

  ServiceModel({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.image,
    required this.duration,
    required this.priceId,
    required this.price,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? 0,
      type: json['_type'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      duration: json['duration'] ?? 0,
      priceId: json['priceId'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}

class GroomerModel {
  final int id;
  final int shopId;
  final String name;
  final int type;
  final int experience;
  final int customers;
  final String description;
  final double price;
  final String avatar;

  GroomerModel({
    required this.id,
    required this.shopId,
    required this.name,
    required this.type,
    required this.experience,
    required this.customers,
    required this.description,
    required this.price,
    required this.avatar,
  });

  factory GroomerModel.fromJson(Map<String, dynamic> json) {
    return GroomerModel(
      id: json['id'] ?? 0,
      shopId: json['shopId'] ?? 0,
      name: json['name'] ?? '',
      type: json['_type'] ?? 0,
      experience: json['experience'] ?? 0,
      customers: json['customers'] ?? 0,
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      avatar: json['avatar'] ?? '',
    );
  }
}

class AppointmentSlotModel {
  final DateTime startAt;
  final DateTime endAt;
  final bool available;

  AppointmentSlotModel({
    required this.startAt,
    required this.endAt,
    required this.available,
  });

  factory AppointmentSlotModel.fromJson(Map<String, dynamic> json) {
    return AppointmentSlotModel(
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      available: json['available'] as bool,
    );
  }
}

class AppointmentModel {
  final int id;
  final int type;
  final int userId;
  final int petId;
  final int shopId;
  final int groomerId;
  final DateTime startAt;
  final DateTime endAt;
  final DateTime blockingEndAt;
  final DateTime expiresAt;
  final int originPrice;
  final int discount;
  final int price;
  final int paymentStatus;
  final int appointmentStatus;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppointmentModel({
    this.id = 0,
    required this.type,
    required this.userId,
    required this.petId,
    required this.shopId,
    required this.groomerId,
    required this.startAt,
    required this.endAt,
    required this.blockingEndAt,
    required this.expiresAt,
    required this.originPrice,
    required this.discount,
    required this.price,
    required this.paymentStatus,
    required this.appointmentStatus,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] ?? 0,
      type: json['_type'] ?? 0,
      userId: json['userId'] ?? 0,
      petId: json['petId'] ?? 0,
      shopId: json['shopId'] ?? 0,
      groomerId: json['groomerId'] ?? 0,
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      blockingEndAt: DateTime.parse(json['blockingEndAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      originPrice: json['originPrice'] ?? 0,
      discount: json['discount'] ?? 0,
      price: json['price'] ?? 0,
      paymentStatus: json['paymentStatus'] ?? 0,
      appointmentStatus: json['appointmentStatus'] ?? 0,
      notes: json['notes'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
