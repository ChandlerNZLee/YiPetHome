// lib/view-models/wallet.dart
import 'package:flutter/material.dart';

enum WalletTransactionType { topUp, payment, shopping }

class WalletTransactionData {
  final String title;
  final String subtitle;
  final double amount;
  final String date;
  final String time;
  final WalletTransactionType type;

  const WalletTransactionData({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.time,
    required this.type,
  });
}

class WalletMenuData {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  WalletMenuData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
