// lib/view-models/top-up.dart
import 'package:flutter/material.dart';

import '../models/user/bonus-model.dart';

enum TopUpBonusType { amount500, amount1000, amount3000, custom }

enum TopUpBadgeType { green, purple, orange }

class TopUpData {
  final int id;
  final TopUpBonusType type;
  final int amount;
  final int bonus;
  final String? badge;
  final TopUpBadgeType? badgeType;

  const TopUpData({
    required this.id,
    required this.type,
    required this.amount,
    required this.bonus,
    this.badge,
    this.badgeType,
  });

  factory TopUpData.fromModel(BonusModel model) {
    late TopUpBonusType type;
    String badge = '';
    late TopUpBadgeType badgeType;
    if (model.rechargeAmount == 500) {
      type = TopUpBonusType.amount500;
      badge = 'Most Popular';
      badgeType = TopUpBadgeType.green;
    } else if (model.rechargeAmount == 1000) {
      type = TopUpBonusType.amount1000;
      badge = 'Best Value';
      badgeType = TopUpBadgeType.purple;
    } else if (model.rechargeAmount == 3000) {
      type = TopUpBonusType.amount3000;
      badge = 'Max Bonus';
      badgeType = TopUpBadgeType.orange;
    }

    return TopUpData(
      id: model.id,
      type: type,
      amount: model.rechargeAmount,
      bonus: model.giftAmount,
      badge: badge,
      badgeType: badgeType,
    );
  }
}

class TopUpColor {
  static const Color primary = Color(0xFF15952A);
  static const Color textPrimary = Color(0xFF172038);
  static const Color textSecondary = Color(0xFF667087);
  static const Color border = Color(0xFFE6EAE6);
  static const Color background = Color(0xFFFCFDFB);
}
