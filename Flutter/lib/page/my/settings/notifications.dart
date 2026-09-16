// lib/page/my/settings/notifications.dart
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  static const Color background = Color(0xFFFCFDFB);

  bool _appointments = true;
  bool _healthReminders = true;
  bool _ordersDelivery = true;
  bool _messages = true;
  bool _promotions = true;
  bool _community = true;
  bool _systemUpdates = true;

  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;

  TimeOfDay _quietStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietEnd = const TimeOfDay(hour: 7, minute: 0);

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  Future<void> _editQuietHours() async {
    final start = await showTimePicker(
      context: context,
      initialTime: _quietStart,
      helpText: 'Select quiet hours start',
    );

    if (!mounted || start == null) return;

    final end = await showTimePicker(
      context: context,
      initialTime: _quietEnd,
      helpText: 'Select quiet hours end',
    );

    if (!mounted || end == null) return;

    setState(() {
      _quietStart = start;
      _quietEnd = end;
    });
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
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
              child: NotificationsHeader(onBackTap: _goBack),
            ),
            const SizedBox(height: 18),
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
                    const StayUpdatedCard(),
                    const SizedBox(height: 16),
                    NotificationSettingsSection(
                      title: 'Notification Preferences',
                      children: [
                        NotificationSwitchRow(
                          icon: Icons.calendar_month_outlined,
                          title: 'Appointments',
                          subtitle:
                              'Reminders and updates about your\nupcoming appointments.',
                          value: _appointments,
                          onChanged: (value) {
                            setState(() {
                              _appointments = value;
                            });
                          },
                        ),
                        const NotificationDivider(),
                        NotificationSwitchRow(
                          icon: Icons.health_and_safety_outlined,
                          title: 'Health Reminders',
                          subtitle:
                              'Vaccinations, medications, and health\ncheck reminders.',
                          value: _healthReminders,
                          onChanged: (value) {
                            setState(() {
                              _healthReminders = value;
                            });
                          },
                        ),
                        const NotificationDivider(),
                        NotificationSwitchRow(
                          icon: Icons.shopping_bag_outlined,
                          title: 'Orders & Delivery',
                          subtitle:
                              'Updates about your orders and\nshipping status.',
                          value: _ordersDelivery,
                          onChanged: (value) {
                            setState(() {
                              _ordersDelivery = value;
                            });
                          },
                        ),
                        const NotificationDivider(),
                        NotificationSwitchRow(
                          icon: Icons.chat_bubble_outline_rounded,
                          title: 'Messages',
                          subtitle:
                              'New messages from clinics or\ncustomer support.',
                          value: _messages,
                          onChanged: (value) {
                            setState(() {
                              _messages = value;
                            });
                          },
                        ),
                        const NotificationDivider(),
                        NotificationSwitchRow(
                          icon: Icons.sell_outlined,
                          title: 'Promotions',
                          subtitle:
                              'Deals, offers, and special promotions\nfrom YiPet.',
                          value: _promotions,
                          onChanged: (value) {
                            setState(() {
                              _promotions = value;
                            });
                          },
                        ),
                        const NotificationDivider(),
                        NotificationSwitchRow(
                          icon: Icons.groups_outlined,
                          title: 'Community',
                          subtitle:
                              'Replies, likes, and updates from\nthe community.',
                          value: _community,
                          onChanged: (value) {
                            setState(() {
                              _community = value;
                            });
                          },
                        ),
                        const NotificationDivider(),
                        NotificationSwitchRow(
                          icon: Icons.notifications_none_rounded,
                          title: 'System Updates',
                          subtitle:
                              'Important announcements and\nsystem updates.',
                          value: _systemUpdates,
                          onChanged: (value) {
                            setState(() {
                              _systemUpdates = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    NotificationSettingsSection(
                      title: 'Notification Channels',
                      children: [
                        NotificationSwitchRow(
                          icon: Icons.notifications_none_rounded,
                          title: 'Push Notifications',
                          subtitle: 'Receive notifications on this device.',
                          value: _pushNotifications,
                          onChanged: (value) {
                            setState(() {
                              _pushNotifications = value;
                            });
                          },
                          compact: true,
                        ),
                        const NotificationDivider(),
                        NotificationSwitchRow(
                          icon: Icons.mail_outline_rounded,
                          title: 'Email Notifications',
                          subtitle: 'Receive notifications via email.',
                          value: _emailNotifications,
                          onChanged: (value) {
                            setState(() {
                              _emailNotifications = value;
                            });
                          },
                          compact: true,
                        ),
                        const NotificationDivider(),
                        NotificationSwitchRow(
                          icon: Icons.phone_outlined,
                          title: 'SMS Notifications',
                          subtitle: 'Receive important alerts via SMS.',
                          value: _smsNotifications,
                          onChanged: (value) {
                            setState(() {
                              _smsNotifications = value;
                            });
                          },
                          compact: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    QuietHoursCard(
                      startTime: _formatTime(_quietStart),
                      endTime: _formatTime(_quietEnd),
                      onTap: _editQuietHours,
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

class NotificationsHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const NotificationsHeader({super.key, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Center(
            child: Text(
              'Notifications',
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

class StayUpdatedCard extends StatelessWidget {
  const StayUpdatedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 148,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBF6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDEBDD)),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  width: 66,
                  height: 66,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEDF8EE),
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    size: 36,
                    color: Color(0xFF15952A),
                  ),
                ),
                const SizedBox(width: 12),
                const SizedBox(
                  width: 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stay Updated',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF172038),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Choose what you want to be notified about and how you want to receive it.',
                        style: TextStyle(
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
          ),
          Positioned(
            right: 0,
            bottom: 8,
            child: SizedBox(
              width: 100,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    right: 10,
                    bottom: 0,
                    child: Container(
                      width: 90,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF38616A),
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 0,
                    child: Container(
                      width: 44,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF59C865), Color(0xFF14A12C)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.message_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 28,
                    bottom: 32,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEDF8EE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_rounded,
                        color: Color(0xFF58C761),
                        size: 24,
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

class NotificationSettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const NotificationSettingsSection({
    super.key,
    required this.title,
    required this.children,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF172038),
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class NotificationSwitchRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool compact;

  const NotificationSwitchRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        compact ? 12 : 14,
        14,
        compact ? 12 : 14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: compact ? 44 : 54,
            height: compact ? 44 : 54,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFEDF8EE),
            ),
            child: Icon(
              icon,
              size: compact ? 24 : 28,
              color: const Color(0xFF15952A),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: compact ? 12 : 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF172038),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: compact ? 10 : 12,
                    height: 1.35,
                    color: const Color(0xFF5C6782),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          YiPetSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class YiPetSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const YiPetSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 44,
        height: 28,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? const Color(0xFF0B951D) : const Color(0xFFE5E6E8),
          borderRadius: BorderRadius.circular(14),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x18000000),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationDivider extends StatelessWidget {
  const NotificationDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 92),
      child: Divider(height: 1, color: Color(0xFFE9ECE9)),
    );
  }
}

class QuietHoursCard extends StatelessWidget {
  final String startTime;
  final String endTime;
  final VoidCallback onTap;

  const QuietHoursCard({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6EAE6)),
          ),
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
                child: const Icon(
                  Icons.dark_mode_outlined,
                  size: 24,
                  color: Color(0xFF15952A),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quiet Hours',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF172038),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Pause non-urgent notifications during these hours.',
                      style: TextStyle(fontSize: 10, color: Color(0xFF5C6782)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$startTime - $endTime',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF15952A),
                ),
              ),
              const SizedBox(width: 4),
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
