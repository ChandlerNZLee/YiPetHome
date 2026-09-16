// lib/models/auth/login-response.dart
import '../user/user-model.dart';

class LoginResponse {
  final String accessToken;
  final UserModel user;

  const LoginResponse({required this.accessToken, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}
