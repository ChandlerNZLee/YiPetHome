// lib/pages/my/settings/privacy.dart
import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key, this.onPrivacyPolicyTap, this.onTermsTap});

  final VoidCallback? onPrivacyPolicyTap;
  final VoidCallback? onTermsTap;

  static const Color primary = Color(0xFF15952A);
  static const Color textPrimary = Color(0xFF172038);
  static const Color textSecondary = Color(0xFF5C6782);
  static const Color background = Color(0xFFFCFDFB);
  static const Color border = Color(0xFFE6EAE6);

  void _goBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width * 0.045;

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
              child: PrivacyHeader(onBackTap: () => _goBack(context)),
            ),
            const SizedBox(height: 28),
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
                  children: [
                    const PrivacyHeroCard(),
                    const SizedBox(height: 28),
                    PrivacyMenuCard(
                      onPrivacyPolicyTap:
                          onPrivacyPolicyTap ??
                          () {
                            _showMessage(context, 'Privacy Policy');
                          },
                      onTermsTap:
                          onTermsTap ??
                          () {
                            _showMessage(context, 'Terms of Service');
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

class PrivacyHeader extends StatelessWidget {
  const PrivacyHeader({super.key, required this.onBackTap});

  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Center(
            child: Text(
              'Privacy',
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

class PrivacyHeroCard extends StatelessWidget {
  const PrivacyHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBF6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDEBDD)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F8EF),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD9EED7)),
              ),
              child: const Icon(
                Icons.shield_outlined,
                size: 44,
                color: Color(0xFF15952A),
              ),
            ),
          ),
          const Positioned(
            left: 84,
            top: 0,
            bottom: 0,
            right: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Privacy Matters',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF172038),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'We are committed to protecting your personal information and your privacy.',
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.55,
                    color: Color(0xFF5C6782),
                  ),
                ),
              ],
            ),
          ),
          Positioned(right: 0, top: 0, child: _PrivacyLockIllustration()),
        ],
      ),
    );
  }
}

class _PrivacyLockIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 0,
            bottom: 8,
            child: Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                color: Color(0x0C15952A),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: Container(
              width: 72,
              height: 88,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF55BF57), Color(0xFF15952A)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.lock_rounded,
                size: 36,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 32,
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF4FBF2),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF9ED99E), width: 2),
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 24,
                color: Color(0xFF62B75D),
              ),
            ),
          ),
          const Positioned(
            left: 6,
            bottom: 24,
            child: Icon(
              Icons.energy_savings_leaf_outlined,
              size: 44,
              color: Color(0x239ACF95),
            ),
          ),
        ],
      ),
    );
  }
}

class PrivacyMenuCard extends StatelessWidget {
  const PrivacyMenuCard({
    super.key,
    required this.onPrivacyPolicyTap,
    required this.onTermsTap,
  });

  final VoidCallback onPrivacyPolicyTap;
  final VoidCallback onTermsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
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
      child: Column(
        children: [
          PrivacyMenuRow(
            icon: Icons.description_outlined,
            title: 'Privacy Policy',
            subtitle:
                'Learn how we collect, use, and\n'
                'protect your data.',
            onTap: onPrivacyPolicyTap,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: Divider(height: 1, color: Color(0xFFE9ECE9)),
          ),
          PrivacyMenuRow(
            icon: Icons.verified_user_outlined,
            title: 'Terms of Service',
            subtitle:
                'Read our terms and conditions\n'
                'for using YiPet.',
            onTap: onTermsTap,
          ),
        ],
      ),
    );
  }
}

class PrivacyMenuRow extends StatelessWidget {
  const PrivacyMenuRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

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
                width: 66,
                height: 66,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8EF),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE1F0DF)),
                ),
                child: Icon(icon, size: 37, color: const Color(0xFF15952A)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF172038),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        color: Color(0xFF5C6782),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: Color(0xFF26314E),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
