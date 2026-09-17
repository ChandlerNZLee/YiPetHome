// lib/page/my/wallet/top-up.dart
import 'package:flutter/material.dart';

import '../../../services/user-service.dart';
import '../../../core/network/api-exception.dart';

import '../../shop/payment.dart';

import '../../../view-models/top-up.dart';
import '../../../view-models/payment.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final TextEditingController _customAmountController = TextEditingController();

  late TopUpData _selectedBonus;
  List<TopUpData> _bonuses = [];
  final TopUpData customBonus = TopUpData(
    id: 0,
    type: TopUpBonusType.custom,
    amount: 0,
    bonus: 0,
  );

  bool _processing = false;

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _selectBonus(TopUpData bonus) {
    setState(() {
      _selectedBonus = bonus;

      if (bonus.type != TopUpBonusType.custom) {
        _customAmountController.clear();
      }
    });
  }

  double? get _selectedAmount {
    switch (_selectedBonus.type) {
      case TopUpBonusType.amount500:
        return 500;
      case TopUpBonusType.amount1000:
        return 1000;
      case TopUpBonusType.amount3000:
        return 3000;
      case TopUpBonusType.custom:
        return double.tryParse(_customAmountController.text.trim());
    }
  }

  Future<void> _proceedToPayment() async {
    final amount = _selectedAmount;

    if (amount == null) {
      _showError('Please enter a top up amount.');
      return;
    }

    if (amount < 10) {
      _showError('Minimum top up amount is \$10.');
      return;
    }

    setState(() {
      _processing = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      _processing = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentPage(
          type: PaymentSummaryType.topup,
          bonus: _selectedBonus,
          amount: amount,
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();

    _getBonusList();
  }

  Future<void> _getBonusList() async {
    try {
      final res = await UserService.instance.getBonusList();
      final list = res.bonuses
          .map((item) => TopUpData.fromModel(item))
          .toList();

      setState(() {
        _bonuses = list;
        _selectedBonus = list[0];
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
    final showCustomInput = _selectedBonus.type == TopUpBonusType.custom;

    return Scaffold(
      backgroundColor: TopUpColor.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  18,
                  0,
                  18,
                  MediaQuery.paddingOf(context).bottom + 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Select Top Up Amount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: TopUpColor.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._bonuses.map((bonus) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TopUpAmountCard(
                          data: bonus,
                          selected: _selectedBonus.type == bonus.type,
                          onTap: () {
                            _selectBonus(bonus);
                          },
                        ),
                      );
                    }),
                    CustomTopUpCard(
                      selected: _selectedBonus.type == TopUpBonusType.custom,
                      onTap: () {
                        _selectBonus(customBonus);
                      },
                    ),

                    if (showCustomInput) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Custom Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: TopUpColor.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildCustomAmountInput(),
                      const SizedBox(height: 4),
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          'Minimum top up amount is \$10',
                          style: TextStyle(
                            fontSize: 12,
                            color: TopUpColor.textSecondary,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    const BonusInfoCard(),
                    const SizedBox(height: 16),
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: TopUpColor.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const PaymentMethodCard(),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _processing ? null : _proceedToPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TopUpColor.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFF8BC894),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.lock_outline_rounded, size: 24),
                                  SizedBox(width: 8),
                                  Text(
                                    'Proceed to Payment',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
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
                  color: TopUpColor.textPrimary,
                ),
              ),
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Top Up',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: TopUpColor.textPrimary,
                ),
              ),
              Text(
                'Add balance to your wallet',
                style: TextStyle(fontSize: 10, color: TopUpColor.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAmountInput() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TopUpColor.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              border: Border(right: BorderSide(color: TopUpColor.border)),
            ),
            child: const Text(
              '\$',
              style: TextStyle(fontSize: 16, color: TopUpColor.textPrimary),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _customAmountController,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              cursorColor: TopUpColor.primary,
              onChanged: (_) {
                setState(() {});
              },
              style: const TextStyle(
                fontSize: 12,
                color: TopUpColor.textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: 'Enter amount',
                hintStyle: TextStyle(fontSize: 12, color: Color(0xFF9BA2B1)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopUpAmountCard extends StatelessWidget {
  const TopUpAmountCard({
    super.key,
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final TopUpData data;
  final bool selected;
  final VoidCallback onTap;

  static const Color primary = Color(0xFF15952A);
  static const Color textPrimary = Color(0xFF172038);
  static const Color textSecondary = Color(0xFF667087);

  @override
  Widget build(BuildContext context) {
    final total = data.amount + data.bonus;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 96,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF8FCF7) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFF4CAF61)
                  : const Color(0xFFE7E9ED),
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    _RadioCircle(selected: selected),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatAmount(data.amount),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Get ${_formatAmount(data.bonus)} bonus',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 180,
                      child: Row(
                        children: [
                          Expanded(
                            child: _AmountSummary(
                              title: 'You pay',
                              value: '\$${data.amount.toStringAsFixed(2)}',
                              valueColor: textPrimary,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 28,
                            color: const Color(0xFFE5E7EA),
                          ),
                          Expanded(
                            child: _AmountSummary(
                              title: 'You get',
                              value: '\$${total.toStringAsFixed(2)}',
                              valueColor: primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (data.badge != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: _TopUpBadge(text: data.badge!, type: data.badgeType!),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatAmount(int value) {
    if (value == value.roundToDouble()) {
      return '\$${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
    }

    return '\$${value.toStringAsFixed(2)}';
  }
}

class CustomTopUpCard extends StatelessWidget {
  const CustomTopUpCard({
    super.key,
    required this.selected,
    required this.onTap,
  });

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 96,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF8FCF7) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFF4CAF61)
                  : const Color(0xFFE7E9ED),
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              _RadioCircle(selected: selected),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Amount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF172038),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Enter any amount to top up',
                      style: TextStyle(fontSize: 12, color: Color(0xFF667087)),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F8EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 44,
                      color: Color(0xFF7CCD8A),
                    ),
                    Positioned(
                      left: 6,
                      bottom: 12,
                      child: Text(
                        '\$',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.95),
                        ),
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
}

class _RadioCircle extends StatelessWidget {
  const _RadioCircle({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 2,
          color: selected ? const Color(0xFF15952A) : const Color(0xFFB8BFCA),
        ),
      ),
      child: selected
          ? Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF15952A),
              ),
            )
          : null,
    );
  }
}

class _AmountSummary extends StatelessWidget {
  const _AmountSummary({
    required this.title,
    required this.value,
    required this.valueColor,
  });

  final String title;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 10, color: Color(0xFF667087)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _TopUpBadge extends StatelessWidget {
  const _TopUpBadge({required this.text, required this.type});

  final String text;
  final TopUpBadgeType type;

  @override
  Widget build(BuildContext context) {
    final colors = switch (type) {
      TopUpBadgeType.green => const [Color(0xFF15952A), Color(0xFF35A94C)],
      TopUpBadgeType.purple => const [Color(0xFF9A60FF), Color(0xFFB986FF)],
      TopUpBadgeType.orange => const [Color(0xFFFF9657), Color(0xFFFFB17D)],
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class BonusInfoCard extends StatelessWidget {
  const BonusInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FBF5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6F1E4)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF7E8),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.card_giftcard_rounded,
              size: 32,
              color: Color(0xFF54B966),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enjoy instant bonus!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF172038),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'The bonus will be added to your wallet instantly after successful payment.',
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.45,
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

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 76,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6EAE6)),
          ),
          child: Row(
            children: [
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
                        color: TopUpColor.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Pay securely online',
                      style: const TextStyle(
                        fontSize: 12,
                        color: TopUpColor.textSecondary,
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
}
