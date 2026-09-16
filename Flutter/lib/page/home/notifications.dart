// lib/page/home/notifications.dart
import 'package:flutter/material.dart';

import '../../view-models/notifications.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  static const Color _background = Color(0xFFFCFDFB);

  final List<NotificationItemData> _todayItems = const [
    NotificationItemData(
      title: 'Appointment Reminder',
      description: 'Grooming appointment\ntomorrow at 2:00 PM',
      time: '10:00 AM',
      icon: Icons.event_available_outlined,
    ),
    NotificationItemData(
      title: 'Vaccine Reminder',
      description: 'Rabies vaccine is due\nin 5 days',
      time: '9:00 AM',
      icon: Icons.health_and_safety_outlined,
    ),
    NotificationItemData(
      title: 'Order Shipped',
      description: 'Your order #12345\nhas been shipped',
      time: '8:00 AM',
      icon: Icons.shopping_bag_outlined,
    ),
  ];

  final List<NotificationItemData> _yesterdayItems = const [
    NotificationItemData(
      title: 'AI Chat Summary',
      description: 'Your AI chat summary\nis ready to view',
      time: '',
      icon: Icons.smart_toy_outlined,
    ),
  ];

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _openNotification(NotificationItemData item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(item.title), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: _NotificationsHeader(unreadCount: 1, onBackTap: _goBack),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  24,
                  16,
                  24,
                  media.padding.bottom + 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle(title: 'Today'),
                    _NotificationSection(
                      items: _todayItems,
                      onTap: _openNotification,
                    ),
                    const SizedBox(height: 16),
                    const _SectionTitle(title: 'Yesterday'),
                    _NotificationSection(
                      items: _yesterdayItems,
                      onTap: _openNotification,
                    ),
                    const SizedBox(height: 20),
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

class _NotificationsHeader extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onBackTap;

  const _NotificationsHeader({
    required this.unreadCount,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
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
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 24,
                      color: Color(0xFF17191D),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Center(
            child: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                height: 1,
                fontWeight: FontWeight.w700,
                color: Color(0xFF17191D),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: Color(0xFF656A73),
      ),
    );
  }
}

class _NotificationSection extends StatelessWidget {
  final List<NotificationItemData> items;
  final ValueChanged<NotificationItemData> onTap;

  const _NotificationSection({required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];

        return Column(
          children: [
            _NotificationTile(data: item, onTap: () => onTap(item)),
            if (index != items.length - 1)
              const Divider(
                height: 1,
                thickness: 1,
                indent: 0,
                color: Color(0xFFECEEEB),
              ),
          ],
        );
      }),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItemData data;
  final VoidCallback onTap;

  const _NotificationTile({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F9EE),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(data.icon, size: 28, color: Color(0xFF159A35)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            data.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.25,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF17191D),
                            ),
                          ),
                        ),
                        if (data.time.isNotEmpty) ...[
                          const SizedBox(width: 12),
                          Text(
                            data.time,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.25,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF747982),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.description,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.7,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF747982),
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
