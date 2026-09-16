// lib/component/payment/result-summary.dart
import 'package:flutter/material.dart';

import '../../view-models/payment.dart';
import '../../view-models/payment-result.dart';

import 'summary.dart';

class ProductPaymentResultSummary extends StatelessWidget {
  const ProductPaymentResultSummary({
    super.key,
    required this.items,
    required this.shippingFee,
    required this.discount,
    required this.orderNumber,
    required this.orderDate,
    required this.estimatedDelivery,
  });

  final List<ProductPaymentItem> items;
  final double shippingFee;
  final double discount;
  final String orderNumber;
  final String orderDate;
  final String estimatedDelivery;

  static const Color primary = Color(0xFF15952A);
  static const Color textPrimary = Color(0xFF172038);
  static const Color textSecondary = Color(0xFF667087);
  static const Color border = Color(0xFFE6EAE6);

  double get subtotal {
    return items.fold(0, (sum, item) => sum + item.total);
  }

  double get total {
    final result = subtotal + shippingFee - discount;
    return result < 0 ? 0 : result;
  }

  int get totalQuantity {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildOrderSummary(),
        const SizedBox(height: 16),
        _buildOrderInfo(),
      ],
    );
  }

  Widget _buildOrderSummary() {
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
          Row(
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
                style: const TextStyle(fontSize: 12, color: textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(items.length, (index) {
            final item = items[index];

            return Column(
              children: [
                _PaymentProductRow(item: item),

                if (index != items.length - 1)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: border),
                  ),
              ],
            );
          }),
          const SizedBox(height: 14),
          const Divider(height: 1, color: border),
          const SizedBox(height: 14),
          _priceRow('Subtotal', subtotal),
          const SizedBox(height: 10),
          _priceRow('Shipping Fee', shippingFee),
          const SizedBox(height: 10),
          _priceRow('Discount', discount, isDiscount: true),
          const SizedBox(height: 14),
          const Divider(height: 1, color: border),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total Paid',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double value, {bool isDiscount = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDiscount ? primary : textPrimary,
            ),
          ),
        ),
        Text(
          isDiscount
              ? '- \$${value.toStringAsFixed(2)}'
              : '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDiscount ? primary : textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderInfo() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          _OrderInfoRow(
            icon: Icons.receipt_long_outlined,
            title: 'Order Number',
            value: orderNumber,
          ),
          const Divider(height: 1, indent: 18, endIndent: 18, color: border),
          _OrderInfoRow(
            icon: Icons.calendar_month_outlined,
            title: 'Order Date',
            value: orderDate,
          ),
          const Divider(height: 1, indent: 18, endIndent: 18, color: border),
          _OrderInfoRow(
            icon: Icons.local_shipping_outlined,
            title: 'Estimated Delivery',
            value: estimatedDelivery,
          ),
        ],
      ),
    );
  }
}

class _PaymentProductRow extends StatelessWidget {
  const _PaymentProductRow({required this.item});

  final ProductPaymentItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          height: 72,
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
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F8F3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 36,
                  color: Color(0xFF15952A),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.25,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF172038),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Qty: ${item.quantity}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF667087)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '\$${item.total.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF172038),
          ),
        ),
      ],
    );
  }
}

class _OrderInfoRow extends StatelessWidget {
  const _OrderInfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 24, color: const Color(0xFF15952A)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF172038),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF667087),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: 24,
            color: Color(0xFF4F5970),
          ),
        ],
      ),
    );
  }
}

class AppointmentPaymentResultSummary extends StatelessWidget {
  const AppointmentPaymentResultSummary({
    super.key,
    required this.imagePath,
    required this.appointmentName,
    required this.date,
    required this.time,
    required this.store,
    required this.petName,
    required this.petBreed,
    required this.groomer,
    required this.serviceName,
    required this.servicePrice,
    required this.addOns,
    this.discount = 0,
  });

  final String imagePath;
  final String appointmentName;
  final String date;
  final String time;
  final String store;
  final String petName;
  final String petBreed;
  final String groomer;
  final String serviceName;
  final double servicePrice;
  final List<AppointmentAddOn> addOns;
  final double discount;

  static const Color primary = Color(0xFF15952A);
  static const Color textPrimary = Color(0xFF172038);
  static const Color textSecondary = Color(0xFF667087);
  static const Color border = Color(0xFFE6EAE6);

  double get addOnTotal {
    return addOns.fold(0, (sum, item) => sum + item.price);
  }

  double get total {
    final value = servicePrice + addOnTotal - discount;
    return value < 0 ? 0 : value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppointmentCard(),
        const SizedBox(height: 12),
        const _ResultMessageCard(
          icon: Icons.notifications_none_rounded,
          title: 'Appointment Reminders',
          line1: "We've sent a confirmation to your email and app inbox.",
          line2: 'You will receive a reminder before your appointment.',
        ),
        const SizedBox(height: 12),
        const _ResultMessageCard(
          icon: Icons.storefront_outlined,
          title: "What's Next?",
          line1: 'We look forward to seeing you!',
          line2: 'Please arrive 10 minutes early.',
        ),
      ],
    );
  }

  Widget _buildAppointmentCard() {
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
          const Text(
            'Appointment Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _buildAppointmentHeader(),
          const SizedBox(height: 12),
          const Divider(height: 1, color: border),
          _buildInfoRow(
            label: 'Pet',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.pets_outlined, size: 16, color: textSecondary),
                const SizedBox(width: 4),
                Text('$petName ($petBreed)', style: _valueStyle),
              ],
            ),
          ),
          const Divider(height: 1, color: border),
          _buildInfoRow(
            label: 'Groomer',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  size: 16,
                  color: textSecondary,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    groomer,
                    textAlign: TextAlign.right,
                    style: _valueStyle,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: border),
          _buildPriceRow(
            label: 'Service',
            icon: Icons.content_cut_rounded,
            name: serviceName,
            price: servicePrice,
          ),
          const Divider(height: 1, color: border),
          _buildAddOns(),
          const Divider(height: 1, color: border),
          _buildDiscount(),
          const Divider(height: 1, color: border),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total Paid',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ),
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
        ],
      ),
    );
  }

  Widget _buildAppointmentHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: SizedBox(
            width: 72,
            height: 72,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  color: const Color(0xFFF3F8F3),
                  child: const Icon(
                    Icons.pets_rounded,
                    size: 36,
                    color: primary,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointmentName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _IconText(icon: Icons.calendar_month_outlined, text: date),
                  _IconText(icon: Icons.access_time_rounded, text: time),
                ],
              ),
              const SizedBox(height: 8),
              _IconText(icon: Icons.location_on_outlined, text: store),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Align(alignment: Alignment.centerRight, child: child),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required IconData icon,
    required String name,
    required double price,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 156,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
          ),
          Icon(icon, size: 16, color: textSecondary),
          const SizedBox(width: 4),
          Expanded(
            child: Text(name, textAlign: TextAlign.right, style: _valueStyle),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text(
              '\$${price.toStringAsFixed(2)}',
              textAlign: TextAlign.right,
              style: _valueStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddOns() {
    if (addOns.isEmpty) {
      return _buildInfoRow(
        label: 'Add-on',
        child: const Text(
          'None',
          style: TextStyle(fontSize: 12, color: textSecondary),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 156,
            child: Text(
              'Add-on',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: List.generate(addOns.length, (index) {
                final item = addOns[index];

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == addOns.length - 1 ? 0 : 10,
                  ),
                  child: Row(
                    children: [
                      if (index == 0)
                        const Icon(
                          Icons.add_circle_outline_rounded,
                          size: 16,
                          color: textSecondary,
                        )
                      else
                        const SizedBox(width: 12),

                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.name,
                          textAlign: TextAlign.right,
                          style: _valueStyle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 60,
                        child: Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          textAlign: TextAlign.right,
                          style: _valueStyle,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscount() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Discount',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: primary,
              ),
            ),
          ),
          Text(
            '- \$${discount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }

  static const TextStyle _valueStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );
}

class _IconText extends StatelessWidget {
  const _IconText({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF15952A)),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4E5870),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultMessageCard extends StatelessWidget {
  const _ResultMessageCard({
    required this.icon,
    required this.title,
    required this.line1,
    required this.line2,
  });

  final IconData icon;
  final String title;
  final String line1;
  final String line2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE6EAE6)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F9F0),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: const Color(0xFF15952A)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172038),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  line1,
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.4,
                    color: Color(0xFF4E5870),
                  ),
                ),
                Text(
                  line2,
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.4,
                    color: Color(0xFF667087),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TopUpResultAmountCard extends StatelessWidget {
  const TopUpResultAmountCard({
    super.key,
    required this.topUpAmount,
    required this.bonus,
    required this.newWalletBalance,
  });

  final double topUpAmount;
  final double bonus;
  final double newWalletBalance;

  static const Color primary = Color(0xFF15952A);
  static const Color textPrimary = Color(0xFF172038);
  static const Color textSecondary = Color(0xFF667087);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCF8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0EEE0)),
      ),
      child: Column(
        children: [
          const Text(
            'Amount Added',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'NZD ${_money(topUpAmount)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: primary,
            ),
          ),

          if (bonus > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F7E8),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                '+ Bonus NZD ${_money(bonus)}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: primary,
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),
          const SizedBox(
            width: 330,
            child: Divider(height: 1, color: Color(0xFFE0E7E1)),
          ),
          const SizedBox(height: 12),
          const Text(
            'New Wallet Balance',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                size: 20,
                color: primary,
              ),
              const SizedBox(width: 4),
              Text(
                'NZD ${_money(newWalletBalance)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _money(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    final integer = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );

    return '$integer.${parts[1]}';
  }
}

class TopUpPaymentResultSummary extends StatelessWidget {
  const TopUpPaymentResultSummary({
    super.key,
    required this.topUpAmount,
    required this.bonus,
    required this.newWalletBalance,
    required this.paymentMethod,
    required this.transactionId,
    required this.dateTime,
    this.onViewTransactionHistory,
  });

  final double topUpAmount;
  final double bonus;
  final double newWalletBalance;
  final PaymentMethodType paymentMethod;
  final String transactionId;
  final String dateTime;
  final VoidCallback? onViewTransactionHistory;

  static const Color primary = Color(0xFF15952A);
  static const Color textPrimary = Color(0xFF172038);
  static const Color textSecondary = Color(0xFF667087);
  static const Color border = Color(0xFFE6EAE6);

  double get totalAdded => topUpAmount + bonus;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPaymentDetailsCard(),
        const SizedBox(height: 12),
        _buildTopUpSummaryCard(),
        const SizedBox(height: 12),
        _buildThankYouCard(),

        if (onViewTransactionHistory != null) ...[
          const SizedBox(height: 12),
          _buildTransactionHistoryButton(),
        ],
      ],
    );
  }

  Widget _buildPaymentDetailsCard() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _detailRow(
            label: 'Payment Method',
            valueWidget: _PaymentMethodDisplay(paymentMethod: paymentMethod),
          ),
          const SizedBox(height: 8),
          _detailRow(
            label: 'Transaction ID',
            valueWidget: Text(
              transactionId,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _detailRow(
            label: 'Date & Time',
            valueWidget: Text(
              dateTime,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopUpSummaryCard() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top-up Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _summaryRow(
            label: 'Top-up Amount',
            value: 'NZD ${_money(topUpAmount)}',
          ),

          if (bonus > 0) ...[
            const SizedBox(height: 12),
            _summaryRow(
              label: 'Bonus',
              value: '+ NZD ${_money(bonus)}',
              labelColor: primary,
              valueColor: primary,
            ),
          ],

          const SizedBox(height: 12),
          const Divider(height: 1, color: border),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total Added',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
              ),
              Text(
                'NZD ${_money(totalAdded)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThankYouCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCF6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2EFE0)),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9EF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.card_giftcard_rounded,
                  size: 44,
                  color: Color(0xFF42B95C),
                ),
                Positioned(
                  right: 0,
                  bottom: 2,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFB52E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thank you for topping up!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'You can now use your wallet balance for shopping, pet services and more.',
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.45,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHistoryButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onViewTransactionHistory,
        icon: const Icon(Icons.history_rounded, size: 20, color: primary),
        label: const Text(
          'View Transaction History',
          style: TextStyle(color: primary),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: Color(0xFF8BCB94), width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _detailRow({required String label, required Widget valueWidget}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 108,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textPrimary,
            ),
          ),
        ),
        Flexible(
          child: Align(alignment: Alignment.centerRight, child: valueWidget),
        ),
      ],
    );
  }

  Widget _summaryRow({
    required String label,
    required String value,
    Color? labelColor,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: labelColor ?? textPrimary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: valueColor ?? textPrimary,
          ),
        ),
      ],
    );
  }

  static String _money(double value) {
    final parts = value.toStringAsFixed(2).split('.');

    final integerPart = parts[0];

    final formattedInteger = integerPart.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );

    return '$formattedInteger.${parts[1]}';
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6EAE6)),
      ),
      child: child,
    );
  }
}

class _PaymentMethodDisplay extends StatelessWidget {
  const _PaymentMethodDisplay({required this.paymentMethod});

  final PaymentMethodType paymentMethod;

  String _getPaymentMethod() {
    switch (paymentMethod) {
      case PaymentMethodType.online:
        return 'Online Payment';
      case PaymentMethodType.wallet:
        return 'Wallet Balance';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (paymentMethod == PaymentMethodType.online) const _VisaLogo(),

        const SizedBox(width: 6),
        Flexible(
          child: Text(
            _getPaymentMethod(),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF172038),
            ),
          ),
        ),
      ],
    );
  }
}

class _VisaLogo extends StatelessWidget {
  const _VisaLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFF0F1F3)),
      ),
      child: const Text(
        'VISA',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          color: Color(0xFF1739A1),
        ),
      ),
    );
  }
}
