// lib/models/user/pet-model.dart
class PetModel {
  final int id;
  final int userId;
  final String avatar;
  final String name;
  final int gender;
  final int category;
  final int furType;
  final String birthday;
  final int activationStatus;
  final double weight;

  const PetModel({
    required this.id,
    required this.userId,
    required this.avatar,
    required this.name,
    required this.gender,
    required this.category,
    required this.furType,
    required this.birthday,
    required this.activationStatus,
    required this.weight,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      avatar: json['avatar'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? 0,
      category: json['category'] ?? 0,
      furType: json['furType'] ?? 0,
      birthday: json['birthday'] ?? '',
      activationStatus: json['activationStatus'] ?? 0,
      weight: (json['weight'] ?? 0).toDouble(),
    );
  }
}
