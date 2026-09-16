// lib/view-models/my.dart
import 'package:flutter/material.dart';

class MyMenuItemData {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final String? trailingText;

  const MyMenuItemData({
    required this.title,
    required this.icon,
    this.iconColor,
    this.trailingText,
  });
}

class MyColors {
  static const primary = Color(0xFF22C55E);
  static const textPrimary = Color(0xFF17191D);
  static const textSecondary = Color(0xFF747981);
  static const border = Color(0xFFECEFEC);
  static const background = Color(0xFFFCFDFB);
}
