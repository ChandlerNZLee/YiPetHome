// lib/view-models/payment.dart

enum PaymentSummaryType { appointment, shopping, topup }

enum PaymentMethodType { online, wallet }

class PaymentResult {
  final double amount;
  final PaymentMethodType paymentMethod;
  final bool success;

  const PaymentResult({
    required this.amount,
    required this.paymentMethod,
    required this.success,
  });
}
