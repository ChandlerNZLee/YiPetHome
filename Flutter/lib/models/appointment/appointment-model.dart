// lib/models/appointment/appointment-model.dart
class ServiceModel {
  final int id;
  final int type;
  final String name;
  final String description;
  final String image;
  final int duration;
  final double price;

  ServiceModel({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.image,
    required this.duration,
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
