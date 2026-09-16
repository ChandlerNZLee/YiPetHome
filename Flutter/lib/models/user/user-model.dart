// lib/models/user/user-model.dart
class UserModel {
  final int id;
  final String username;
  final String password;
  final String avatar;
  final String mobile;
  final String email;
  final String firstName;
  final String lastName;
  final double balance;

  const UserModel({
    required this.id,
    required this.username,
    required this.password,
    required this.avatar,
    required this.mobile,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.balance,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      avatar: json['avatar'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }
}
