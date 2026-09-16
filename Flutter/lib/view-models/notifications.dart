// lib/view-models/notifications.dart
import 'package:flutter/material.dart';

class NotificationItemData {
  final String title;
  final String description;
  final String time;
  final IconData icon;

  const NotificationItemData({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
  });
}
