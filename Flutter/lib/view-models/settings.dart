// lib/view-models/settings.dart
import 'package:flutter/material.dart';

class SettingsItemData {
  final String title;
  final IconData icon;

  const SettingsItemData({required this.title, required this.icon});
}

class SettingsColors {
  static const primary = Color(0xFF22C55E);
  static const textPrimary = Color(0xFF17191D);
  static const textSecondary = Color(0xFF646971);
  static const border = Color(0xFFE9ECE9);
  static const iconBackground = Color(0xFFF1F9EE);
  static const danger = Color(0xFFFF334D);
  static const background = Color(0xFFFCFDFB);
}
