// lib/component/payment/summary.dart
import 'package:flutter/material.dart';

import '../../view-models/appointment.dart';
import '../../view-models/address.dart';

class AppointmentPaymentSummary extends StatelessWidget {
  final PaymentAppointmentData appointment;
  final double discount;

  const AppointmentPaymentSummary({
    super.key,
    required this.appointment,
    this.discount = 0,
  });

  double get subtotal {
    double subtotal = appointment.service.price;
    subtotal += appointment.styling?.price ?? 0;
    subtotal += appointment.spa?.price ?? 0;

    for (final addon in appointment.addons) {
      subtotal += addon.price;
    }

    subtotal += appointment.groomer.price;

    return subtotal;
  }

  double get total {
    return subtotal - discount;
  }

  @override
  Widget build(BuildContext context) {
    return PaymentSummaryContainer(
      title: 'Order Summary',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    appointment.pet.imagePath,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (_, __, ___) {
                      return Container(
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        color: const Color(0xFFF1F8EF),
                        child: const Icon(
                          Icons.pets_rounded,
                          size: 44,
                          color: Color(0xFF15952A),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.service.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF172038),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            size: 16,
                            color: Color(0xFF15952A),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${appointment.date.year}-${appointment.date.month}-${appointment.date.day}  ${appointment.time}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF4F5970),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Color(0xFF15952A),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              appointment.shop.name,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF4F5970),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 96,
            child: Column(
              children: [
                PaymentSummaryPriceRow(
                  title: 'Subtotal',
                  value: '\$${subtotal.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 2),
                PaymentSummaryPriceRow(
                  title: 'Discount',
                  value: '- \$${discount.toStringAsFixed(2)}',
                  valueColor: const Color(0xFF15952A),
                ),
                const SizedBox(height: 6),
                const Divider(height: 1, color: Color(0xFFE6EAE6)),
                const SizedBox(height: 6),
                PaymentSummaryPriceRow(
                  title: 'Total',
                  value: '\$${total.toStringAsFixed(2)}',
                  bold: true,
                  valueColor: const Color(0xFF15952A),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentSummaryContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const PaymentSummaryContainer({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6EAE6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF172038),
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class PaymentSummaryPriceRow extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final bool bold;

  const PaymentSummaryPriceRow({
    super.key,
    required this.title,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: bold ? 12 : 10,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: const Color(0xFF374055),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 14 : 10,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor ?? const Color(0xFF172038),
          ),
        ),
      ],
    );
  }
}

class ProductPaymentItem {
  final String name;
  final String image;
  final int quantity;
  final double price;

  const ProductPaymentItem({
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
  });

  double get total => price * quantity;
}

class ProductPaymentSummary extends StatelessWidget {
  static const Color primary = Color(0xFF15952A);
  static const Color textPrimary = Color(0xFF172038);
  static const Color textSecondary = Color(0xFF667087);
  static const Color border = Color(0xFFE6EAE6);

  final AddressData address;
  final List<ProductPaymentItem> items;
  final double subtotal;
  final double shippingFee;
  final double discount;
  final double freeShippingThreshold;

  const ProductPaymentSummary({
    super.key,
    required this.address,
    required this.items,
    required this.subtotal,
    this.shippingFee = 0,
    this.discount = 0,
    this.freeShippingThreshold = 100,
  });

  double get total {
    final result = subtotal + shippingFee - discount;
    return result < 0 ? 0 : result;
  }

  int get totalQuantity {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get remainingForFreeShipping {
    final remaining = freeShippingThreshold - subtotal;

    return remaining > 0 ? remaining : 0;
  }

  double get shippingProgress {
    if (freeShippingThreshold <= 0) {
      return 1;
    }

    return (subtotal / freeShippingThreshold).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDeliveryAddress(),
          const SizedBox(height: 8),
          const Divider(height: 1, color: border),
          const SizedBox(height: 8),
          _buildTitle(),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 11, child: _buildProductList()),
              const SizedBox(width: 10),
              Expanded(flex: 9, child: _buildPriceSummary()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Address',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_on_outlined, size: 20, color: primary),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          address.contact,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                      ),

                      if (address.isDefault == 1) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF8EC),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Default',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 4),
                  Text(
                    address.mobile,
                    style: const TextStyle(fontSize: 10, color: textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    address.details,
                    style: const TextStyle(
                      fontSize: 10,
                      height: 1.35,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${address.city}, ${address.province} ${address.postcode}',
                    style: const TextStyle(
                      fontSize: 10,
                      height: 1.35,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '($totalQuantity ${totalQuantity == 1 ? 'item' : 'items'})',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildProductList() {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];

        return Column(
          children: [
            _buildProductItem(item),

            if (index != items.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, color: border),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildProductItem(ProductPaymentItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 44,
          height: 66,
          child: Center(
            child: Image.network(
              item.image,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }

                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 44,
                  height: 66,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F8F3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: primary,
                    size: 32,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  height: 1.25,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Qty: ${item.quantity}',
                style: const TextStyle(fontSize: 8, color: textSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                '\$${item.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSummary() {
    return Column(
      children: [
        _priceRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
        const SizedBox(height: 12),
        _priceRow('Shipping Fee', '\$${shippingFee.toStringAsFixed(2)}'),
        const SizedBox(height: 12),
        _priceRow(
          'Discount',
          '- \$${discount.toStringAsFixed(2)}',
          valueColor: primary,
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, color: border),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text(
              'Total',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              '($totalQuantity ${totalQuantity == 1 ? 'item' : 'items'})',
              style: const TextStyle(fontSize: 10, color: textSecondary),
            ),
            const Spacer(),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildFreeShippingCard(),
      ],
    );
  }

  Widget _priceRow(String title, String value, {Color? valueColor}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: valueColor ?? textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildFreeShippingCard() {
    final achieved = remainingForFreeShipping <= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FBF4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE1EFE0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_shipping_rounded,
                size: 24,
                color: primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: achieved
                    ? const Text(
                        'You qualify for free shipping!',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: primary,
                        ),
                      )
                    : RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 10,
                            height: 1.45,
                            color: textSecondary,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  "You're \$${remainingForFreeShipping.toStringAsFixed(2)} away\n",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: primary,
                              ),
                            ),
                            const TextSpan(text: 'from free shipping!'),
                          ],
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: shippingProgress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFDDE9E0),
                    valueColor: const AlwaysStoppedAnimation<Color>(primary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '\$${freeShippingThreshold.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TopUpPaymentSummary extends StatelessWidget {
  final double amount;
  final double bonus;

  const TopUpPaymentSummary({super.key, required this.amount, this.bonus = 0});

  static const Color _green = Color(0xFF14952B);
  static const Color _dark = Color(0xFF151B35);
  static const Color _border = Color(0xFFE7EAE7);

  double get walletCredit => amount + bonus;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top-up Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _dark,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 14, child: _buildAmountInfo()),
              const SizedBox(width: 4),
              Expanded(flex: 10, child: _buildPriceInfo()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Wallet illustration
        Container(
          width: 48,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFF1FAF1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.account_balance_wallet_rounded,
                size: 36,
                color: Color(0xFF42C96A),
              ),
              Positioned(
                right: 10,
                bottom: 12,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 8, color: _green),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Top-up Amount',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _dark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'NZD ${_money(amount)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _dark,
                ),
              ),

              if (bonus > 0) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF8EC),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'You will get NZD ${_money(bonus)} bonus',
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: _green,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceInfo() {
    return Column(
      children: [
        _priceRow(title: 'Top-up Amount', value: '\$${_money(amount)}'),

        if (bonus > 0) ...[
          const SizedBox(height: 8),
          _priceRow(
            title: 'Bonus',
            value: '+\$${_money(bonus)}',
            titleColor: _green,
            valueColor: _green,
          ),
        ],

        const SizedBox(height: 12),
        const Divider(height: 1, color: _border),
        const SizedBox(height: 12),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Total Payable',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _dark,
                ),
              ),
            ),
            Text(
              '\$${_money(amount)}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _priceRow({
    required String title,
    required String value,
    Color? titleColor,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: titleColor ?? _dark,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: valueColor ?? _dark,
          ),
        ),
      ],
    );
  }

  static String _money(double value) {
    final parts = value.toStringAsFixed(2).split('.');

    final integer = parts[0];

    final formatted = integer.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );

    return '$formatted.${parts[1]}';
  }
}
