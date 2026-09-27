import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'token-storage.dart';

enum AuthSessionEvent { logout, expired }

class AuthSession {
  AuthSession._();

  static final AuthSession instance = AuthSession._();

  final StreamController<AuthSessionEvent> _controller =
      StreamController<AuthSessionEvent>.broadcast();

  Stream<AuthSessionEvent> get events => _controller.stream;

  bool _isClearing = false;

  Future<void> createSession({
    required String token,
    required int userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);

    await TokenStorage.instance.saveToken(token);
  }

  Future<void> logout() async {
    await _clearSession(AuthSessionEvent.logout);
  }

  Future<void> expire() async {
    await _clearSession(AuthSessionEvent.expired, requireToken: true);
  }

  Future<void> _clearSession(
    AuthSessionEvent event, {
    bool requireToken = false,
  }) async {
    if (_isClearing) return;

    _isClearing = true;

    try {
      final token = await TokenStorage.instance.getToken();

      if (requireToken && (token == null || token.isEmpty)) {
        return;
      }

      await TokenStorage.instance.deleteToken();

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');

      await prefs.remove('username');
      await prefs.remove('email');
      await prefs.remove('role');

      _controller.add(event);
    } finally {
      _isClearing = false;
    }
  }
}
