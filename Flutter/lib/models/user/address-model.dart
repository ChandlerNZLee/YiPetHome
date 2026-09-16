// lib/models/user/address-model.dart

import '../../view-models/address.dart';

class AddressModel {
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

  AddressModel({
    this.id = 0,
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

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? 0,
      province: json['province'] ?? '',
      city: json['city'] ?? '',
      details: json['details'] ?? '',
      mobile: json['mobile'] ?? '',
      postcode: json['postcode'] ?? '',
      contact: json['contact'] ?? '',
      email: json['email'] ?? '',
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      isDefault: json['isDefault'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'province': province,
      'city': city,
      'details': details,
      'mobile': mobile,
      'postcode': postcode,
      'contact': contact,
      'email': email,
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  factory AddressModel.fromData(AddressData data) {
    return AddressModel(
      id: data.id,
      province: data.province,
      city: data.city,
      details: data.details,
      mobile: data.mobile,
      postcode: data.postcode,
      contact: data.contact,
      email: data.email,
      longitude: data.longitude,
      latitude: data.latitude,
      isDefault: data.isDefault,
    );
  }
}
