// lib/view-models/membership.dart
import 'package:flutter/material.dart';

class MembershipBenefitData {
  final String title;
  final String subtitle;
  final IconData icon;

  const MembershipBenefitData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class MembershipColors {
  static const primary = Color(0xFF22C55E);
  static const textPrimary = Color(0xFF17191D);
  static const textSecondary = Color(0xFF747982);
  static const border = Color(0xFFECEFEC);
}
