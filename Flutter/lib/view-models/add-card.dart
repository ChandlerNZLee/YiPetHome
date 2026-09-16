// lib/view-models/add-card.dart

class NewPaymentCardData {
  final String cardNumber;
  final String cardholderName;
  final String expirationDate;
  final String cvv;

  final String country;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String postalCode;

  const NewPaymentCardData({
    required this.cardNumber,
    required this.cardholderName,
    required this.expirationDate,
    required this.cvv,
    required this.country,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.postalCode,
  });
}
