// lib/models/user/address-response.dart
import 'address-model.dart';

class AddressResponse {
  final List<AddressModel> addresses;

  const AddressResponse({required this.addresses});

  factory AddressResponse.fromJson(List<dynamic> json) {
    return AddressResponse(
      addresses: json
          .map((item) => AddressModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
