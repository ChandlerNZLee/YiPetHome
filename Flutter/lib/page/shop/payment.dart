// lib/page/shop/payment.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/user-service.dart';
import '../../services/shop-service.dart';
import '../../services/appointment-service.dart';
import '../../core/network/api-exception.dart';

import '../../component/payment/summary.dart';

import 'payment-result.dart';

import '../../view-models/payment.dart';
import '../../view-models/appointment.dart';
import '../../view-models/cart.dart';
import '../../view-models/address.dart';
import '../../../view-models/top-up.dart';

class PaymentPage extends ConsumerStatefulWidget {
  final PaymentSummaryType type;
  final PaymentAppointmentData? appointment;
  final AddressData? address;
  final TopUpData? bonus;
  final double amount;

  const PaymentPage({
    super.key,
    required this.type,
    this.appointment,
    this.address,
    this.bonus,
    required this.amount,
  });

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  static const Color primary = Color(0xFF15952A);
  static const Color textPrimary = Color(0xFF172038);
  static const Color textSecondary = Color(0xFF667087);
  static const Color background = Color(0xFFFCFDFB);
  static const Color border = Color(0xFFE6EAE6);

  PaymentMethodType _selectedPaymentMethod = PaymentMethodType.online;

  bool _processing = false;

  double _walletBalance = 0;

  Widget _getSummaryWidget(
    List<CartItem> cartItems,
    double subtotal,
    double shippingFee,
  ) {
    switch (widget.type) {
      case PaymentSummaryType.appointment:
        return AppointmentPaymentSummary(appointment: widget.appointment!);
      case PaymentSummaryType.shopping:
        final paymentItems = cartItems.map((item) {
          return ProductPaymentItem(
            name: item.product.name,
            image: item.product.imagePath,
            quantity: item.quantity,
            price: item.unitPrice,
          );
        }).toList();
        final discount = 0.0;

        return ProductPaymentSummary(
          address: widget.address!,
          items: paymentItems,
          subtotal: subtotal,
          shippingFee: shippingFee,
          discount: discount,
          freeShippingThreshold: 100.00,
        );
      case PaymentSummaryType.topup:
        return TopUpPaymentSummary(
          amount: widget.bonus!.amount.toDouble(),
          bonus: widget.bonus!.bonus.toDouble(),
        );
    }
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _selectPaymentMethod(PaymentMethodType type) {
    setState(() {
      _selectedPaymentMethod = type;
    });
  }

  bool get _walletBalanceEnough {
    return _walletBalance >= widget.amount;
  }

  Future<void> _pay() async {
    if (_selectedPaymentMethod == PaymentMethodType.wallet &&
        !_walletBalanceEnough) {
      _showMessage('Insufficient wallet balance.');
      return;
    }

    setState(() {
      _processing = true;
    });

    if (widget.type == PaymentSummaryType.shopping) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('user_id');

        final cartItems = ref.watch(cartProvider);
        final products = cartItems.map((item) {
          return {
            'productId': item.product.id,
            'stockId': item.stock.id,
            'quantity': item.quantity,
            'price': item.unitPrice,
          };
        }).toList();

        final order = {
          'userId': userId,
          'addressId': widget.address!.id,
          'products': products,
        };
        final res = await ShopService.instance.createShopOrder(order);

        _checkPayment(res.order.id);
      } on ApiException catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      } catch (e) {
        if (mounted) {
          setState(() {
            _processing = false;
          });

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    } else if (widget.type == PaymentSummaryType.topup) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('user_id');

        final order = {'userId': userId, 'bonusId': widget.bonus!.id};
        final res = await ShopService.instance.createRechargeOrder(order);

        _checkPayment(res.order.id);
      } on ApiException catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      } catch (e) {
        if (mounted) {
          setState(() {
            _processing = false;
          });

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    } else if (widget.type == PaymentSummaryType.appointment) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('user_id');

        var ids = [widget.appointment!.service.priceId];
        if (widget.appointment!.styling != null) {
          ids.add(widget.appointment!.styling!.priceId);
        }
        if (widget.appointment!.spa != null) {
          ids.add(widget.appointment!.spa!.priceId);
        }

        final appointment = {
          'userId': userId,
          'petId': widget.appointment!.pet.id,
          'shopId': widget.appointment!.shop.id,
          'groomerId': widget.appointment!.groomer.id,
          'servicePriceIds': ids,
          'startAt': widget.appointment!.slot.startAt.toString(),
          'notes': widget.appointment!.notes,
        };
        final res = await AppointmentService.instance.createAppointment(
          appointment,
        );

        _checkPayment(res.appointment.id);
      } on ApiException catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      } catch (e) {
        if (mounted) {
          setState(() {
            _processing = false;
          });

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    } else {
      try {
        if (!mounted) return;

        final result = PaymentResult(
          amount: widget.amount,
          paymentMethod: _selectedPaymentMethod,
          success: true,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentResultPage(
              amount: result.amount,
              bonus: 0,
              paymentMethod: result.paymentMethod,
              type: widget.type,
            ),
          ),
        );
      } on ApiException catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      } catch (e) {
        if (mounted) {
          setState(() {
            _processing = false;
          });

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    }
  }

  Future<void> _checkPayment(int orderId) async {
    var amount = 0.00;
    if (widget.type == PaymentSummaryType.shopping) {
      final subtotal = ref.watch(cartSubtotalProvider);
      final shippingFee = subtotal >= 100 ? 0.0 : 4.90;
      amount = widget.type == PaymentSummaryType.shopping
          ? (subtotal >= 100 ? subtotal : subtotal + shippingFee)
          : widget.amount;
    } else {
      amount = widget.amount;
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('order_amount', amount);
    prefs.setInt('payment_type', widget.type.index);

    if (widget.type == PaymentSummaryType.topup) {
      prefs.setInt('bonus', widget.bonus!.bonus);
    }

    var orderType = 0;
    if (widget.type == PaymentSummaryType.shopping) {
      orderType = 0;
    } else if (widget.type == PaymentSummaryType.topup) {
      orderType = 1;
    } else if (widget.type == PaymentSummaryType.appointment) {
      orderType = 2;
    }

    try {
      final res = await ShopService.instance.checkPayment(orderId, orderType);
      openStripeCheckout(res.payment.checkoutUrl);
    } on ApiException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (mounted) {
        setState(() {
          _processing = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> openStripeCheckout(String checkoutUrl) async {
    final uri = Uri.parse(checkoutUrl);
    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!success) {
      throw Exception('Could not open Stripe Checkout');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  @override
  void initState() {
    super.initState();

    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      final res = await UserService.instance.getUserData();

      setState(() {
        _walletBalance = res.user.balance;
      });
    } on ApiException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final shippingFee = subtotal >= 100 ? 0.0 : 4.90;
    final amount = widget.type == PaymentSummaryType.shopping
        ? (subtotal >= 100 ? subtotal : subtotal + shippingFee)
        : widget.amount;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getSummaryWidget(cartItems, subtotal, shippingFee),
                    const SizedBox(height: 16),
                    const Text(
                      'Payment Methods',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildOnlinePaymentMethod(),
                    ),

                    if (widget.type != PaymentSummaryType.topup) ...[
                      const SizedBox(height: 8),
                      _buildWalletPaymentMethod(amount),
                    ],
                    const SizedBox(height: 16),
                    const PaymentSecurityCard(),
                  ],
                ),
              ),
            ),
            _buildBottomButton(amount),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SizedBox(
        height: 72,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: _goBack,
                borderRadius: BorderRadius.circular(24),
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 24,
                    color: textPrimary,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Payment',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                const Text(
                  'Choose your payment method',
                  style: TextStyle(fontSize: 10, color: textSecondary),
                ),
              ],
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: Column(
                children: [
                  SizedBox(height: 36),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_rounded, size: 12, color: primary),
                      SizedBox(width: 2),
                      Text(
                        'Secure Checkout',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: primary,
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
    );
  }

  Widget _buildOnlinePaymentMethod() {
    final selected = _selectedPaymentMethod == PaymentMethodType.online;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          _selectPaymentMethod(PaymentMethodType.online);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF7FCF7) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? const Color(0xFF55B565) : border,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              PaymentRadio(selected: selected),
              const SizedBox(width: 8),
              OnlinePaymentLogo(),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Online Payment',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Pay securely online',
                      style: const TextStyle(
                        fontSize: 12,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletPaymentMethod(double amount) {
    final selected = _selectedPaymentMethod == PaymentMethodType.wallet;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          if (!_walletBalanceEnough) {
            _showMessage('Insufficient wallet balance.');
            return;
          }

          _selectPaymentMethod(PaymentMethodType.wallet);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF7FCF7) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? const Color(0xFF55B565) : border,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                size: 28,
                color: primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Wallet Balance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Available Balance: \$${_walletBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '-\$${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: _walletBalanceEnough
                      ? primary
                      : const Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(width: 8),
              PaymentRadio(selected: selected, enabled: _walletBalanceEnough),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(double amount) {
    return SafeArea(
      top: false,
      child: Container(
        color: background,
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _processing ? null : _pay,
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFF8BC894),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            child: _processing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_outline_rounded, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Pay \$${amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class PaymentRadio extends StatelessWidget {
  final bool selected;
  final bool enabled;

  const PaymentRadio({super.key, required this.selected, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final color = !enabled
        ? const Color(0xFFD4D8DE)
        : selected
        ? const Color(0xFF15952A)
        : const Color(0xFFC7CCD5);

    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: selected ? 2 : 1.5),
      ),
      child: selected && enabled
          ? Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF15952A),
              ),
            )
          : null,
    );
  }
}

class OnlinePaymentLogo extends StatelessWidget {
  const OnlinePaymentLogo({super.key});

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

class PaymentSecurityCard extends StatelessWidget {
  const PaymentSecurityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FBF5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3EFE1)),
      ),
      child: const Row(
        children: [
          Icon(Icons.shield_rounded, size: 32, color: Color(0xFF27AD49)),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Safe & Secure Payment',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF172038),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Your payment information is encrypted and secure.',
                  style: TextStyle(fontSize: 10, color: Color(0xFF667087)),
                ),
              ],
            ),
          ),
          Icon(
            Icons.account_balance_wallet_rounded,
            size: 44,
            color: Color(0xFF71C982),
          ),
        ],
      ),
    );
  }
}
