// lib/page/my/settings.dart
import 'package:flutter/material.dart';

import '../../services/auth-service.dart';

import 'settings/personal-information.dart';
import 'settings/pets.dart';
import 'settings/notifications.dart';
import 'settings/privacy.dart';
import 'settings/check-for-updates.dart';
import 'settings/about-yi-pet.dart';
import '../login.dart';

import '../../view-models/settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _cellAction(String action) {
    if (action == 'Personal Information') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PersonalInformationPage()),
      );
    } else if (action == 'Pets') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PetsPage()),
      );
    } else if (action == 'Notifications') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NotificationsPage()),
      );
    } else if (action == 'Privacy') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PrivacyPage()),
      );
    } else if (action == 'Check for Updates') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CheckForUpdatesPage()),
      );
    } else if (action == 'About YiPet') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AboutYiPetPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(action), duration: const Duration(seconds: 1)),
      );
    }
  }

  Future<void> _logout() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: TextButton.styleFrom(
                foregroundColor: SettingsColors.danger,
              ),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );

    if (result != true || !mounted) return;

    AuthService.instance.logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );

    _showMessage('Logged out');
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final horizontalPadding = width * 0.055;

    return Scaffold(
      backgroundColor: SettingsColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            12,
            horizontalPadding,
            32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsNavigationBar(onBackTap: _goBack),
              const SizedBox(height: 16),
              AccountSettingsSection(onAction: _cellAction),
              const SizedBox(height: 16),
              GeneralSettingsSection(onAction: _cellAction),
              const SizedBox(height: 16),
              SettingsLogoutButton(onTap: _logout),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsNavigationBar extends StatelessWidget {
  final VoidCallback onBackTap;

  const SettingsNavigationBar({super.key, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Center(
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 18,
                height: 1,
                fontWeight: FontWeight.w700,
                color: SettingsColors.textPrimary,
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
                    color: SettingsColors.textPrimary,
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

class AccountSettingsSection extends StatelessWidget {
  final ValueChanged<String> onAction;

  const AccountSettingsSection({super.key, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final items = <SettingsItemData>[
      const SettingsItemData(
        title: 'Personal Information',
        icon: Icons.person_outline_rounded,
      ),
      const SettingsItemData(title: 'Pets', icon: Icons.pets_outlined),
      const SettingsItemData(
        title: 'Notifications',
        icon: Icons.notifications_none_rounded,
      ),
      const SettingsItemData(
        title: 'Privacy',
        icon: Icons.verified_user_outlined,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionTitle(title: 'Account'),
        const SizedBox(height: 12),
        SettingsListCard(
          children: List.generate(items.length, (index) {
            final item = items[index];
            return Column(
              children: [
                SettingsTile(data: item, onTap: () => onAction(item.title)),
                if (index != items.length - 1)
                  const Divider(
                    height: 1,
                    indent: 0,
                    color: SettingsColors.border,
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class SettingsSectionTitle extends StatelessWidget {
  final String title;

  const SettingsSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: SettingsColors.textSecondary,
      ),
    );
  }
}

class SettingsListCard extends StatelessWidget {
  final List<Widget> children;

  const SettingsListCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final SettingsItemData data;
  final VoidCallback onTap;

  const SettingsTile({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: SettingsColors.iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(data.icon, color: SettingsColors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: SettingsColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: Color(0xFF777B83),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class GeneralSettingsSection extends StatelessWidget {
  final ValueChanged<String> onAction;

  const GeneralSettingsSection({super.key, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final items = <SettingsItemData>[
      const SettingsItemData(
        title: 'Check for Updates',
        icon: Icons.cloud_upload_outlined,
      ),
      const SettingsItemData(
        title: 'About YiPet',
        icon: Icons.info_outline_rounded,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionTitle(title: 'General'),
        const SizedBox(height: 12),
        SettingsListCard(
          children: List.generate(items.length, (index) {
            final item = items[index];

            return Column(
              children: [
                SettingsTile(data: item, onTap: () => onAction(item.title)),
                if (index != items.length - 1)
                  const Divider(
                    height: 1,
                    indent: 0,
                    color: SettingsColors.border,
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class SettingsLogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const SettingsLogoutButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: SettingsColors.danger, width: 1.4),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout_rounded,
                color: SettingsColors.danger,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Log Out',
                style: TextStyle(
                  color: SettingsColors.danger,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
