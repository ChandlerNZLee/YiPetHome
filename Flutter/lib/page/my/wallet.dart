// lib/page/my/wallet.dart
import 'package:flutter/material.dart';

import 'wallet/top-up.dart';
import 'wallet/transaction-history.dart';

import '../../view-models/wallet.dart';

class WalletPage extends StatefulWidget {
  final double balance;

  const WalletPage({super.key, required this.balance});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  static const Color primary = Color(0xFF16A52F);
  static const Color textPrimary = Color(0xFF17191D);
  static const Color background = Color(0xFFFCFDFB);

  late double _balance;

  final List<WalletTransactionData> _transactions = const [
    WalletTransactionData(
      title: 'Payment for Appointment',
      subtitle: 'Luxury Spa Wash',
      amount: -95,
      date: 'May 16, 2024',
      time: '2:05 PM',
      type: WalletTransactionType.payment,
    ),
    WalletTransactionData(
      title: 'Wallet Top Up',
      subtitle: 'From Credit Card **** 4242',
      amount: 100,
      date: 'May 10, 2024',
      time: '9:30 AM',
      type: WalletTransactionType.topUp,
    ),
    WalletTransactionData(
      title: 'Online Shopping',
      subtitle: 'Pet Supplies Order',
      amount: -15,
      date: 'May 10, 2024',
      time: '9:30 AM',
      type: WalletTransactionType.shopping,
    ),
    WalletTransactionData(
      title: 'Payment for Add-ons',
      subtitle: 'Teeth Brushing, Nail Grinding',
      amount: -25,
      date: 'May 5, 2024',
      time: '3:15 PM',
      type: WalletTransactionType.payment,
    ),
    WalletTransactionData(
      title: 'Wallet Top Up',
      subtitle: 'From PayPal',
      amount: 50,
      date: 'Apr 28, 2024',
      time: '11:20 AM',
      type: WalletTransactionType.topUp,
    ),
  ];

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  void _goToTopUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TopUpPage()),
    );
  }

  void _goToTransactionHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TransactionHistoryPage()),
    );
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _balance = widget.balance;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width * 0.035;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                6,
                horizontalPadding,
                0,
              ),
              child: WalletHeader(onBackTap: _goBack),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  MediaQuery.paddingOf(context).bottom + 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WalletBalanceHeroCard(balance: _balance),
                    const SizedBox(height: 16),
                    WalletQuickActions(
                      onTopUp: _goToTopUp,
                      onTransactionHistory: _goToTransactionHistory,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Recent Transactions',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _goToTransactionHistory,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Text(
                                  'View All',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: primary,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 24,
                                  color: primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    WalletTransactionsCard(
                      transactions: _transactions,
                      onTap: (transaction) {
                        _showMessage(transaction.title);
                      },
                    ),
                    const SizedBox(height: 16),
                    WalletSettingsCard(
                      onAutoTopUp: () {
                        _showMessage('Auto Top Up');
                      },
                      onHelp: () {
                        _showMessage('Help & FAQ');
                      },
                      onSettings: () {
                        _showMessage('Wallet Settings');
                      },
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
}

class WalletHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const WalletHeader({super.key, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Center(
            child: Text(
              'Wallet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF172038),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onBackTap,
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 24,
                    color: Color(0xFF111820),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WalletBalanceHeroCard extends StatelessWidget {
  final double balance;

  const WalletBalanceHeroCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF4FAF2), Color(0xFFF8FCF6)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCFE8CC)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 6,
            child: WalletIllustration(width: 240, height: 160),
          ),
          Positioned(
            left: 0,
            top: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Balance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A5571),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '\$${balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 32,
                    height: 1,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF078C1D),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F8EE),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFDCEED8)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 16,
                        color: Color(0xFF078C1D),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'YiPet Wallet',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF078C1D),
                        ),
                      ),
                    ],
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

class WalletIllustration extends StatelessWidget {
  final double width;
  final double height;

  const WalletIllustration({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 20,
            top: 32,
            child: Transform.rotate(
              angle: 0.15,
              child: Container(
                width: 88,
                height: 110,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF53BB3F), Color(0xFF218B2A)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 136,
              height: 112,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8FD878), Color(0xFF3FAD3A)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF2C8728), width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x16000000),
                    blurRadius: 20,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.pets_rounded,
                      size: 56,
                      color: Color(0xFFEAF8E5),
                    ),
                  ),
                  Positioned(
                    right: -8,
                    top: 40,
                    child: Container(
                      width: 44,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFF419E31),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF287C28),
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFD34D),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(left: 92, bottom: 0, child: _Coin(size: 40)),
          const Positioned(left: 66, top: 44, child: _Coin(size: 32)),
          const Positioned(right: 0, top: 0, child: _Coin(size: 36)),
          const Positioned(
            left: 100,
            top: 16,
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 24,
              color: Color(0xFF65BB54),
            ),
          ),
          const Positioned(
            right: 0,
            top: 28,
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 20,
              color: Color(0xFF65BB54),
            ),
          ),
        ],
      ),
    );
  }
}

class _Coin extends StatelessWidget {
  final double size;

  const _Coin({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE672), Color(0xFFF3AA10)],
        ),
        border: Border.all(color: const Color(0xFFF2A30A), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.pets_rounded,
        size: size * 0.52,
        color: const Color(0xFFE99300),
      ),
    );
  }
}

class WalletQuickActions extends StatelessWidget {
  final VoidCallback onTopUp;
  final VoidCallback onTransactionHistory;

  const WalletQuickActions({
    super.key,
    required this.onTopUp,
    required this.onTransactionHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8ECE8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: WalletQuickActionItem(
              icon: Icons.add_rounded,
              label: 'Top Up',
              onTap: onTopUp,
            ),
          ),
          const _QuickDivider(),
          Expanded(
            child: WalletQuickActionItem(
              icon: Icons.schedule_rounded,
              label: 'Transaction History',
              onTap: onTransactionHistory,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickDivider extends StatelessWidget {
  const _QuickDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 72, color: const Color(0xFFE9ECE9));
  }
}

class WalletQuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const WalletQuickActionItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFEDF8EE),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: const Color(0xFF16A52F)),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF35415E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WalletBalanceCard extends StatelessWidget {
  final double balance;
  final VoidCallback onTap;

  const WalletBalanceCard({
    super.key,
    required this.balance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF6FAF4),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFDCEBD9)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.card_giftcard_rounded,
                size: 28,
                color: Color(0xFF16A52F),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wallet Balance',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF17191D),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Total amount available to use',
                      style: TextStyle(fontSize: 10, color: Color(0xFF52617D)),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${balance.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF078C1D),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: Color(0xFF078C1D),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WalletTransactionsCard extends StatelessWidget {
  final List<WalletTransactionData> transactions;
  final ValueChanged<WalletTransactionData> onTap;

  const WalletTransactionsCard({
    super.key,
    required this.transactions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6EAE6)),
      ),
      child: Column(
        children: List.generate(transactions.length, (index) {
          final item = transactions[index];

          return Column(
            children: [
              WalletTransactionRow(data: item, onTap: () => onTap(item)),
              if (index != transactions.length - 1)
                const Divider(height: 1, color: Color(0xFFE8ECE8)),
            ],
          );
        }),
      ),
    );
  }
}

class WalletTransactionRow extends StatelessWidget {
  final WalletTransactionData data;
  final VoidCallback onTap;

  const WalletTransactionRow({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final positive = data.amount > 0;

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              WalletTransactionIcon(type: data.type),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF17191D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF52617D),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${positive ? '+' : '-'}\$${data.amount.abs().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: positive
                          ? const Color(0xFF0F9A29)
                          : const Color(0xFF172038),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        data.date,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF52617D),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        data.time,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF52617D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WalletTransactionIcon extends StatelessWidget {
  final WalletTransactionType type;

  const WalletTransactionIcon({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    late IconData icon;

    switch (type) {
      case WalletTransactionType.topUp:
        icon = Icons.add_rounded;
        break;
      case WalletTransactionType.payment:
      case WalletTransactionType.shopping:
        icon = Icons.shopping_bag_outlined;
        break;
    }

    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFEDF8EE),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 24, color: const Color(0xFF16A52F)),
    );
  }
}

class WalletSettingsCard extends StatelessWidget {
  final VoidCallback onAutoTopUp;
  final VoidCallback onHelp;
  final VoidCallback onSettings;

  const WalletSettingsCard({
    super.key,
    required this.onAutoTopUp,
    required this.onHelp,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      WalletMenuData(
        icon: Icons.shield_outlined,
        title: 'Auto Top Up',
        subtitle: 'Keep your balance topped up automatically',
        onTap: onAutoTopUp,
      ),
      WalletMenuData(
        icon: Icons.help_outline_rounded,
        title: 'Help & FAQ',
        subtitle: 'Learn more about YiPet Wallet',
        onTap: onHelp,
      ),
      WalletMenuData(
        icon: Icons.settings_outlined,
        title: 'Settings',
        subtitle: 'Manage your wallet settings',
        onTap: onSettings,
      ),
    ];

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6EAE6)),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];

          return Column(
            children: [
              WalletMenuRow(data: item),
              if (index != items.length - 1)
                const Divider(height: 1, color: Color(0xFFE8ECE8)),
            ],
          );
        }),
      ),
    );
  }
}

class WalletMenuRow extends StatelessWidget {
  final WalletMenuData data;

  const WalletMenuRow({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: data.onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFEDF8EE),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  data.icon,
                  size: 24,
                  color: const Color(0xFF16A52F),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF17191D),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.subtitle,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF52617D),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: Color(0xFF34405B),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
