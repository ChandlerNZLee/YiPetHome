// lib/page/my.dart
import 'package:flutter/material.dart';

import '../services/user-service.dart';
import '../core/network/api-exception.dart';

import 'my/membership.dart';
import 'my/orders.dart';
import 'my/appointments.dart';
import 'my/favorites.dart';
import 'my/wallet.dart';
import 'my/addresses.dart';
import 'my/community.dart';
import 'my/settings.dart';
import 'my/help-support.dart';

import '../models/user/user-model.dart';

import '../view-models/my.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  UserModel? user;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  void _openProfile() {
    _showMessage('Open profile');
  }

  void _openMembership() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MembershipPage()),
    );
  }

  void _cellAction(String action) {
    if (action == "Orders") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OrdersPage()),
      );
    } else if (action == "Appointments") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AppointmentsPage()),
      );
    } else if (action == "Favorites") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FavoritesPage()),
      );
    } else if (action == "Wallet") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WalletPage(balance: user?.balance ?? 0.00),
        ),
      );
    } else if (action == "Addresses") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddressesPage()),
      );
    } else if (action == "Community") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CommunityPage()),
      );
    } else if (action == "Settings") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SettingsPage()),
      );
    } else if (action == "Help & Support") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HelpSupportPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(action), duration: const Duration(seconds: 1)),
      );
    }
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
        user = res.user;
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
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final horizontalPadding = width * 0.055;

    return Scaffold(
      backgroundColor: MyColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            18,
            horizontalPadding,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserProfileHeader(user: user, onTap: _openProfile),
              const SizedBox(height: 12),
              YiPetPlusCard(onTap: _openMembership),
              const SizedBox(height: 16),
              MainMenuSection(user: user, onAction: _cellAction),
              const SizedBox(height: 16),
              SecondaryMenuSection(onAction: _cellAction),
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfileHeader extends StatelessWidget {
  final UserModel? user;
  final VoidCallback onTap;

  const UserProfileHeader({super.key, this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: ClipOval(
                  child: Image.network(
                    user?.avatar ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        color: const Color(0xFFF1F5F0),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.person,
                          size: 42,
                          color: MyColors.primary,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user?.firstName} ${user?.lastName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                        color: MyColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      user?.email ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: MyColors.textSecondary,
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

class YiPetPlusCard extends StatelessWidget {
  final VoidCallback onTap;

  const YiPetPlusCard({super.key, required this.onTap});

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
          height: 128,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF71AD34), Color(0xFF19A94C), Color(0xFF16B45A)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1611A445),
                blurRadius: 12,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: Stack(
            children: [
              const Positioned(
                right: -45,
                top: -50,
                child: _MembershipDecorationCircle(size: 180, opacity: 0.06),
              ),
              const Positioned(
                right: 95,
                bottom: -45,
                child: _MembershipDecorationCircle(size: 120, opacity: 0.05),
              ),
              Positioned(
                right: 22,
                top: 30,
                child: Image.asset(
                  'assets/images/my/crown.png',
                  width: 44,
                  height: 44,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.workspace_premium_rounded,
                      color: Color(0xFFFFD447),
                      size: 44,
                    );
                  },
                ),
              ),
              const Positioned(
                left: 20,
                top: 24,
                right: 116,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YiPet Plus',
                      style: TextStyle(
                        color: Color(0xFFFFE69A),
                        fontSize: 24,
                        height: 1.05,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Member',
                      style: TextStyle(
                        color: Color(0xFFFFE69A),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Since May 2024',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
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

class _MembershipDecorationCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _MembershipDecorationCircle({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

class MainMenuSection extends StatelessWidget {
  final UserModel? user;
  final ValueChanged<String> onAction;

  const MainMenuSection({super.key, this.user, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final items = <MyMenuItemData>[
      const MyMenuItemData(title: 'Orders', icon: Icons.inventory_2_outlined),
      const MyMenuItemData(
        title: 'Appointments',
        icon: Icons.event_available_outlined,
      ),
      const MyMenuItemData(
        title: 'Favorites',
        icon: Icons.favorite_border_rounded,
      ),
      MyMenuItemData(
        title: 'Wallet',
        icon: Icons.account_balance_wallet_outlined,
        trailingText: '\$${user?.balance.toStringAsFixed(2)}',
      ),
      const MyMenuItemData(
        title: 'Addresses',
        icon: Icons.location_on_outlined,
      ),
      const MyMenuItemData(title: 'Community', icon: Icons.groups_2_outlined),
    ];

    return MyMenuCard(
      children: List.generate(items.length, (index) {
        final item = items[index];

        return Column(
          children: [
            MyMenuTile(data: item, onTap: () => onAction(item.title)),
            if (index != items.length - 1)
              const Divider(height: 1, indent: 36, color: MyColors.border),
          ],
        );
      }),
    );
  }
}

class MyMenuCard extends StatelessWidget {
  final List<Widget> children;

  const MyMenuCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MyColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class MyMenuTile extends StatelessWidget {
  final MyMenuItemData data;
  final VoidCallback onTap;

  const MyMenuTile({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              SizedBox(
                width: 44,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    data.icon,
                    size: 24,
                    color: data.iconColor ?? const Color(0xFF17191D),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: MyColors.textPrimary,
                  ),
                ),
              ),
              if (data.trailingText != null) ...[
                Text(
                  data.trailingText!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: MyColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              const Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: Color(0xFF747981),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondaryMenuSection extends StatelessWidget {
  final ValueChanged<String> onAction;

  const SecondaryMenuSection({super.key, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final items = <MyMenuItemData>[
      const MyMenuItemData(title: 'Settings', icon: Icons.settings_outlined),

      const MyMenuItemData(
        title: 'Help & Support',
        icon: Icons.help_outline_rounded,
      ),
    ];

    return MyMenuCard(
      children: List.generate(items.length, (index) {
        final item = items[index];

        return Column(
          children: [
            MyMenuTile(data: item, onTap: () => onAction(item.title)),
            if (index != items.length - 1)
              const Divider(height: 1, indent: 36, color: MyColors.border),
          ],
        );
      }),
    );
  }
}
