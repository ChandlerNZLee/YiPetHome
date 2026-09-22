// lib/models/shop/shop-model.dart
class ShopModel {
  final int id;
  final String name;
  final String address;
  final String longitude;
  final String latitude;
  final String contact;
  final String openingTime;
  final String closingTime;
  final String description;
  final String image;

  const ShopModel({
    required this.id,
    required this.name,
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.contact,
    required this.openingTime,
    required this.closingTime,
    required this.description,
    required this.image,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      contact: json['contact'] ?? '',
      openingTime: json['openingTime'] ?? '',
      closingTime: json['closingTime'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
