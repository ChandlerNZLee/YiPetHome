// lib/view-models/payment-methods.dart
import 'package:flutter/material.dart';

enum PaymentCardType { visa, mastercard, amex }

enum OtherPaymentType { applePay, googlePay }

extension OtherPaymentTypeExtension on OtherPaymentType {
  String get label {
    switch (this) {
      case OtherPaymentType.applePay:
        return 'Apple Pay';
      case OtherPaymentType.googlePay:
        return 'Google Pay';
    }
  }
}

class PaymentCardData {
  final String id;
  final PaymentCardType type;
  final String lastFour;
  final String cardholder;
  final String expiry;
  final bool isDefault;

  const PaymentCardData({
    required this.id,
    required this.type,
    required this.lastFour,
    required this.cardholder,
    required this.expiry,
    required this.isDefault,
  });

  PaymentCardData copyWith({
    String? id,
    PaymentCardType? type,
    String? lastFour,
    String? cardholder,
    String? expiry,
    bool? isDefault,
  }) {
    return PaymentCardData(
      id: id ?? this.id,
      type: type ?? this.type,
      lastFour: lastFour ?? this.lastFour,
      cardholder: cardholder ?? this.cardholder,
      expiry: expiry ?? this.expiry,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class PaymentCardVisualStyle {
  final List<Color> gradientColors;
  final Color borderColor;
  final Color primaryTextColor;
  final Color actionColor;
  final bool lightContent;

  const PaymentCardVisualStyle({
    required this.gradientColors,
    required this.borderColor,
    required this.primaryTextColor,
    required this.actionColor,
    required this.lightContent,
  });

  factory PaymentCardVisualStyle.fromType(PaymentCardType type) {
    switch (type) {
      case PaymentCardType.visa:
        return const PaymentCardVisualStyle(
          gradientColors: [Color(0xFF0A7B32), Color(0xFF006425)],
          borderColor: Color(0xFF0A7B32),
          primaryTextColor: Colors.white,
          actionColor: Colors.white,
          lightContent: true,
        );
      case PaymentCardType.mastercard:
        return const PaymentCardVisualStyle(
          gradientColors: [Color(0xFF3478C7), Color(0xFF1454A0)],
          borderColor: Color(0xFF2E6EB8),
          primaryTextColor: Colors.white,
          actionColor: Colors.white,
          lightContent: true,
        );
      case PaymentCardType.amex:
        return const PaymentCardVisualStyle(
          gradientColors: [Color(0xFFFFFFFF), Color(0xFFF8F9FB)],
          borderColor: Color(0xFFE6EAE6),
          primaryTextColor: Color(0xFF172038),
          actionColor: Color(0xFF1670B6),
          lightContent: false,
        );
    }
  }
}
