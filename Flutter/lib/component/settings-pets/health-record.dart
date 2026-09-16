// lib/component/settings-pets/health-record.dart
import 'package:flutter/material.dart';

import '../../view-models/settings-pets.dart';

class PetHealthRecordsContent extends StatefulWidget {
  final PetProfileData pet;

  const PetHealthRecordsContent({super.key, required this.pet});

  @override
  State<PetHealthRecordsContent> createState() =>
      _PetHealthRecordsContentState();
}

class _PetHealthRecordsContentState extends State<PetHealthRecordsContent> {
  static const Color textPrimary = Color(0xFF172038);

  PetHealthRecordFilter _selectedFilter = PetHealthRecordFilter.all;

  final List<PetHealthRecordData> _records = const [
    PetHealthRecordData(
      id: 'rabies',
      type: PetHealthRecordType.vaccination,
      typeLabel: 'Vaccination',
      title: 'Rabies Vaccine',
      subtitle: 'Next due: May 10, 2025',
      date: 'May 10, 2024',
      clinic: 'PetCare Clinic',
    ),
    PetHealthRecordData(
      id: 'annual_exam',
      type: PetHealthRecordType.checkup,
      typeLabel: 'Check-up',
      title: 'Annual Physical Exam',
      subtitle: 'All good',
      date: 'Mar 15, 2024',
      clinic: 'PetCare Clinic',
      success: true,
    ),
    PetHealthRecordData(
      id: 'flea_tick',
      type: PetHealthRecordType.medication,
      typeLabel: 'Medication',
      title: 'Flea & Tick Prevention',
      subtitle: 'NexGard Chewable',
      date: 'Feb 10, 2024',
      clinic: 'PetCare Clinic',
    ),
    PetHealthRecordData(
      id: 'blood_test',
      type: PetHealthRecordType.test,
      typeLabel: 'Lab Test',
      title: 'Blood Test',
      subtitle: 'All results normal',
      date: 'Jan 12, 2024',
      clinic: 'PetCare Clinic',
      success: true,
    ),
    PetHealthRecordData(
      id: 'dhpp',
      type: PetHealthRecordType.vaccination,
      typeLabel: 'Vaccination',
      title: 'DHPP Vaccine',
      subtitle: 'Next due: Jan 12, 2025',
      date: 'Jan 12, 2024',
      clinic: 'PetCare Clinic',
    ),
  ];

  List<PetHealthRecordData> get _filteredRecords {
    switch (_selectedFilter) {
      case PetHealthRecordFilter.all:
        return _records;
      case PetHealthRecordFilter.vaccinations:
        return _records
            .where((item) => item.type == PetHealthRecordType.vaccination)
            .toList();
      case PetHealthRecordFilter.checkups:
        return _records
            .where((item) => item.type == PetHealthRecordType.checkup)
            .toList();
      case PetHealthRecordFilter.medications:
        return _records
            .where((item) => item.type == PetHealthRecordType.medication)
            .toList();
    }
  }

  void _openRecord(PetHealthRecordData record) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(record.title),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _setReminder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reminder set for Rabies Vaccine'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey('health_${widget.pet.id}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HealthRecordFilterBar(
          selected: _selectedFilter,
          onChanged: (filter) {
            setState(() {
              _selectedFilter = filter;
            });
          },
        ),
        const SizedBox(height: 12),
        HealthRecordsTimelineCard(
          records: _filteredRecords,
          onTap: _openRecord,
        ),
        const SizedBox(height: 12),
        UpcomingHealthReminderCard(onSetReminder: _setReminder),
        const SizedBox(height: 16),
        const Text(
          'Health Summary',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const HealthSummaryCard(),
        const SizedBox(height: 8),
        const HealthRecordsFooterHint(),
      ],
    );
  }
}

class HealthRecordFilterBar extends StatelessWidget {
  final PetHealthRecordFilter selected;
  final ValueChanged<PetHealthRecordFilter> onChanged;

  const HealthRecordFilterBar({
    super.key,

    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      (PetHealthRecordFilter.all, Icons.folder_copy_outlined, 'All Records'),
      (
        PetHealthRecordFilter.vaccinations,
        Icons.vaccines_outlined,
        'Vaccinations',
      ),
      (
        PetHealthRecordFilter.checkups,
        Icons.medical_services_outlined,
        'Check-ups',
      ),
      (
        PetHealthRecordFilter.medications,
        Icons.medication_outlined,
        'Medications',
      ),
    ];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          final active = selected == item.$1;

          return Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => onChanged(item.$1),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: active ? const Color(0xFFEAF7E8) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: active
                        ? const Color(0xFFD7EFD4)
                        : const Color(0xFFE3E7EB),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.$2,
                      size: 16,
                      color: active
                          ? const Color(0xFF16A52F)
                          : const Color(0xFF657089),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.$3,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                        color: active
                            ? const Color(0xFF169D30)
                            : const Color(0xFF4D5872),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HealthRecordsTimelineCard extends StatelessWidget {
  final List<PetHealthRecordData> records;
  final ValueChanged<PetHealthRecordData> onTap;

  const HealthRecordsTimelineCard({
    super.key,
    required this.records,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E9E5)),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.medical_information_outlined,
              size: 36,
              color: Color(0xFFAAB2BC),
            ),
            SizedBox(height: 12),
            Text(
              'No health records',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF52617D),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E8E4)),
      ),
      child: Column(
        children: List.generate(records.length, (index) {
          return HealthRecordTimelineRow(
            data: records[index],
            isFirst: index == 0,
            isLast: index == records.length - 1,
            onTap: () {
              onTap(records[index]);
            },
          );
        }),
      ),
    );
  }
}

class HealthRecordTimelineRow extends StatelessWidget {
  final PetHealthRecordData data;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const HealthRecordTimelineRow({
    super.key,
    required this.data,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _HealthRecordTypeColors.fromType(data.type);

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 72,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    if (!isFirst)
                      Positioned(
                        top: 0,
                        bottom: 44,
                        child: Container(
                          width: 1.5,
                          color: const Color(0xFFDCE2E5),
                        ),
                      ),

                    if (!isLast)
                      Positioned(
                        top: 44,
                        bottom: 0,
                        child: Container(
                          width: 1.5,
                          color: const Color(0xFFDCE2E5),
                        ),
                      ),
                    Positioned(
                      top: 12,
                      child: Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colors.backgroundColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          colors.icon,
                          size: 24,
                          color: colors.foregroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 88),
                  padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: isLast
                          ? BorderSide.none
                          : const BorderSide(color: Color(0xFFE8ECE8)),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data.typeLabel,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: colors.foregroundColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data.title,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF172038),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    data.subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF52617D),
                                    ),
                                  ),
                                ),

                                if (data.success) ...[
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 16,
                                    color: Color(0xFF16A52F),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              data.date,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF34405D),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data.clinic,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF52617D),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 24,
                        color: Color(0xFF52617D),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpcomingHealthReminderCard extends StatelessWidget {
  final VoidCallback onSetReminder;

  const UpcomingHealthReminderCard({super.key, required this.onSetReminder});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBF7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDEBDD)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF7E8),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_month_outlined,
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
                  'Upcoming Reminder',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF172038),
                  ),
                ),
                SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Rabies Vaccine is due on '),
                      TextSpan(
                        text: 'May 10, 2025',
                        style: TextStyle(
                          color: Color(0xFF16A52F),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  style: TextStyle(fontSize: 10, color: Color(0xFF52617D)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: onSetReminder,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF16A52F),
              side: const BorderSide(color: Color(0xFF16A52F)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Set Reminder',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class HealthSummaryCard extends StatelessWidget {
  const HealthSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      HealthSummaryData(
        icon: Icons.shield_outlined,
        count: '5',
        title: 'Vaccinations',
        status: 'Up to date',
        color: Color(0xFF16A52F),
        background: Color(0xFFEAF7E8),
      ),
      HealthSummaryData(
        icon: Icons.medical_services_outlined,
        count: '2',
        title: 'Check-ups',
        status: 'All good',
        color: Color(0xFF2482F4),
        background: Color(0xFFEDF5FF),
      ),
      HealthSummaryData(
        icon: Icons.medication_outlined,
        count: '1',
        title: 'Medications',
        status: 'Regular',
        color: Color(0xFF8D40E8),
        background: Color(0xFFF5EEFF),
      ),
      HealthSummaryData(
        icon: Icons.science_outlined,
        count: '1',
        title: 'Tests',
        status: 'Normal',
        color: Color(0xFFF39B1B),
        background: Color(0xFFFFF4E4),
      ),
    ];

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E8E4)),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          return Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              decoration: BoxDecoration(
                border: Border(
                  right: index == items.length - 1
                      ? BorderSide.none
                      : const BorderSide(color: Color(0xFFE8ECE8)),
                ),
              ),
              child: _HealthSummaryItem(data: items[index]),
            ),
          );
        }),
      ),
    );
  }
}

class _HealthSummaryItem extends StatelessWidget {
  final HealthSummaryData data;

  const _HealthSummaryItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(data.icon, size: 24, color: data.color),
        const SizedBox(height: 4),
        Text(
          data.count,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF172038),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          data.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: Color(0xFF52617D)),
        ),
        const SizedBox(height: 2),
        Text(
          data.status,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: data.color,
          ),
        ),
      ],
    );
  }
}

class HealthRecordsFooterHint extends StatelessWidget {
  const HealthRecordsFooterHint({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF16A52F)),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            'Keep your pet\'s health records up to date for better care.',
            style: TextStyle(fontSize: 10, color: Color(0xFF52617D)),
          ),
        ),
      ],
    );
  }
}

class _HealthRecordTypeColors {
  final Color foregroundColor;
  final Color backgroundColor;
  final IconData icon;

  const _HealthRecordTypeColors({
    required this.foregroundColor,
    required this.backgroundColor,
    required this.icon,
  });

  factory _HealthRecordTypeColors.fromType(PetHealthRecordType type) {
    switch (type) {
      case PetHealthRecordType.vaccination:
        return const _HealthRecordTypeColors(
          foregroundColor: Color(0xFF16A52F),
          backgroundColor: Color(0xFFEAF7E8),
          icon: Icons.vaccines_outlined,
        );
      case PetHealthRecordType.checkup:
        return const _HealthRecordTypeColors(
          foregroundColor: Color(0xFF2482F4),
          backgroundColor: Color(0xFFEDF5FF),
          icon: Icons.medical_services_outlined,
        );
      case PetHealthRecordType.medication:
        return const _HealthRecordTypeColors(
          foregroundColor: Color(0xFF8D40E8),
          backgroundColor: Color(0xFFF5EEFF),
          icon: Icons.medication_outlined,
        );
      case PetHealthRecordType.test:
        return const _HealthRecordTypeColors(
          foregroundColor: Color(0xFFF39B1B),
          backgroundColor: Color(0xFFFFF4E4),
          icon: Icons.science_outlined,
        );
    }
  }
}
