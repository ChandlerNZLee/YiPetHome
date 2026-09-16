// lib/component/pet/records.dart
import 'package:flutter/material.dart';

import '../../view-models/pet.dart';

class PetRecordsContent extends StatefulWidget {
  final VoidCallback? onAllRecords;

  const PetRecordsContent({super.key, this.onAllRecords});

  @override
  State<PetRecordsContent> createState() => _PetRecordsContentState();
}

class _PetRecordsContentState extends State<PetRecordsContent> {
  int _selectedFilter = 0;

  final List<String> _filters = const [
    'All Records',
    'Vaccine',
    'Check-up',
    'Test',
  ];

  final List<PetRecordData> _records = const [
    PetRecordData(
      title: 'Rabies Vaccine',
      type: 'Vaccine',
      detail: 'Next due: May 20, 2025',
      date: 'May 20, 2024',
      icon: Icons.vaccines_outlined,
      color: Color(0xFF22C55E),
    ),
    PetRecordData(
      title: 'Annual Health Check-up',
      type: 'Check-up',
      detail: 'Dr. Sarah Chen',
      date: 'Apr 15, 2024',
      icon: Icons.medical_services_outlined,
      color: Color(0xFF3187F5),
    ),
    PetRecordData(
      title: 'Fecal Test',
      type: 'Test',
      detail: 'All results normal',
      date: 'Mar 10, 2024',
      icon: Icons.science_outlined,
      color: Color(0xFF9B42D3),
    ),
    PetRecordData(
      title: 'DHPP Vaccine',
      type: 'Vaccine',
      detail: 'Next due: Mar 10, 2025',
      date: 'Mar 10, 2024',
      icon: Icons.vaccines_outlined,
      color: Color(0xFF22C55E),
    ),
    PetRecordData(
      title: 'Health Report',
      type: 'Report',
      detail: '2 pages',
      date: 'Feb 25, 2024',
      icon: Icons.description_outlined,
      color: Color(0xFFFFA51F),
    ),
  ];

  List<PetRecordData> get _filteredRecords {
    if (_selectedFilter == 0) {
      return _records;
    }

    final type = _filters[_selectedFilter];

    return _records.where((record) {
      return record.type == type;
    }).toList();
  }

  void _addRecord() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add Record'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    'Health Records',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: PetColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'View and manage Milo’s health history\nin one place.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: PetColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Material(
              color: const Color(0xFFF0F8ED),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: _addRecord,
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        size: 16,
                        color: PetColors.primary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Add Record',
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
        const SizedBox(height: 12),
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return PetRecordFilter(
                index: index,
                label: _filters[index],
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
        const SizedBox(height: 12),
        const PetRecordStatistics(),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Recent Records',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: PetColors.textPrimary,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => widget.onAllRecords?.call(),
              child: const Text(
                'See All',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: PetColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        PetRecordList(records: _filteredRecords),
        const SizedBox(height: 16),
        PetRecordsBanner(onTap: _addRecord),
      ],
    );
  }
}

class PetRecordFilter extends StatelessWidget {
  final int index;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const PetRecordFilter({
    super.key,
    required this.index,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  IconData get icon {
    switch (index) {
      case 1:
        return Icons.vaccines_outlined;
      case 2:
        return Icons.medical_services_outlined;
      case 3:
        return Icons.science_outlined;
      default:
        return Icons.description_outlined;
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
              color: selected ? const Color(0xFFD7EBD3) : PetColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? PetColors.primary : PetColors.textSecondary,
              ),
              const SizedBox(width: 4),
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

class PetRecordStatistics extends StatelessWidget {
  const PetRecordStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PetColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        children: [
          Expanded(
            child: RecordStatItem(
              icon: Icons.verified_user_outlined,
              number: '3',
              title: 'Vaccines',
              subtitle: 'Up to date',
              color: Color(0xFF22C55E),
              background: Color(0xFFF0F8ED),
            ),
          ),
          RecordDivider(),
          Expanded(
            child: RecordStatItem(
              icon: Icons.medical_services_outlined,
              number: '2',
              title: 'Check-ups',
              subtitle: 'Last 3 months',
              color: Color(0xFF3187F5),
              background: Color(0xFFEDF5FF),
            ),
          ),
          RecordDivider(),
          Expanded(
            child: RecordStatItem(
              icon: Icons.science_outlined,
              number: '1',
              title: 'Tests',
              subtitle: 'Last 6 months',
              color: Color(0xFF9B42D3),
              background: Color(0xFFF8EEFF),
            ),
          ),
          RecordDivider(),
          Expanded(
            child: RecordStatItem(
              icon: Icons.description_outlined,
              number: '2',
              title: 'Reports',
              subtitle: 'Available',
              color: Color(0xFFFFA51F),
              background: Color(0xFFFFF5E5),
            ),
          ),
        ],
      ),
    );
  }
}

class RecordDivider extends StatelessWidget {
  const RecordDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 70, color: PetColors.border);
  }
}

class RecordStatItem extends StatelessWidget {
  final IconData icon;
  final String number;
  final String title;
  final String subtitle;
  final Color color;
  final Color background;

  const RecordStatItem({
    super.key,
    required this.icon,
    required this.number,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 6),
            Text(
              number,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          title,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: PetColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 9, color: color),
        ),
      ],
    );
  }
}

class PetRecordList extends StatelessWidget {
  final List<PetRecordData> records;

  const PetRecordList({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Container(
        height: 60,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: PetColors.border),
        ),
        child: const Text(
          'No records',
          style: TextStyle(color: PetColors.textSecondary),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PetColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(
          records.length,
          (index) => Column(
            children: [
              PetRecordItem(data: records[index]),
              if (index != records.length - 1)
                const Divider(height: 1, indent: 55, color: PetColors.border),
            ],
          ),
        ),
      ),
    );
  }
}

class PetRecordItem extends StatelessWidget {
  final PetRecordData data;

  const PetRecordItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, size: 20, color: data.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: PetColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${data.type}  •  ${data.detail}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: data.type == 'Vaccine' || data.type == 'Test'
                        ? PetColors.primary
                        : PetColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Text(
            data.date,
            style: const TextStyle(fontSize: 9, color: PetColors.textSecondary),
          ),
          const SizedBox(width: 2),
          const Icon(
            Icons.chevron_right_rounded,
            size: 16,
            color: PetColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class PetRecordsBanner extends StatelessWidget {
  final VoidCallback onTap;

  const PetRecordsBanner({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8EE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: PetColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.folder_copy_outlined,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keep Milo’s records organized',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: PetColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Upload documents or add new records\nto keep everything in one place.',
                  style: TextStyle(
                    fontSize: 9,
                    height: 1.4,
                    color: PetColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              foregroundColor: PetColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              side: const BorderSide(color: Color(0xFFB9DFB5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Add Record',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
