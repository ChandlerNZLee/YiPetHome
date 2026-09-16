// lib/models/user/bonus-response.dart
import 'bonus-model.dart';

class BonusResponse {
  final List<BonusModel> bonuses;

  const BonusResponse({required this.bonuses});

  factory BonusResponse.fromJson(List<dynamic> json) {
    return BonusResponse(
      bonuses: json
          .map((item) => BonusModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
