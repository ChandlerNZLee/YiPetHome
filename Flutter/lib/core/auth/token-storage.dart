import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage._();

  static final TokenStorage instance = TokenStorage._();

  static const String _tokenKey = 'user_token';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    final secureToken = await _storage.read(key: _tokenKey);

    if (secureToken != null && secureToken.isNotEmpty) {
      return secureToken;
    }

    return null;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
