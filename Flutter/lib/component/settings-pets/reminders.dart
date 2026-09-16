// lib/component/settings-pets/reminders.dart
import 'package:flutter/material.dart';

import '../../view-models/settings-pets.dart';

class PetRemindersContent extends StatefulWidget {
  final PetProfileData pet;

  final ValueChanged<String>? onReminderTap;
  final VoidCallback? onNotificationSettings;

  const PetRemindersContent({
    super.key,
    required this.pet,
    this.onReminderTap,
    this.onNotificationSettings,
  });

  @override
  State<PetRemindersContent> createState() => _PetRemindersContentState();
}

class _PetRemindersContentState extends State<PetRemindersContent> {
  PetReminderFilter _selectedFilter = PetReminderFilter.all;

  late List<PetReminderData> _reminders;

  @override
  void initState() {
    super.initState();

    _reminders = [
      PetReminderData(
        id: 'rabies',
        petName: widget.pet.name,
        type: PetReminderType.vaccination,
        typeLabel: 'Vaccination',
        title: 'Rabies Vaccine',
        dueDate: 'May 10, 2025',
        repeatText: 'Repeat yearly',
        status: PetReminderStatus.dueSoon,
        remainingText: 'in 10 days',
      ),
      PetReminderData(
        id: 'flea_tick',
        petName: widget.pet.name,
        type: PetReminderType.medication,
        typeLabel: 'Medication',
        title: 'Flea & Tick Prevention',
        dueDate: 'May 20, 2025',
        repeatText: 'Repeat monthly',
        status: PetReminderStatus.upcoming,
        remainingText: 'in 20 days',
      ),
      PetReminderData(
        id: 'annual_exam',
        petName: widget.pet.name,
        type: PetReminderType.healthCheck,
        typeLabel: 'Health Check',
        title: 'Annual Physical Exam',
        dueDate: 'May 28, 2025',
        repeatText: 'Repeat yearly',
        status: PetReminderStatus.upcoming,
        remainingText: 'in 28 days',
      ),
      PetReminderData(
        id: 'dhpp',
        petName: widget.pet.name,
        type: PetReminderType.vaccination,
        typeLabel: 'Vaccination',
        title: 'DHPP Vaccine',
        dueDate: 'Jun 12, 2025',
        repeatText: 'Repeat yearly',
        status: PetReminderStatus.upcoming,
        remainingText: 'in 43 days',
      ),
      PetReminderData(
        id: 'completed_flea',
        petName: widget.pet.name,
        type: PetReminderType.medication,
        typeLabel: 'Medication',
        title: 'Heartworm Prevention',
        dueDate: 'Apr 20, 2025',
        repeatText: 'Repeat monthly',
        status: PetReminderStatus.completed,
        remainingText: 'Completed',
      ),
    ];
  }

  @override
  void didUpdateWidget(covariant PetRemindersContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.pet.id != widget.pet.id) {
      setState(() {
        _reminders = _reminders
            .map((item) => item.copyWith(petName: widget.pet.name))
            .toList();
      });
    }
  }

  List<PetReminderData> get _filteredReminders {
    switch (_selectedFilter) {
      case PetReminderFilter.all:
        return _reminders;
      case PetReminderFilter.dueSoon:
        return _reminders
            .where((item) => item.status == PetReminderStatus.dueSoon)
            .toList();
      case PetReminderFilter.upcoming:
        return _reminders
            .where((item) => item.status == PetReminderStatus.upcoming)
            .toList();
      case PetReminderFilter.completed:
        return _reminders
            .where((item) => item.status == PetReminderStatus.completed)
            .toList();
    }
  }

  void _openReminder(PetReminderData reminder) {
    if (widget.onReminderTap != null) {
      widget.onReminderTap!(reminder.id);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(reminder.title),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _openNotificationSettings() {
    if (widget.onNotificationSettings != null) {
      widget.onNotificationSettings!();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification Settings'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey('reminders_${widget.pet.id}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PetReminderFilterBar(
          selected: _selectedFilter,
          onChanged: (filter) {
            setState(() {
              _selectedFilter = filter;
            });
          },
        ),
        const SizedBox(height: 12),

        if (_filteredReminders.isEmpty)
          const PetReminderEmptyState()
        else
          Column(
            children: List.generate(_filteredReminders.length, (index) {
              final item = _filteredReminders[index];

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == _filteredReminders.length - 1 ? 0 : 12,
                ),
                child: PetReminderCard(
                  data: item,
                  onTap: () {
                    _openReminder(item);
                  },
                ),
              );
            }),
          ),

        const SizedBox(height: 16),
        ReminderNotificationBanner(onTap: _openNotificationSettings),
      ],
    );
  }
}

class PetReminderFilterBar extends StatelessWidget {
  final PetReminderFilter selected;
  final ValueChanged<PetReminderFilter> onChanged;

  const PetReminderFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      (PetReminderFilter.all, 'All Reminders'),
      (PetReminderFilter.dueSoon, 'Due Soon'),
      (PetReminderFilter.upcoming, 'Upcoming'),
      (PetReminderFilter.completed, 'Completed'),
    ];

    return Row(
      children: List.generate(items.length, (index) {
        final filter = items[index].$1;
        final title = items[index].$2;
        final active = selected == filter;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == items.length - 1 ? 0 : 10),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {
                  onChanged(filter);
                },
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  height: 36,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFFEAF7E8) : Colors.white,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: active
                          ? const Color(0xFFD7EFD4)
                          : const Color(0xFFE3E7EB),
                    ),
                  ),
                  child: Text(
                    title,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                      color: active
                          ? const Color(0xFF169D30)
                          : const Color(0xFF4D5872),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class PetReminderCard extends StatelessWidget {
  final PetReminderData data;
  final VoidCallback onTap;

  const PetReminderCard({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final style = PetReminderVisualStyle.fromType(data.type);

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
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E9E5)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x05000000),
                blurRadius: 12,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: style.backgroundColor,
                ),
                child: Icon(style.icon, size: 24, color: style.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.typeLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: style.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.title,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF172038),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.petName,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF52617D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 16,
                          color: Color(0xFF657089),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Due on ${data.dueDate}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF52617D),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: Color(0xFF657089),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            data.repeatText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF52617D),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 88,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    PetReminderStatusBadge(status: data.status),
                    const SizedBox(height: 6),
                    Text(
                      data.remainingText,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _remainingTextColor(data.status),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 24,
                      color: Color(0xFF52617D),
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

  static Color _remainingTextColor(PetReminderStatus status) {
    switch (status) {
      case PetReminderStatus.dueSoon:
        return const Color(0xFF188D2B);
      case PetReminderStatus.upcoming:
        return const Color(0xFFE58A14);
      case PetReminderStatus.completed:
        return const Color(0xFF7A8192);
    }
  }
}

class PetReminderStatusBadge extends StatelessWidget {
  final PetReminderStatus status;

  const PetReminderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late Color background;
    late Color foreground;
    late String title;

    switch (status) {
      case PetReminderStatus.dueSoon:
        background = const Color(0xFFEDF8EE);
        foreground = const Color(0xFF168C29);
        title = 'Due Soon';
        break;
      case PetReminderStatus.upcoming:
        background = const Color(0xFFFFF3E3);
        foreground = const Color(0xFFE58A14);
        title = 'Upcoming';
        break;
      case PetReminderStatus.completed:
        background = const Color(0xFFF0F1F4);
        foreground = const Color(0xFF72798A);
        title = 'Completed';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        maxLines: 1,
        style: TextStyle(
          fontSize: 10,
          height: 1,
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
    );
  }
}

class ReminderNotificationBanner extends StatelessWidget {
  final VoidCallback onTap;

  const ReminderNotificationBanner({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FCF8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7ECE6)),
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
              Icons.notifications_none_rounded,
              size: 24,
              color: Color(0xFF16A52F),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Never miss an important reminder',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172038),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'We\'ll help you keep track of your pet\'s health needs.',
                  style: TextStyle(fontSize: 10, color: Color(0xFF52617D)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF168C29),
              side: const BorderSide(color: Color(0xFF168C29), width: 1.2),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Notification Settings',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class PetReminderEmptyState extends StatelessWidget {
  const PetReminderEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E9E5)),
      ),
      child: const Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Color(0xFFEDF8EE),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 34,
              color: Color(0xFF16A52F),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'No reminders',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF172038),
            ),
          ),
          SizedBox(height: 7),
          Text(
            'There are no reminders in this category.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFF52617D)),
          ),
        ],
      ),
    );
  }
}

class PetReminderVisualStyle {
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const PetReminderVisualStyle({
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  factory PetReminderVisualStyle.fromType(PetReminderType type) {
    switch (type) {
      case PetReminderType.vaccination:
        return const PetReminderVisualStyle(
          icon: Icons.vaccines_outlined,
          color: Color(0xFF16A52F),
          backgroundColor: Color(0xFFEDF8EE),
        );
      case PetReminderType.medication:
        return const PetReminderVisualStyle(
          icon: Icons.medication_outlined,
          color: Color(0xFF9840E8),
          backgroundColor: Color(0xFFF6EDFF),
        );
      case PetReminderType.healthCheck:
        return const PetReminderVisualStyle(
          icon: Icons.medical_services_outlined,
          color: Color(0xFF2887F3),
          backgroundColor: Color(0xFFEDF5FF),
        );
    }
  }
}
