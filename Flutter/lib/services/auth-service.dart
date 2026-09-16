// lib/services/auth-service.dart
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api-client.dart';
import '../models/auth/login-response.dart';
import '../models/common/common-response.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final ApiClient _api = ApiClient.instance;

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final result = await _api.post<LoginResponse>(
      '/auth/app/login',
      data: {'email': email, 'password': password},
      parser: (data) {
        return LoginResponse.fromJson(data as Map<String, dynamic>);
      },
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', result.accessToken);
    await prefs.setInt('user_id', result.user.id);

    return result;
  }

  Future<CommonResponse> reset(String email) async {
    final result = await _api.post<CommonResponse>(
      '/auth/app/reset',
      data: {'email': email},
      parser: (data) {
        return CommonResponse.fromJson(data as Map<String, dynamic>);
      },
    );

    return result;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
  }
}
