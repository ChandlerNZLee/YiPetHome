// lib/splash.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/user-service.dart';
import '../core/auth/token-storage.dart';
import '../core/network/api-exception.dart';

import '/page/login.dart';
import '/page/tabbar.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    await _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await TokenStorage.instance.getToken();

    if (token == null || token.isEmpty) {
      _goToLogin();
      return;
    }

    try {
      final res = await UserService.instance.getUserData();

      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt('user_id', res.user.id);

      if (!mounted) return;

      _goToHome();
    } on ApiException catch (e) {
      if (!mounted) return;

      if (e.statusCode == 401) {
        return;
      }

      _goToLogin();
    }
  }

  void _goToLogin() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _goToHome() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TabBarPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/splash/launch.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
