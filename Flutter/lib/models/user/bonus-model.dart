// lib/models/user/bonus-model.dart
class BonusModel {
  final int id;
  final String name;
  final int rechargeAmount;
  final int giftAmount;
  final int activationStatus;
  final int sortOrder;

  const BonusModel({
    required this.id,
    required this.name,
    required this.rechargeAmount,
    required this.giftAmount,
    required this.activationStatus,
    required this.sortOrder,
  });

  factory BonusModel.fromJson(Map<String, dynamic> json) {
    return BonusModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      rechargeAmount: json['rechargeAmount'] ?? 0,
      giftAmount: json['giftAmount'] ?? 0,
      activationStatus: json['activationStatus'] ?? 0,
      sortOrder: json['sortOrder'] ?? 0,
    );
  }
}
