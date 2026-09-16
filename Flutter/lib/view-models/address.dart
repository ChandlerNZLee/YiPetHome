// lib/view-models/addresses.dart

import '../models/user/address-model.dart';

class AddressData {
  final int id;
  final String province;
  final String city;
  final String details;
  final String mobile;
  final String postcode;
  final String contact;
  final String email;
  final String longitude;
  final String latitude;
  final int isDefault;

  const AddressData({
    required this.id,
    required this.province,
    required this.city,
    required this.details,
    required this.mobile,
    required this.postcode,
    required this.contact,
    required this.email,
    required this.longitude,
    required this.latitude,
    required this.isDefault,
  });

  factory AddressData.fromModel(AddressModel model) {
    return AddressData(
      id: model.id,
      province: model.province,
      city: model.city,
      details: model.details,
      mobile: model.mobile,
      postcode: model.postcode,
      contact: model.contact,
      email: model.email,
      longitude: model.longitude,
      latitude: model.latitude,
      isDefault: model.isDefault,
    );
  }

  AddressData copyWith({
    int? id,
    String? province,
    String? city,
    String? details,
    String? mobile,
    String? postcode,
    String? contact,
    String? email,
    String? longitude,
    String? latitude,
    int? isDefault,
  }) {
    return AddressData(
      id: id ?? this.id,
      province: province ?? this.province,
      city: city ?? this.city,
      details: details ?? this.details,
      mobile: mobile ?? this.mobile,
      postcode: postcode ?? this.postcode,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
