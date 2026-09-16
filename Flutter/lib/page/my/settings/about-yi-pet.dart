// lib/page/my/settings/about-yi-pet.dart
import 'package:flutter/material.dart';

class AboutYiPetPage extends StatelessWidget {
  const AboutYiPetPage({
    super.key,
    this.onContactTap,
    this.onWebsiteTap,
    this.onFollowTap,
  });

  final VoidCallback? onContactTap;
  final VoidCallback? onWebsiteTap;
  final VoidCallback? onFollowTap;

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
              child: AboutYiPetHeader(onBackTap: () => _goBack(context)),
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
                  children: [
                    const YiPetBrandSection(),
                    const SizedBox(height: 16),
                    const AboutInformationCard(),
                    const SizedBox(height: 16),
                    AboutContactCard(
                      onContactTap:
                          onContactTap ??
                          () {
                            _showMessage(context, 'Contact Us');
                          },
                      onWebsiteTap:
                          onWebsiteTap ??
                          () {
                            _showMessage(context, 'www.yipet.com');
                          },
                      onFollowTap:
                          onFollowTap ??
                          () {
                            _showMessage(context, '@yipet_official');
                          },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '© 2026 YiPet. All rights reserved.',
                      style: TextStyle(fontSize: 10, color: Color(0xFF7A8192)),
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

class AboutYiPetHeader extends StatelessWidget {
  const AboutYiPetHeader({super.key, required this.onBackTap});

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
              'About YiPet',
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

class YiPetBrandSection extends StatelessWidget {
  const YiPetBrandSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        SizedBox(
          width: 120,
          height: 120,
          child: Image.asset(
            'assets/images/my/about/yipet-logo.png',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) {
              return Container(
                width: 120,
                height: 120,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEDF8EE),
                ),
                child: const Icon(
                  Icons.pets_rounded,
                  size: 72,
                  color: Color(0xFF15952A),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'YiPet',
          style: TextStyle(
            fontSize: 48,
            height: 1,
            fontWeight: FontWeight.w700,
            color: Color(0xFF15952A),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Better care, happier pets.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5C6782),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F8EE),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD8ECD6)),
          ),
          child: const Text(
            'Version 1.2.3',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF258735),
            ),
          ),
        ),
      ],
    );
  }
}

class AboutInformationCard extends StatelessWidget {
  const AboutInformationCard({super.key});

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
      child: const Column(
        children: [
          AboutInfoRow(
            icon: Icons.favorite_border_rounded,
            title: 'Our Mission',
            description:
                'YiPet is dedicated to helping pet parents\n'
                'provide the best care for their furry family\n'
                'members.',
          ),
          AboutDivider(),
          AboutInfoRow(
            icon: Icons.pets_rounded,
            title: 'What We Do',
            description:
                'From health records and reminders to\n'
                'appointments and premium products,\n'
                'YiPet is your all-in-one pet care companion.',
          ),
          AboutDivider(),
          AboutInfoRow(
            icon: Icons.verified_user_rounded,
            title: 'Your Privacy',
            description:
                'We value your trust. Your data and your pet’s\n'
                'information are always safe with us.',
          ),
        ],
      ),
    );
  }
}

class AboutInfoRow extends StatelessWidget {
  const AboutInfoRow({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
            child: Icon(icon, size: 36, color: const Color(0xFF15952A)),
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
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF172038),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: Color(0xFF5C6782),
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

class AboutDivider extends StatelessWidget {
  const AboutDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 28, right: 28),
      child: Divider(height: 1, color: Color(0xFFE9ECE9)),
    );
  }
}

class AboutContactCard extends StatelessWidget {
  const AboutContactCard({
    super.key,
    required this.onContactTap,
    required this.onWebsiteTap,
    required this.onFollowTap,
  });

  final VoidCallback onContactTap;
  final VoidCallback onWebsiteTap;
  final VoidCallback onFollowTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6EAE6)),
      ),
      child: Column(
        children: [
          AboutContactRow(
            icon: Icons.mail_outline_rounded,
            title: 'Contact Us',
            subtitle: 'support@yipet.com',
            onTap: onContactTap,
          ),
          const AboutDivider(),
          AboutContactRow(
            icon: Icons.language_rounded,
            title: 'Website',
            subtitle: 'www.yipet.com',
            onTap: onWebsiteTap,
          ),
          const AboutDivider(),
          AboutContactRow(
            icon: Icons.description_outlined,
            title: 'Follow Us',
            subtitle: '@yipet_official',
            onTap: onFollowTap,
          ),
        ],
      ),
    );
  }
}

class AboutContactRow extends StatelessWidget {
  const AboutContactRow({
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
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEDF8EE),
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
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF172038),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF5C6782),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: Color(0xFF5C6782),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
