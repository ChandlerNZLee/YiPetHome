// lib/view-models/health-record.dart
import 'package:flutter/material.dart';

enum RecordStatus { upcoming, completed }

class HealthRecordData {
  final String title;
  final String date;
  final RecordStatus status;
  final IconData icon;

  const HealthRecordData({
    required this.title,
    required this.date,
    required this.status,
    required this.icon,
  });
}

class HealthRecordColors {
  static const primary = Color(0xFF22C55E);
  static const textPrimary = Color(0xFF17191D);
  static const textSecondary = Color(0xFF7A8088);
}
