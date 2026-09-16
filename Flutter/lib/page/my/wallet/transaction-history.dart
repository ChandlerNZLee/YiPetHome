// lib/page/my/wallet/transaction-history.dart
import 'package:flutter/material.dart';

import '../../../view-models/transaction-history.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  static const Color textPrimary = Color(0xFF172038);
  static const Color background = Color(0xFFFCFDFB);

  TransactionFilter _selectedFilter = TransactionFilter.all;

  final List<TransactionData> _transactions = const [
    TransactionData(
      id: 'pet_supplies',
      title: 'Pet Supplies',
      subtitle: 'Pet food and snacks',
      amount: -45.60,
      date: 'May 18, 2025',
      time: '2:30 PM',
      type: TransactionType.expense,
      iconType: TransactionIconType.shopping,
    ),
    TransactionData(
      id: 'top_up',
      title: 'Top Up',
      subtitle: 'Wallet top up',
      amount: 100.00,
      date: 'May 16, 2025',
      time: '10:20 AM',
      type: TransactionType.income,
      iconType: TransactionIconType.topUp,
    ),
    TransactionData(
      id: 'grooming',
      title: 'Grooming Appointment',
      subtitle: 'Full grooming service',
      amount: -60.00,
      date: 'May 12, 2025',
      time: '4:15 PM',
      type: TransactionType.expense,
      iconType: TransactionIconType.appointment,
    ),
    TransactionData(
      id: 'referral_reward',
      title: 'Referral Reward',
      subtitle: 'Invite a friend',
      amount: 20.00,
      date: 'May 8, 2025',
      time: '6:30 PM',
      type: TransactionType.income,
      iconType: TransactionIconType.reward,
    ),
    TransactionData(
      id: 'medication',
      title: 'Pet Medication',
      subtitle: 'Flea & tick treatment',
      amount: -18.20,
      date: 'May 5, 2025',
      time: '11:05 AM',
      type: TransactionType.expense,
      iconType: TransactionIconType.medication,
    ),
  ];

  List<TransactionData> get _filteredTransactions {
    switch (_selectedFilter) {
      case TransactionFilter.all:
        return _transactions;
      case TransactionFilter.income:
        return _transactions
            .where((item) => item.type == TransactionType.income)
            .toList();
      case TransactionFilter.expense:
        return _transactions
            .where((item) => item.type == TransactionType.expense)
            .toList();
    }
  }

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  void _openTransaction(TransactionData transaction) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(transaction.title),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 20.0;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                horizontalPadding,
                8,
                horizontalPadding,
                0,
              ),
              child: TransactionHistoryHeader(onBackTap: _goBack),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  MediaQuery.paddingOf(context).bottom + 26,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TotalBalanceCard(balance: 128.60),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Summary',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                        ),
                        TransactionTypeFilter(
                          value: _selectedFilter,
                          onChanged: (value) {
                            setState(() {
                              _selectedFilter = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const TransactionSummaryRow(),
                    const SizedBox(height: 16),
                    const Text(
                      'May 2025',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TransactionListCard(
                      transactions: _filteredTransactions,
                      onTap: _openTransaction,
                    ),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        'No more transactions',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF8A91A2),
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
}

class TransactionHistoryHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const TransactionHistoryHeader({super.key, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Center(
            child: Text(
              'Transaction History',
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

class TotalBalanceCard extends StatelessWidget {
  final double balance;

  const TotalBalanceCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6EAE6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Balance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5C6782),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '\$${balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 28,
                    height: 1,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF11172E),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F9EF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              size: 36,
              color: Color(0xFF15952A),
            ),
          ),
        ],
      ),
    );
  }
}

enum TransactionFilter { all, income, expense }

class TransactionTypeFilter extends StatelessWidget {
  final TransactionFilter value;
  final ValueChanged<TransactionFilter> onChanged;

  const TransactionTypeFilter({
    super.key,
    required this.value,
    required this.onChanged,
  });

  String _label(TransactionFilter filter) {
    switch (filter) {
      case TransactionFilter.all:
        return 'All Types';
      case TransactionFilter.income:
        return 'Income';
      case TransactionFilter.expense:
        return 'Expense';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TransactionFilter>(
      initialValue: value,
      onSelected: onChanged,
      offset: const Offset(0, 46),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (_) {
        return TransactionFilter.values.map((item) {
          return PopupMenuItem<TransactionFilter>(
            value: item,
            child: Text(_label(item)),
          );
        }).toList();
      },
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E9E5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _label(value),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF15952A),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 24,
              color: Color(0xFF15952A),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionSummaryRow extends StatelessWidget {
  const TransactionSummaryRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: TransactionSummaryCard(
            icon: Icons.arrow_downward_rounded,
            title: 'Income',
            value: '\$256.80',
            iconColor: Color(0xFF15952A),
            backgroundColor: Color(0xFFEDF8EE),
            valueColor: Color(0xFF15952A),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: TransactionSummaryCard(
            icon: Icons.arrow_upward_rounded,
            title: 'Expense',
            value: '\$128.20',
            iconColor: Color(0xFFE73544),
            backgroundColor: Color(0xFFFFECEF),
            valueColor: Color(0xFFE73544),
          ),
        ),
      ],
    );
  }
}

class TransactionSummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;
  final Color backgroundColor;
  final Color valueColor;

  const TransactionSummaryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
    required this.backgroundColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6EAE6)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5C6782),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: valueColor,
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

class TransactionListCard extends StatelessWidget {
  final List<TransactionData> transactions;
  final ValueChanged<TransactionData> onTap;

  const TransactionListCard({
    super.key,
    required this.transactions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 44),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6EAE6)),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 44,
              color: Color(0xFFABB2C0),
            ),
            SizedBox(height: 12),
            Text(
              'No transactions',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5C6782),
              ),
            ),
          ],
        ),
      );
    }

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
              TransactionRow(data: item, onTap: () => onTap(item)),

              if (index != transactions.length - 1)
                const Padding(
                  padding: EdgeInsets.only(left: 24, right: 24),
                  child: Divider(height: 1, color: Color(0xFFE9ECE9)),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class TransactionRow extends StatelessWidget {
  final TransactionData data;
  final VoidCallback onTap;

  const TransactionRow({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final style = TransactionVisualStyle.fromIconType(data.iconType);
    final positive = data.amount > 0;

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: style.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(style.icon, size: 24, color: style.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF172038),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.subtitle,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF5C6782),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${positive ? '+' : '-'} \$${data.amount.abs().toStringAsFixed(2)}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: positive
                            ? const Color(0xFF15952A)
                            : const Color(0xFF11172E),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          data.date,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF5C6782),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          data.time,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF5C6782),
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
      ),
    );
  }
}
