// lib/models/user/pet-response.dart
import 'pet-model.dart';

class PetResponse {
  final List<PetModel> pets;

  const PetResponse({required this.pets});

  factory PetResponse.fromJson(List<dynamic> json) {
    return PetResponse(
      pets: json
          .map((item) => PetModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
