// lib/models/user/user-response.dart
import 'user-model.dart';

class UserResponse {
  final UserModel user;

  const UserResponse({required this.user});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(user: UserModel.fromJson(json));
  }
}
