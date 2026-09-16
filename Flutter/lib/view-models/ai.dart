// lib/view-models/ai.dart
import 'package:flutter/material.dart';

class AiActionData {
  final String title;
  final String subtitle;
  final String imagePath;
  final IconData icon;

  const AiActionData({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.icon,
  });
}

class AiColors {
  static const primary = Color(0xFF22C55E);
  static const textPrimary = Color(0xFF17191D);
  static const textSecondary = Color(0xFF777B84);
  static const border = Color(0xFFECEFEC);
}
