// lib/page/shop/payment-result.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../component/payment/summary.dart';
import '../../component/payment/result-summary.dart';

import '../../view-models/cart.dart';
import '../../view-models/payment.dart';
import '../../view-models/payment-result.dart';

class PaymentResultPage extends ConsumerStatefulWidget {
  final double amount;
  final int bonus;
  final PaymentMethodType paymentMethod;
  final PaymentSummaryType type;
  final VoidCallback? onBottomPressed;

  const PaymentResultPage({
    super.key,
    required this.amount,
    required this.bonus,
    required this.paymentMethod,
    required this.type,
    this.onBottomPressed,
  });

  @override
  ConsumerState<PaymentResultPage> createState() => _PaymentResultPageState();
}

class _PaymentResultPageState extends ConsumerState<PaymentResultPage> {
  static const Color primary = Color(0xFF15952A);
  static const Color textPrimary = Color(0xFF172038);
  static const Color textSecondary = Color(0xFF667087);
  static const Color background = Color(0xFFFCFDFB);

  String title = 'Payment Successful!';
  String subtitle = 'Thank you! Your payment has been completed.';
  String bottomButtonText = 'Continue Shopping';

  @override
  void initState() {
    super.initState();

    switch (widget.type) {
      case PaymentSummaryType.appointment:
        setState(() {
          title = 'Payment Successful!';
          subtitle = 'Your appointment has been confirmed.';
          bottomButtonText = 'View My Appointments';
        });
      case PaymentSummaryType.shopping:
        setState(() {
          title = 'Payment Successful!';
          subtitle = 'Thank you! Your payment has been completed.';
          bottomButtonText = 'Continue Shopping';
        });
      case PaymentSummaryType.topup:
        setState(() {
          title = 'Top-up Successful!';
          subtitle = 'Your balance has been updated.';
          bottomButtonText = 'Back to Wallet';
        });
    }
  }

  Widget get _getPaymentInfoCard {
    if (widget.type == PaymentSummaryType.topup) {
      return TopUpResultAmountCard(
        topUpAmount: widget.amount,
        bonus: widget.bonus.toDouble(),
        newWalletBalance: widget.amount + widget.bonus.toDouble(),
      );
    }

    return _buildPaymentInfoCard();
  }

  Widget _getSummaryWidget() {
    switch (widget.type) {
      case PaymentSummaryType.appointment:
        final addOns = [
          const AppointmentAddOn(name: 'Nail Trim', price: 15.00),
          const AppointmentAddOn(name: 'Teeth Brushing', price: 15.00),
        ];

        return AppointmentPaymentResultSummary(
          imagePath: '',
          appointmentName: 'Basic Grooming',
          date: 'May 16, 2024 (Thu)',
          time: '2:00 PM',
          store: 'YiPet Greenlane Store',
          petName: 'Coco',
          petBreed: 'Poodle',
          groomer: 'Jessie (Senior Groomer)',
          serviceName: 'Basic Grooming',
          servicePrice: 80.00,
          addOns: addOns,
          discount: 0.00,
        );
      case PaymentSummaryType.shopping:
        final cartItems = ref.watch(cartProvider);
        final products = cartItems.map((item) {
          return ProductPaymentItem(
            name: item.product.name,
            image: item.product.imagePath,
            quantity: item.quantity,
            price: item.unitPrice,
          );
        }).toList();
        final discount = 0.0;

        return ProductPaymentResultSummary(
          items: products,
          shippingFee: 4.90,
          discount: discount,
          orderNumber: 'YP2024051601530',
          orderDate: 'May 16, 2024 2:30 PM',
          estimatedDelivery: 'May 20 - May 22, 2024',
        );
      case PaymentSummaryType.topup:
        return TopUpPaymentResultSummary(
          topUpAmount: widget.amount,
          bonus: widget.bonus.toDouble(),
          newWalletBalance: widget.amount + widget.bonus.toDouble(),
          paymentMethod: PaymentMethodType.online,
          transactionId: 'TP20240516153045',
          dateTime: 'May 16, 2024 3:30 PM',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  18,
                  0,
                  18,
                  MediaQuery.paddingOf(context).bottom + 24,
                ),
                child: Column(
                  children: [
                    _buildTopArea(context),
                    const SizedBox(height: 16),
                    _getPaymentInfoCard,
                    const SizedBox(height: 16),
                    _getSummaryWidget(),
                  ],
                ),
              ),
            ),
            _buildBottomButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopArea(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            const _SuccessIcon(),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FCF7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1EEE0)),
      ),
      child: Column(
        children: [
          const Text(
            'Amount Paid',
            style: TextStyle(fontSize: 12, color: textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${widget.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: primary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Payment Method',
            style: TextStyle(fontSize: 12, color: textSecondary),
          ),
          const SizedBox(height: 6),
          _PaymentMethodDisplay(paymentMethod: widget.paymentMethod),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: background,
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed:
                widget.onBottomPressed ??
                () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              bottomButtonText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  const _SuccessIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 125,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned(
            left: 16,
            top: 25,
            child: _ConfettiDot(color: Color(0xFFFFB51C), size: 10),
          ),
          const Positioned(
            left: 38,
            top: 63,
            child: _ConfettiDot(color: Color(0xFF15952A), size: 7),
          ),
          Positioned(
            left: 60,
            top: 18,
            child: Transform.rotate(
              angle: 0.6,
              child: SizedBox(
                width: 8,
                height: 18,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFF15952A),
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            left: 70,
            top: 83,
            child: _ConfettiDot(color: Color(0xFFFFB51C), size: 7),
          ),
          const Positioned(
            right: 18,
            top: 38,
            child: _ConfettiDot(color: Color(0xFFFFB51C), size: 8),
          ),
          const Positioned(
            right: 54,
            top: 18,
            child: _ConfettiDot(color: Color(0xFF15952A), size: 7),
          ),
          Positioned(
            right: 66,
            top: 75,
            child: Transform.rotate(
              angle: 0.6,
              child: SizedBox(
                width: 8,
                height: 18,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFF15952A),
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 106,
            height: 106,
            decoration: const BoxDecoration(
              color: Color(0xFF17AE43),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x22159B33),
                  blurRadius: 22,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 64,
              weight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfettiDot extends StatelessWidget {
  const _ConfettiDot({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (paymentMethod == PaymentMethodType.online)
          const _OnlinePaymentLogo(),

        if (paymentMethod == PaymentMethodType.wallet)
          const Icon(
            Icons.account_balance_wallet_outlined,
            size: 28,
            color: Color(0xFF15952A),
          ),

        const SizedBox(width: 8),
        Text(
          _getPaymentMethod(),
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

class _OnlinePaymentLogo extends StatelessWidget {
  const _OnlinePaymentLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFBFCFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF0F1F2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Image.asset(
          'assets/images/payment/online-payment.png',
          width: 56,
          height: 34,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
