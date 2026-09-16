// lib/splash.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _goToHome();
  }

  void _goToHome() async {
    await Future.delayed(const Duration(seconds: 5));

    final prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("user_token");

    if (!mounted) return;

    if (userToken != null && userToken.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TabBarPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
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
