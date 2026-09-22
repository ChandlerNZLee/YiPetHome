// lib/component/appointment/groomer.dart
import 'package:flutter/material.dart';

import '../../view-models/shop.dart';
import '../../view-models/appointment.dart';

class AppointmentGroomerContent extends StatelessWidget {
  final int? selectedShopId;
  final List<ShopData> shops;
  final ValueChanged<ShopData> onShopChanged;
  final int? selectedGroomerId;
  final List<GroomerData> groomers;
  final ValueChanged<GroomerData> onGroomerChanged;
  final VoidCallback? onAskRecommendation;

  const AppointmentGroomerContent({
    super.key,
    required this.selectedShopId,
    required this.shops,
    required this.onShopChanged,
    required this.selectedGroomerId,
    required this.groomers,
    required this.onGroomerChanged,
    this.onAskRecommendation,
  });

  static const Color textPrimary = Color(0xFF15171C);
  static const Color textSecondary = Color(0xFF30416C);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width * 0.035;
    final seniorGroomers = groomers
        .where((item) => item.category == GroomerCategory.senior)
        .toList();
    final normalGroomers = groomers
        .where((item) => item.category == GroomerCategory.standard)
        .toList();
    final selectedStore = shops.firstWhere(
      (shop) => shop.id == selectedShopId,
      orElse: () => shops.first,
    );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GroomerInfoBanner(),
          const SizedBox(height: 16),
          const Text(
            'Select Store',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          const Text(
            'Choose the store where you want the service',
            style: TextStyle(fontSize: 10, color: textSecondary),
          ),
          const SizedBox(height: 12),
          StoreSelectionCard(
            data: selectedStore,
            onTap: () {
              _showStoreSelector(context);
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Choose Your Groomer',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Select the groomer you prefer for '),
                TextSpan(
                  text: 'Milo',
                  style: TextStyle(
                    color: Color(0xFF7A28DC),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            style: TextStyle(fontSize: 11, color: textSecondary),
          ),
          const SizedBox(height: 12),
          const GroomerSectionHeader(
            type: GroomerCategory.senior,
            title: 'Senior Groomers',
            badge: 'Premium care & expertise',
            subtitle: 'Highly experienced groomers for extra special care.',
          ),
          const SizedBox(height: 12),
          ...seniorGroomers.map(
            (groomer) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GroomerCard(
                data: groomer,
                selected: selectedGroomerId == groomer.id,
                onTap: () => onGroomerChanged(groomer),
              ),
            ),
          ),
          const SizedBox(height: 2),
          const GroomerSectionHeader(
            type: GroomerCategory.standard,
            title: 'Groomers',
            badge: 'Skilled & caring',
            subtitle: 'Skilled groomers who provide excellent care.',
          ),
          const SizedBox(height: 12),
          ...normalGroomers.map(
            (groomer) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GroomerCard(
                data: groomer,
                selected: selectedGroomerId == groomer.id,
                onTap: () => onGroomerChanged(groomer),
              ),
            ),
          ),
          const SizedBox(height: 6),
          GroomerRecommendationCard(
            onTap:
                onAskRecommendation ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ask for Recommendation'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
          ),
        ],
      ),
    );
  }

  void _showStoreSelector(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Store',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                ...shops.map(
                  (store) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: StoreOptionTile(
                      data: store,
                      selected: selectedShopId == store.id,
                      onTap: () {
                        onShopChanged(store);
                        Navigator.pop(sheetContext);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StoreSelectionCard extends StatelessWidget {
  final ShopData data;
  final VoidCallback onTap;

  const StoreSelectionCard({
    super.key,
    required this.data,
    required this.onTap,
  });

  bool isShopOpen(String openingTime, String closingTime) {
    try {
      final now = DateTime.now();

      DateTime parseTime(String value) {
        final parts = value.split(':');

        return DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
      }

      final opening = parseTime(data.openingTime);
      final closing = parseTime(data.closingTime);

      return !now.isBefore(opening) && now.isBefore(closing);
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final open = isShopOpen(data.openingTime, data.closingTime);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E7E2)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  data.image,
                  width: 96,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 96,
                      height: 72,
                      color: const Color(0xFFF1F4F1),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.storefront_outlined,
                        size: 38,
                        color: Color(0xFF18A733),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            data.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF15171C),
                            ),
                          ),
                        ),

                        // if (data.recommended) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDF8EE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Recommended',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF18A733),
                            ),
                          ),
                        ),
                        // ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Color(0xFF61708C),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            data.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF52617D),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          open ? 'Open' : 'Closed',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: open ? Color(0xFF18A733) : Colors.red,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Text(
                          '•',
                          style: TextStyle(color: Color(0xFF52617D)),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          data.closingTime,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF52617D),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: Color(0xFF18212B),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoreOptionTile extends StatelessWidget {
  final ShopData data;
  final bool selected;
  final VoidCallback onTap;

  const StoreOptionTile({
    super.key,
    required this.data,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? const Color(0xFF18A733)
                  : const Color(0xFFE4E8E4),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.storefront_outlined, color: Color(0xFF18A733)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.address,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF667085),
                      ),
                    ),
                  ],
                ),
              ),

              if (selected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF18A733),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroomerInfoBanner extends StatelessWidget {
  const GroomerInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_rounded, size: 24, color: Color(0xFF18A733)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Our groomers are experienced, caring and\n'
              'passionate about pets.',
              style: TextStyle(
                fontSize: 10,
                height: 1.45,
                color: Color(0xFF30416C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GroomerSectionHeader extends StatelessWidget {
  final GroomerCategory type;
  final String title;
  final String badge;
  final String subtitle;

  const GroomerSectionHeader({
    super.key,
    required this.type,
    required this.title,
    required this.badge,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final senior = type == GroomerCategory.senior;
    final color = senior ? const Color(0xFF7D2FE5) : const Color(0xFF1475E8);
    final bg = senior ? const Color(0xFFF3EAFE) : const Color(0xFFEAF3FF);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: 0.25)),
              ),
              child: Icon(
                senior ? Icons.workspace_premium_rounded : Icons.pets_rounded,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Text(subtitle, style: TextStyle(fontSize: 10, color: color)),
        ),
      ],
    );
  }
}

class GroomerCard extends StatelessWidget {
  final GroomerData data;
  final bool selected;
  final VoidCallback onTap;

  const GroomerCard({
    super.key,
    required this.data,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final senior = data.category == GroomerCategory.senior;
    final themeColor = senior
        ? const Color(0xFF8034EB)
        : const Color(0xFF1478EC);
    final tagBg = senior ? const Color(0xFFF3EAFE) : const Color(0xFFEAF3FF);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? themeColor : themeColor.withValues(alpha: 0.28),
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              GroomerAvatar(imagePath: data.imagePath),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF15171C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: tagBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${data.experience}+ years experience',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: themeColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Served ${data.customers} customers',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.description,
                      style: const TextStyle(
                        fontSize: 10,
                        height: 1.35,
                        color: Color(0xFF30416C),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 80,
                child: Column(
                  children: [
                    Text(
                      '+\$${data.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: themeColor,
                      ),
                    ),
                    Text(
                      data.price > 0 ? 'Price difference' : 'No extra charge',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 8,
                        color: Color(0xFF30416C),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              GroomerSelectionRadio(selected: selected, color: themeColor),
            ],
          ),
        ),
      ),
    );
  }
}

class GroomerAvatar extends StatelessWidget {
  final String imagePath;

  const GroomerAvatar({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF2F4F2),
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const Icon(
            Icons.person_rounded,
            size: 36,
            color: Color(0xFFA9AEA9),
          );
        },
      ),
    );
  }
}

class GroomerSelectionRadio extends StatelessWidget {
  final bool selected;
  final Color color;

  const GroomerSelectionRadio({
    super.key,
    required this.selected,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? color : const Color(0xFFD5DAE1),
          width: 1.6,
        ),
      ),
      child: selected
          ? Container(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            )
          : null,
    );
  }
}

class GroomerRecommendationCard extends StatelessWidget {
  final VoidCallback onTap;

  const GroomerRecommendationCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.support_agent_rounded,
            size: 24,
            color: Color(0xFF18A733),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Not sure who to choose?',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4),
                Text(
                  'Our team can help match you with the best groomer for Milo.',
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.35,
                    color: Color(0xFF30416C),
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF18A733),
              side: const BorderSide(color: Color(0xFF18A733)),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Ask for Recommendation',
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
