// lib/component/pet/timeline.dart
import 'package:flutter/material.dart';

class PetTimelineContent extends StatefulWidget {
  const PetTimelineContent({super.key});

  @override
  State<PetTimelineContent> createState() => _PetTimelineContentState();
}

class _PetTimelineContentState extends State<PetTimelineContent> {
  int _selectedFilter = 0;

  final List<String> _filters = const [
    'All Events',
    'Medical',
    'Vaccine',
    'Tests',
    'Other',
  ];

  final List<PetTimelineEvent> _events = const [
    PetTimelineEvent(
      monthKey: '2024-05',
      monthLabel: 'May 2024',
      title: 'Rabies Vaccine',
      category: TimelineCategory.vaccine,
      subtitle: 'Vaccine  •  Dr. Sarah Chen',
      detail: 'Next due: May 20, 2025',
      date: 'May 20, 2024',
      icon: Icons.vaccines_outlined,
      color: Color(0xFF22C55E),
    ),
    PetTimelineEvent(
      monthKey: '2024-05',
      monthLabel: 'May 2024',
      title: 'Annual Health Check-up',
      category: TimelineCategory.medical,
      subtitle: 'Check-up  •  Dr. Sarah Chen',
      detail: 'Weight: 23.5 kg',
      date: 'May 16, 2024',
      icon: Icons.medical_services_outlined,
      color: Color(0xFF3187F5),
    ),
    PetTimelineEvent(
      monthKey: '2024-04',
      monthLabel: 'Apr 2024',
      title: 'Fecal Test',
      category: TimelineCategory.test,
      subtitle: 'Test  •  All results normal',
      detail: '',
      date: 'Apr 15, 2024',
      icon: Icons.science_outlined,
      color: Color(0xFF9B42D3),
    ),
    PetTimelineEvent(
      monthKey: '2024-03',
      monthLabel: 'Mar 2024',
      title: 'DHPP Vaccine',
      category: TimelineCategory.vaccine,
      subtitle: 'Vaccine  •  Dr. Sarah Chen',
      detail: 'Next due: Mar 10, 2025',
      date: 'Mar 10, 2024',
      icon: Icons.vaccines_outlined,
      color: Color(0xFF22C55E),
    ),
    PetTimelineEvent(
      monthKey: '2024-03',
      monthLabel: 'Mar 2024',
      title: 'Health Report',
      category: TimelineCategory.other,
      subtitle: 'Report  •  2 pages',
      detail: '',
      date: 'Mar 5, 2024',
      icon: Icons.description_outlined,
      color: Color(0xFFFFA51F),
    ),
    PetTimelineEvent(
      monthKey: '2024-02',
      monthLabel: 'Feb 2024',
      title: 'Skin Allergy Consultation',
      category: TimelineCategory.medical,
      subtitle: 'Check-up  •  Dr. James Lee',
      detail: 'Prescribed medication',
      date: 'Feb 25, 2024',
      icon: Icons.medical_services_outlined,
      color: Color(0xFF3187F5),
    ),
  ];

  List<PetTimelineEvent> get _filteredEvents {
    if (_selectedFilter == 0) return _events;

    final selected = _filters[_selectedFilter];

    return _events.where((event) {
      switch (selected) {
        case 'Medical':
          return event.category == TimelineCategory.medical;
        case 'Vaccine':
          return event.category == TimelineCategory.vaccine;
        case 'Tests':
          return event.category == TimelineCategory.test;
        case 'Other':
          return event.category == TimelineCategory.other;
        default:
          return true;
      }
    }).toList();
  }

  Map<String, List<PetTimelineEvent>> get _groupedEvents {
    final map = <String, List<PetTimelineEvent>>{};

    for (final event in _filteredEvents) {
      map.putIfAbsent(event.monthKey, () => []);
      map[event.monthKey]!.add(event);
    }

    return map;
  }

  void _openFilter() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_filters.length, (index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    _filters[index],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: _selectedFilter == index
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: PetColors.primary,
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(sheetContext);

                    setState(() {
                      _selectedFilter = index;
                    });
                  },
                );
              }),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedEvents;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Milo’s Timeline',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: PetColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'A chronological view of Milo’s health\n'
                    'events and care history.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: PetColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _openFilter,
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFD9E8D6)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.filter_alt_outlined,
                        size: 16,
                        color: PetColors.primary,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: PetColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return TimelineFilterChip(
                label: _filters[index],
                index: index,
                selected: _selectedFilter == index,
                onTap: () {
                  setState(() {
                    _selectedFilter = index;
                  });
                },
              );
            },
          ),
        ),
        const SizedBox(height: 22),

        if (grouped.isEmpty)
          const _TimelineEmptyState()
        else
          ...grouped.entries.map((entry) {
            final events = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: TimelineMonthSection(
                monthLabel: events.first.monthLabel,
                events: events,
              ),
            );
          }),
      ],
    );
  }
}

class TimelineFilterChip extends StatelessWidget {
  final String label;
  final int index;
  final bool selected;
  final VoidCallback onTap;

  const TimelineFilterChip({
    super.key,
    required this.label,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  IconData get _icon {
    switch (index) {
      case 1:
        return Icons.medical_services_outlined;
      case 2:
        return Icons.vaccines_outlined;
      case 3:
        return Icons.science_outlined;
      case 4:
        return Icons.more_horiz_rounded;
      default:
        return Icons.event_available_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFF0F8ED) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? const Color(0xFFD5EAD1) : PetColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                _icon,
                size: 20,
                color: selected ? PetColors.primary : PetColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? PetColors.primary : PetColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimelineMonthSection extends StatelessWidget {
  final String monthLabel;
  final List<PetTimelineEvent> events;

  const TimelineMonthSection({
    super.key,
    required this.monthLabel,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 20,
          top: 0,
          bottom: 0,
          child: Container(width: 1, color: const Color(0xFFDDE3DD)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 88,
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F8ED),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                monthLabel,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: PetColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(events.length, (index) {
              final event = events[index];

              return TimelineEventRow(
                event: event,
                showBottomSpacing: index != events.length - 1,
              );
            }),
          ],
        ),
      ],
    );
  }
}

class TimelineEventRow extends StatelessWidget {
  final PetTimelineEvent event;
  final bool showBottomSpacing;

  const TimelineEventRow({
    super.key,
    required this.event,
    required this.showBottomSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: showBottomSpacing ? 10 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 42,
            child: Padding(
              padding: const EdgeInsets.only(top: 36),
              child: Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: event.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: TimelineEventCard(event: event)),
        ],
      ),
    );
  }
}

class TimelineEventCard extends StatelessWidget {
  final PetTimelineEvent event;

  const TimelineEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(event.title),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Container(
          height: 88,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: PetColors.border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: event.color.withValues(alpha: 0.11),
                  shape: BoxShape.circle,
                ),
                child: Icon(event.icon, size: 24, color: event.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: PetColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 9,
                        color: PetColors.textSecondary,
                      ),
                    ),

                    if (event.detail.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _detailBackground(event),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          event.detail,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: _detailColor(event),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                event.date,
                style: const TextStyle(
                  fontSize: 10,
                  color: PetColors.textSecondary,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: PetColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Color _detailColor(PetTimelineEvent event) {
    switch (event.category) {
      case TimelineCategory.vaccine:
      case TimelineCategory.test:
        return PetColors.primary;
      case TimelineCategory.medical:
        return const Color(0xFF68707A);
      case TimelineCategory.other:
        return const Color(0xFF68707A);
    }
  }

  static Color _detailBackground(PetTimelineEvent event) {
    switch (event.category) {
      case TimelineCategory.vaccine:
      case TimelineCategory.test:
        return const Color(0xFFF0F8ED);
      case TimelineCategory.medical:
        return const Color(0xFFF3F5F6);
      case TimelineCategory.other:
        return const Color(0xFFF3F5F6);
    }
  }
}

class _TimelineEmptyState extends StatelessWidget {
  const _TimelineEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PetColors.border),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timeline_rounded,
            size: 42,
            color: PetColors.textSecondary,
          ),
          SizedBox(height: 10),
          Text(
            'No timeline events',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: PetColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

enum TimelineCategory { medical, vaccine, test, other }

class PetTimelineEvent {
  final String monthKey;
  final String monthLabel;

  final String title;
  final TimelineCategory category;

  final String subtitle;
  final String detail;
  final String date;

  final IconData icon;
  final Color color;

  const PetTimelineEvent({
    required this.monthKey,
    required this.monthLabel,
    required this.title,
    required this.category,
    required this.subtitle,
    required this.detail,
    required this.date,
    required this.icon,
    required this.color,
  });
}

class PetColors {
  static const primary = Color(0xFF22C55E);
  static const textPrimary = Color(0xFF17191D);
  static const textSecondary = Color(0xFF777B84);
  static const border = Color(0xFFECEFEB);
  static const background = Color(0xFFFCFDFB);
}
