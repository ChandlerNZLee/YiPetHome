// lib/page/my/help-support.dart
import 'package:flutter/material.dart';

import '../../view-models/help-support.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  static const Color textPrimary = Color(0xFF17191D);
  static const Color background = Color(0xFFFCFDFB);

  final TextEditingController _searchController = TextEditingController();

  final List<HelpTopicData> _topics = const [
    HelpTopicData(
      title: 'Orders & Payments',
      subtitle: 'Payment, refunds, invoices',
      icon: Icons.credit_card_outlined,
    ),
    HelpTopicData(
      title: 'Appointments',
      subtitle: 'Booking, reschedule, cancel',
      icon: Icons.calendar_month_outlined,
    ),
    HelpTopicData(
      title: 'Products & Shopping',
      subtitle: 'Products, delivery, returns',
      icon: Icons.shopping_bag_outlined,
    ),
    HelpTopicData(
      title: 'Account & Profile',
      subtitle: 'Personal info, password, profile',
      icon: Icons.person_outline_rounded,
    ),
    HelpTopicData(
      title: 'Membership & Wallet',
      subtitle: 'Membership, wallet, points',
      icon: Icons.account_balance_wallet_outlined,
    ),
    HelpTopicData(
      title: 'Pet Care & Services',
      subtitle: 'Services, grooming, health',
      icon: Icons.pets_outlined,
    ),
  ];

  final List<HelpCenterData> _helpCenterItems = const [
    HelpCenterData(
      title: 'FAQs',
      subtitle: 'Find answers to common questions',
      icon: Icons.article_outlined,
    ),
    HelpCenterData(
      title: 'Shipping & Delivery',
      subtitle: 'Learn about shipping times and delivery',
      icon: Icons.article_outlined,
    ),
    HelpCenterData(
      title: 'Returns & Refunds',
      subtitle: 'Return policy and refund information',
      icon: Icons.article_outlined,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  void _search() {
    final keyword = _searchController.text.trim();

    if (keyword.isEmpty) return;

    _showMessage('Search: $keyword');
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
                8,
                horizontalPadding,
                0,
              ),
              child: HelpSupportHeader(onBackTap: _goBack),
            ),
            const SizedBox(height: 12),
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
                    SupportHeroCard(
                      onContactTap: () {
                        _showMessage('Contact Us');
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Popular Topics',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    HelpTopicsGrid(
                      items: _topics,
                      onTap: (item) {
                        _showMessage(item.title);
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Find Answers',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    HelpSearchField(
                      controller: _searchController,
                      onSubmitted: (_) => _search(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Support Options',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SupportOptionsCard(
                      onLiveChat: () {
                        _showMessage('Live Chat');
                      },
                      onEmail: () {
                        _showMessage('Email Us');
                      },
                      onCall: () {
                        _showMessage('Call Us');
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Help Center',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    HelpCenterCard(
                      items: _helpCenterItems,
                      onTap: (item) {
                        _showMessage(item.title);
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

class HelpSupportHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const HelpSupportHeader({super.key, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Center(
            child: Text(
              'Help & Support',
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

class SupportHeroCard extends StatelessWidget {
  final VoidCallback onContactTap;

  const SupportHeroCard({super.key, required this.onContactTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FBF5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDCEED9)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 8,
            child: SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hi Jasper! How can\nwe help you?',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF172038),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'We’re here to help you and your pet\n'
                    'have the best experience.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: Color(0xFF52617D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: onContactTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B9B22),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 16,
                      ),
                      label: const Text(
                        'Contact Us',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                children: [
                  Positioned(
                    left: 52,
                    top: 40,
                    child: Image.asset(
                      'assets/images/my/help-support/support_dog.png',
                      width: 160,
                      height: 160,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          width: 160,
                          height: 160,
                          alignment: Alignment.bottomCenter,
                          child: const Icon(
                            Icons.pets_rounded,
                            size: 120,
                            color: Color(0xFFB4DCA9),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: 120,
                    child: Container(
                      width: 60,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC3EEC8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _Dot(),
                          SizedBox(width: 6),
                          _Dot(),
                          SizedBox(width: 6),
                          _Dot(),
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
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class HelpTopicsGrid extends StatelessWidget {
  final List<HelpTopicData> items;
  final ValueChanged<HelpTopicData> onTap;

  const HelpTopicsGrid({super.key, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final itemWidth = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: 12,
          children: items.map((item) {
            return SizedBox(
              width: itemWidth,
              child: HelpTopicCard(data: item, onTap: () => onTap(item)),
            );
          }).toList(),
        );
      },
    );
  }
}

class HelpTopicCard extends StatelessWidget {
  final HelpTopicData data;
  final VoidCallback onTap;

  const HelpTopicCard({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 66,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6EAE6)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x05000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(data.icon, size: 24, color: const Color(0xFF16A52F)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF172038),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 8,
                        color: Color(0xFF52617D),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: Color(0xFF35415E),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HelpSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;

  const HelpSearchField({
    super.key,
    required this.controller,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextField(
        controller: controller,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        cursorColor: const Color(0xFF16A52F),
        style: const TextStyle(fontSize: 12, color: Color(0xFF172038)),
        decoration: InputDecoration(
          hintText: 'Search for help articles...',
          hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF7D879D)),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 24,
            color: Color(0xFF65728E),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE3E8E3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE3E8E3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF16A52F), width: 1.4),
          ),
        ),
      ),
    );
  }
}

class SupportOptionsCard extends StatelessWidget {
  final VoidCallback onLiveChat;
  final VoidCallback onEmail;
  final VoidCallback onCall;

  const SupportOptionsCard({
    super.key,
    required this.onLiveChat,
    required this.onEmail,
    required this.onCall,
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
        children: [
          SupportOptionRow(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Live Chat',
            subtitle: 'Chat with our support team',
            trailing: const _StatusBadge(text: 'Online'),
            onTap: onLiveChat,
          ),
          const Divider(height: 1, color: Color(0xFFE8ECE8)),
          SupportOptionRow(
            icon: Icons.mail_outline_rounded,
            title: 'Email Us',
            subtitle: 'support@yipet.com',
            trailing: const Text(
              'We usually reply within 24h',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF16A52F),
              ),
            ),
            onTap: onEmail,
          ),
          const Divider(height: 1, color: Color(0xFFE8ECE8)),
          SupportOptionRow(
            icon: Icons.phone_outlined,
            title: 'Call Us',
            subtitle: '+64 9 123 4567',
            trailing: const Text(
              'Mon – Fri 9:00 AM – 6:00 PM',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF16A52F),
              ),
            ),
            onTap: onCall,
          ),
        ],
      ),
    );
  }
}

class SupportOptionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  const SupportOptionRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                decoration: const BoxDecoration(
                  color: Color(0xFFEDF8EE),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: const Color(0xFF16A52F)),
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
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF172038),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF52617D),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Flexible(child: trailing),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: Color(0xFF35415E),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;

  const _StatusBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFEDF8EE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF16A52F),
            ),
          ),
        ),
      ],
    );
  }
}

class HelpCenterCard extends StatelessWidget {
  final List<HelpCenterData> items;
  final ValueChanged<HelpCenterData> onTap;

  const HelpCenterCard({super.key, required this.items, required this.onTap});

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
        children: List.generate(items.length, (index) {
          final item = items[index];

          return Column(
            children: [
              HelpCenterRow(data: item, onTap: () => onTap(item)),

              if (index != items.length - 1)
                const Divider(height: 1, color: Color(0xFFE8ECE8)),
            ],
          );
        }),
      ),
    );
  }
}

class HelpCenterRow extends StatelessWidget {
  final HelpCenterData data;
  final VoidCallback onTap;

  const HelpCenterRow({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
                        color: Color(0xFF172038),
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
                color: Color(0xFF35415E),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
