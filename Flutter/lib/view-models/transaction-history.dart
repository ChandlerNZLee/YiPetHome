// lib/view-models/transaction-history.dart
import 'package:flutter/material.dart';

enum TransactionType { income, expense, transfer }

enum TransactionIconType {
  shopping,
  topUp,
  appointment,
  transfer,
  reward,
  medication,
}

class TransactionData {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final String date;
  final String time;
  final TransactionType type;
  final TransactionIconType iconType;

  const TransactionData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.time,
    required this.type,
    required this.iconType,
  });
}

class TransactionVisualStyle {
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const TransactionVisualStyle({
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  factory TransactionVisualStyle.fromIconType(TransactionIconType type) {
    switch (type) {
      case TransactionIconType.shopping:
        return const TransactionVisualStyle(
          icon: Icons.shopping_bag_outlined,
          color: Color(0xFF15952A),
          backgroundColor: Color(0xFFEDF8EE),
        );
      case TransactionIconType.topUp:
        return const TransactionVisualStyle(
          icon: Icons.add_rounded,
          color: Color(0xFF15952A),
          backgroundColor: Color(0xFFEDF8EE),
        );
      case TransactionIconType.appointment:
        return const TransactionVisualStyle(
          icon: Icons.calendar_month_outlined,
          color: Color(0xFFE73544),
          backgroundColor: Color(0xFFFFECEF),
        );
      case TransactionIconType.transfer:
        return const TransactionVisualStyle(
          icon: Icons.sync_alt_rounded,
          color: Color(0xFF2887D9),
          backgroundColor: Color(0xFFEDF6FF),
        );
      case TransactionIconType.reward:
        return const TransactionVisualStyle(
          icon: Icons.card_giftcard_rounded,
          color: Color(0xFF15952A),
          backgroundColor: Color(0xFFEDF8EE),
        );
      case TransactionIconType.medication:
        return const TransactionVisualStyle(
          icon: Icons.medical_services_outlined,
          color: Color(0xFFE94382),
          backgroundColor: Color(0xFFFFECF4),
        );
    }
  }
}
