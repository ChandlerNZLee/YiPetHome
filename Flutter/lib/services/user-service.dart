// lib/services/user-service.dart
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api-client.dart';
import '../models/user/user-response.dart';
import '../models/user/pet-response.dart';
import '../models/user/address-response.dart';
import '../models/common/common-response.dart';
import '../models/user/address-model.dart';
import '../models/user/bonus-response.dart';

class UserService {
  UserService._();

  static final UserService instance = UserService._();

  final ApiClient _api = ApiClient.instance;

  Future<UserResponse> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    final result = await _api.get<UserResponse>(
      '/users/$userId',
      parser: (data) {
        return UserResponse.fromJson(data as Map<String, dynamic>);
      },
    );

    return result;
  }

  Future<PetResponse> getPetList() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    final result = await _api.get<PetResponse>(
      '/pets/user/$userId',
      parser: (data) {
        return PetResponse.fromJson(data as List<dynamic>);
      },
    );

    return result;
  }

  Future<AddressResponse> getAddressList() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    final result = await _api.get<AddressResponse>(
      '/addresses/user/$userId',
      parser: (data) {
        return AddressResponse.fromJson(data as List<dynamic>);
      },
    );

    return result;
  }

  Future<CommonResponse> addAddress(AddressModel address) async {
    final result = await _api.post<CommonResponse>(
      '/addresses',
      data: address.toJson(),
      parser: (data) {
        return CommonResponse.fromJson(data as Map<String, dynamic>);
      },
    );

    return result;
  }

  Future<CommonResponse> editAddress(AddressModel address) async {
    final result = await _api.put<CommonResponse>(
      '/addresses/${address.id}',
      data: address.toJson(),
      parser: (data) {
        return CommonResponse.fromJson(data as Map<String, dynamic>);
      },
    );

    return result;
  }

  Future<CommonResponse> deleteAddress(int addressId) async {
    final result = await _api.delete<CommonResponse>(
      '/addresses/$addressId',
      parser: (data) {
        return CommonResponse.fromJson(data as Map<String, dynamic>);
      },
    );

    return result;
  }

  Future<BonusResponse> getBonusList() async {
    final result = await _api.get<BonusResponse>(
      '/recharge-bonuses',
      parser: (data) {
        return BonusResponse.fromJson(data as List<dynamic>);
      },
    );

    return result;
  }
}
