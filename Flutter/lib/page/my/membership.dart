// lib/page/my/membership.dart
import 'package:flutter/material.dart';

import '../../view-models/membership.dart';

class MembershipPage extends StatelessWidget {
  const MembershipPage({super.key});

  static const Color primary = Color(0xFF22C55E);
  static const Color textPrimary = Color(0xFF17191D);
  static const Color textSecondary = Color(0xFF747982);
  static const Color border = Color(0xFFECEFEC);
  static const Color background = Color(0xFFFCFDFB);

  void _goBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final horizontalPadding = width * 0.055;

    const benefits = [
      MembershipBenefitData(
        title: 'Free Shipping',
        subtitle: 'Unlimited free shipping',
        icon: Icons.local_shipping_outlined,
      ),
      MembershipBenefitData(
        title: 'VIP Support',
        subtitle: 'Priority customer support',
        icon: Icons.headset_mic_outlined,
      ),
      MembershipBenefitData(
        title: 'Exclusive Discounts',
        subtitle: 'Special offers and discounts',
        icon: Icons.local_offer_outlined,
      ),
      MembershipBenefitData(
        title: 'Health Reports',
        subtitle: 'Advanced health reports',
        icon: Icons.description_outlined,
      ),
    ];

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                12,
                horizontalPadding,
                0,
              ),
              child: MembershipHeader(onBackTap: () => _goBack(context)),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  media.padding.bottom + 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MembershipCard(),
                    const SizedBox(height: 32),
                    const Text(
                      'Exclusive Benefits',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    MembershipBenefitsList(benefits: benefits),
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

class MembershipHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const MembershipHeader({super.key, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Center(
            child: Text(
              'Membership',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: MembershipColors.textPrimary,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onBackTap,
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 24,
                    color: MembershipColors.textPrimary,
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

class MembershipCard extends StatelessWidget {
  const MembershipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF4CAF2E), Color(0xFF16B84E)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1622C55E),
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -25,
            top: 22,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 32,
            top: 32,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                size: 60,
                color: Color(0xFFFFD85A),
              ),
            ),
          ),
          Positioned(
            left: 28,
            top: 38,
            right: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YiPet Plus',
                  style: TextStyle(
                    fontSize: 32,
                    height: 1,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFFDD7A),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Member',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFFD85A),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Since May 2024',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.90),
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

class MembershipBenefitsList extends StatelessWidget {
  final List<MembershipBenefitData> benefits;

  const MembershipBenefitsList({super.key, required this.benefits});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(benefits.length, (index) {
        final item = benefits[index];

        return Column(
          children: [
            MembershipBenefitTile(data: item),

            if (index != benefits.length - 1)
              const Divider(
                height: 1,
                indent: 78,
                color: MembershipColors.border,
              ),
          ],
        );
      }),
    );
  }
}

class MembershipBenefitTile extends StatelessWidget {
  final MembershipBenefitData data;

  const MembershipBenefitTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F8ED),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(data.icon, size: 36, color: MembershipColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: MembershipColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: MembershipColors.textSecondary,
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
