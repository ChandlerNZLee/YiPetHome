// lib/page/my/settings/pets.dart
import 'package:flutter/material.dart';

import '../../../component/settings-pets/overview.dart';
import '../../../component/settings-pets/health-record.dart';
import '../../../component/settings-pets/appointments.dart';
import '../../../component/settings-pets/reminders.dart';

import '../../../view-models/settings-pets.dart';

class PetsPage extends StatefulWidget {
  const PetsPage({super.key});

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  static const Color primary = Color(0xFF16A52F);
  static const Color textPrimary = Color(0xFF172038);
  static const Color textSecondary = Color(0xFF52617D);
  static const Color background = Color(0xFFFCFDFB);

  int _selectedPetIndex = 0;
  PetProfileTab _selectedTab = PetProfileTab.overview;

  final List<PetProfileData> _pets = [
    PetProfileData(
      id: 'buddy',
      name: 'Buddy',
      breed: 'Golden Retriever',
      gender: 'Male',
      ageText: '3 Years 2 Months',
      dateOfBirth: DateTime(2021, 5, 10),
      weight: '28.5 kg',
      neutered: 'Yes',
      color: 'Golden',
      microchipId: '985 141 000 123 456',
      imagePath: 'assets/images/pets/buddy.png',
      isPrimary: true,
      description:
          'Buddy is a friendly and energetic Golden Retriever.\n'
          'He loves playing fetch and going on walks.',
    ),
    PetProfileData(
      id: 'luna',
      name: 'Luna',
      breed: 'British Shorthair',
      gender: 'Female',
      ageText: '2 Years',
      dateOfBirth: DateTime(2022, 8, 18),
      weight: '4.2 kg',
      neutered: 'Yes',
      color: 'Grey',
      microchipId: '985 141 000 222 781',
      imagePath: 'assets/images/pets/luna.png',
      isPrimary: false,
      description: 'Luna is calm, curious and loves relaxing near the window.',
    ),
    PetProfileData(
      id: 'momo',
      name: 'Momo',
      breed: 'Bichon Frise',
      gender: 'Female',
      ageText: '1 Year 8 Months',
      dateOfBirth: DateTime(2023, 1, 6),
      weight: '5.8 kg',
      neutered: 'No',
      color: 'White',
      microchipId: '985 141 000 338 909',
      imagePath: 'assets/images/pets/momo.png',
      isPrimary: false,
      description:
          'Momo is playful, affectionate and enjoys meeting new people.',
    ),
  ];

  PetProfileData get _selectedPet => _pets[_selectedPetIndex];

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  void _addPet() {
    _showMessage('Add Pet');
  }

  void _editAbout() {
    _showMessage('Edit ${_selectedPet.name}');
  }

  void _openPetMenu(PetProfileData pet) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_outlined, color: primary),
                  title: const Text('Edit Pet'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showMessage('Edit ${pet.name}');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.star_outline_rounded,
                    color: primary,
                  ),
                  title: const Text('Set as Primary'),
                  onTap: () {
                    Navigator.pop(sheetContext);

                    setState(() {
                      for (int i = 0; i < _pets.length; i++) {
                        _pets[i] = _pets[i].copyWith(
                          isPrimary: _pets[i].id == pet.id,
                        );
                      }
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                  ),
                  title: const Text('Delete Pet'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showMessage('Delete ${pet.name}');
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
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width * 0.04;

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
              child: PetsHeader(onBackTap: _goBack, onAddTap: _addPet),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Pets',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Manage your pet profiles and health information',
                            style: TextStyle(
                              fontSize: 12,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 160,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        itemCount: _pets.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final pet = _pets[index];

                          return PetProfileCard(
                            data: pet,
                            selected: _selectedPetIndex == index,
                            onTap: () {
                              setState(() {
                                _selectedPetIndex = index;
                              });
                            },
                            onMenuTap: () {
                              _openPetMenu(pet);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: PetUpdateInformationCard(
                        onTap: () {
                          _showMessage(
                            'Keep ${_selectedPet.name}\'s information up to date',
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    PetProfileTabs(
                      selected: _selectedTab,
                      onChanged: (tab) {
                        setState(() {
                          _selectedTab = tab;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: KeyedSubtree(
                          key: ValueKey(
                            '${_selectedPet.id}_${_selectedTab.name}',
                          ),
                          child: _buildSelectedTabContent(),
                        ),
                      ),
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

  Widget _buildSelectedTabContent() {
    switch (_selectedTab) {
      case PetProfileTab.overview:
        return PetOverviewContent(pet: _selectedPet, onEditAbout: _editAbout);
      case PetProfileTab.healthRecords:
        return PetHealthRecordsContent(pet: _selectedPet);
      case PetProfileTab.appointments:
        return PetAppointmentsContent(pet: _selectedPet);
      case PetProfileTab.reminders:
        return PetRemindersContent(pet: _selectedPet);
    }
  }
}

class PetsHeader extends StatelessWidget {
  final VoidCallback onBackTap;
  final VoidCallback onAddTap;

  const PetsHeader({
    super.key,
    required this.onBackTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Center(
            child: Text(
              'Pets',
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
          Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: onAddTap,
                borderRadius: BorderRadius.circular(10),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        size: 24,
                        color: Color(0xFF16A52F),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Add Pet',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF16A52F),
                        ),
                      ),
                    ],
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

class PetProfileCard extends StatelessWidget {
  final PetProfileData data;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onMenuTap;

  const PetProfileCard({
    super.key,
    required this.data,
    required this.selected,
    required this.onTap,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 280,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF9FCF7) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFF89C98B)
                  : const Color(0xFFE4E8E4),
              width: selected ? 1.5 : 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x05000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  if (data.isPrimary)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F7E7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 12,
                            color: Color(0xFF16A52F),
                          ),
                          SizedBox(width: 2),
                          Text(
                            'Primary',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF16A52F),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const Spacer(),
                  if (data.isPrimary) const Spacer(),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onMenuTap,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.more_horiz_rounded,
                        size: 24,
                        color: Color(0xFF172038),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        data.imagePath,
                        width: 88,
                        height: 88,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            width: 88,
                            height: 88,
                            alignment: Alignment.center,
                            color: const Color(0xFFF0F4EF),
                            child: const Icon(
                              Icons.pets_rounded,
                              size: 56,
                              color: Color(0xFF80AA79),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF172038),
                            ),
                          ),
                          Text(
                            data.breed,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF52617D),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                data.gender == 'Male'
                                    ? Icons.male_rounded
                                    : Icons.female_rounded,
                                size: 16,
                                color: data.gender == 'Male'
                                    ? const Color(0xFF16A52F)
                                    : const Color(0xFFE9468E),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                data.gender,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF52617D),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '|',
                                style: TextStyle(color: Color(0xFF9EA6B5)),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  data.ageText,
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
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.monitor_weight_outlined,
                                size: 16,
                                color: Color(0xFF66718A),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                data.weight,
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

class PetUpdateInformationCard extends StatelessWidget {
  final VoidCallback onTap;

  const PetUpdateInformationCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8FBF7),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFDCEBDA)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF0F8EE),
                ),
                child: const Icon(
                  Icons.verified_user_outlined,
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
                      'Keep your pet\'s information up to date',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF172038),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Accurate information helps us provide better care for your pet.',
                      style: TextStyle(fontSize: 10, color: Color(0xFF52617D)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: Color(0xFF57627B),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum PetProfileTab { overview, healthRecords, appointments, reminders }

class PetProfileTabs extends StatelessWidget {
  final PetProfileTab selected;
  final ValueChanged<PetProfileTab> onChanged;

  const PetProfileTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      (PetProfileTab.overview, Icons.pets_outlined, 'Overview'),
      (
        PetProfileTab.healthRecords,
        Icons.medical_services_outlined,
        'Health Records',
      ),
      (
        PetProfileTab.appointments,
        Icons.calendar_month_outlined,
        'Appointments',
      ),
      (PetProfileTab.reminders, Icons.notifications_none_rounded, 'Reminders'),
    ];

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE7EBE7))),
      ),
      child: Row(
        children: items.map((item) {
          final tab = item.$1;
          final active = selected == tab;

          return Expanded(
            child: InkWell(
              onTap: () => onChanged(tab),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.$2,
                          size: 16,
                          color: active
                              ? const Color(0xFF16A52F)
                              : const Color(0xFF68728B),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            item.$3,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: active
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: active
                                  ? const Color(0xFF16A52F)
                                  : const Color(0xFF68728B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: 2,
                    color: active
                        ? const Color(0xFF16A52F)
                        : Colors.transparent,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
