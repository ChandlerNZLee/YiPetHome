// lib/page/pet/health-record.dart
import 'package:flutter/material.dart';

import '../../view-models/health-record.dart';

class HealthRecordPage extends StatefulWidget {
  const HealthRecordPage({super.key});

  @override
  State<HealthRecordPage> createState() => _HealthRecordPageState();
}

class _HealthRecordPageState extends State<HealthRecordPage> {
  static const Color textPrimary = Color(0xFF17191D);
  static const Color background = Color(0xFFF7FBF5);

  int _selectedTab = 0;

  final List<String> _tabs = const ['Vaccine', 'Check-up', 'Test'];

  final List<HealthRecordData> _vaccineRecords = const [
    HealthRecordData(
      title: 'Rabies Vaccine',
      date: 'May 20, 2034',
      status: RecordStatus.upcoming,
      icon: Icons.vaccines_outlined,
    ),
    HealthRecordData(
      title: 'DHPP Vaccine',
      date: 'Feb 10, 2034',
      status: RecordStatus.completed,
      icon: Icons.vaccines_outlined,
    ),
    HealthRecordData(
      title: 'Bordetella Vaccine',
      date: 'Feb 10, 2034',
      status: RecordStatus.completed,
      icon: Icons.vaccines_outlined,
    ),
    HealthRecordData(
      title: 'Leptospirosis Vaccine',
      date: 'Jan 10, 2034',
      status: RecordStatus.completed,
      icon: Icons.vaccines_outlined,
    ),
  ];

  final List<HealthRecordData> _checkupRecords = const [
    HealthRecordData(
      title: 'General Check-up',
      date: 'Jun 10, 2034',
      status: RecordStatus.upcoming,
      icon: Icons.medical_services_outlined,
    ),
    HealthRecordData(
      title: 'Dental Check-up',
      date: 'Mar 18, 2034',
      status: RecordStatus.completed,
      icon: Icons.health_and_safety_outlined,
    ),
    HealthRecordData(
      title: 'Annual Physical Exam',
      date: 'Jan 05, 2034',
      status: RecordStatus.completed,
      icon: Icons.medical_services_outlined,
    ),
  ];

  final List<HealthRecordData> _testRecords = const [
    HealthRecordData(
      title: 'Blood Test',
      date: 'Apr 22, 2034',
      status: RecordStatus.completed,
      icon: Icons.science_outlined,
    ),
    HealthRecordData(
      title: 'Allergy Test',
      date: 'Feb 26, 2034',
      status: RecordStatus.completed,
      icon: Icons.biotech_outlined,
    ),
  ];

  List<HealthRecordData> get _currentRecords {
    switch (_selectedTab) {
      case 1:
        return _checkupRecords;
      case 2:
        return _testRecords;
      default:
        return _vaccineRecords;
    }
  }

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  void _selectTab(int index) {
    if (_selectedTab == index) return;

    setState(() {
      _selectedTab = index;
    });
  }

  void _openRecord(HealthRecordData record) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(record.title),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _addRecord() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add Record',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 18),
                _AddRecordTile(
                  icon: Icons.vaccines_outlined,
                  title: 'Add Vaccine Record',
                  onTap: () {
                    Navigator.pop(sheetContext);
                  },
                ),
                _AddRecordTile(
                  icon: Icons.medical_services_outlined,
                  title: 'Add Check-up Record',
                  onTap: () {
                    Navigator.pop(sheetContext);
                  },
                ),
                _AddRecordTile(
                  icon: Icons.science_outlined,
                  title: 'Add Test Record',
                  onTap: () {
                    Navigator.pop(sheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final horizontalPadding = width * 0.055;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                12,
                horizontalPadding,
                0,
              ),
              child: HealthRecordHeader(onBackTap: _goBack),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: HealthRecordTabBar(
                tabs: _tabs,
                selectedIndex: _selectedTab,
                onChanged: _selectTab,
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF7FBF5),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    16,
                    horizontalPadding,
                    0,
                  ),
                  child: Column(
                    children: [
                      ...List.generate(_currentRecords.length, (index) {
                        final record = _currentRecords[index];

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == _currentRecords.length - 1 ? 0 : 8,
                          ),
                          child: HealthRecordCard(
                            record: record,
                            onTap: () => _openRecord(record),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 16),
          child: AddRecordButton(onTap: _addRecord),
        ),
      ),
    );
  }
}

class HealthRecordHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const HealthRecordHeader({super.key, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Center(
            child: Text(
              'Health Record',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: HealthRecordColors.textPrimary,
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
                    color: HealthRecordColors.textPrimary,
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

class HealthRecordTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const HealthRecordTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final selected = index == selectedIndex;

          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onChanged(index),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFFF5F8F4)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tabs[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: selected
                                ? HealthRecordColors.primary
                                : const Color(0xFF747982),
                          ),
                        ),
                        const SizedBox(height: 12),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: selected ? 34 : 0,
                          height: 4,
                          decoration: BoxDecoration(
                            color: HealthRecordColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class HealthRecordCard extends StatelessWidget {
  final HealthRecordData record;
  final VoidCallback onTap;

  const HealthRecordCard({
    super.key,
    required this.record,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0F2EF)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x07000000),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F8EE),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  record.icon,
                  size: 32,
                  color: HealthRecordColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: HealthRecordColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      record.date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: HealthRecordColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              RecordStatusBadge(status: record.status),
            ],
          ),
        ),
      ),
    );
  }
}

class RecordStatusBadge extends StatelessWidget {
  final RecordStatus status;

  const RecordStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bool upcoming = status == RecordStatus.upcoming;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: upcoming ? const Color(0xFFFFF7E5) : const Color(0xFFF0F8EE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        upcoming ? 'Upcoming' : 'Completed',
        style: TextStyle(
          color: upcoming
              ? const Color(0xFFE59A14)
              : HealthRecordColors.primary,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class AddRecordButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddRecordButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF22C55E), Color(0xFF1BB347)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x2422C55E),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, color: Colors.white, size: 31),

              SizedBox(width: 10),

              Text(
                'Add Record',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
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

class _AddRecordTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _AddRecordTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      leading: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Color(0xFFF0F8EE),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: HealthRecordColors.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
