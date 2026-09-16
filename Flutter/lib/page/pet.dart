// lib/page/pet.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/user-service.dart';
import '../core/network/api-exception.dart';

import '../component/pet/overview.dart';
import '../component/pet/health.dart';
import '../component/pet/records.dart';
import '../component/pet/timeline.dart';

import 'pet/pet-list.dart';
import 'pet/edit-pet.dart';
import 'pet/health-record.dart';

import '../view-models/pet.dart';

class PetPage extends StatefulWidget {
  const PetPage({super.key});

  @override
  State<PetPage> createState() => _PetPageState();
}

class _PetPageState extends State<PetPage> {
  int _selectedTab = 0;

  final List<String> _tabs = const [
    'Overview',
    'Health',
    'Records',
    'Timeline',
  ];

  void _openSettings() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => PetListPage()));
  }

  void _editPet() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditPetPage(pet: _pets[_selectedPetIndex]),
      ),
    );
  }

  Future<void> _selectPet() async {
    final selectedIndex = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
            itemCount: _pets.length,
            separatorBuilder: (_, __) {
              return const Divider(height: 1);
            },
            itemBuilder: (context, index) {
              final pet = _pets[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 6,
                ),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFFF1F8EE),
                  child: ClipOval(
                    child: Image.asset(
                      pet.imagePath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return const Icon(Icons.pets, color: PetColors.primary);
                      },
                    ),
                  ),
                ),
                title: Text(
                  pet.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text('${pet.breed} · ${pet.age}'),
                trailing: index == _selectedPetIndex
                    ? const Icon(Icons.check_circle, color: PetColors.primary)
                    : null,
                onTap: () {
                  Navigator.pop(sheetContext, index);
                },
              );
            },
          ),
        );
      },
    );

    if (selectedIndex == null || !mounted) {
      return;
    }

    final pet = _pets[selectedIndex];
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('pet_id', pet.id);

    setState(() {
      _selectedPetIndex = selectedIndex;
    });
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return const PetOverviewContent();
      case 1:
        return const PetHealthContent();
      case 2:
        return PetRecordsContent(
          onAllRecords: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HealthRecordPage()),
            );
          },
        );
      case 3:
        return const PetTimelineContent();
      default:
        return const PetOverviewContent();
    }
  }

  int _selectedPetIndex = 0;
  List<PetData> _pets = [];

  Future<void> _getPetList() async {
    try {
      final res = await UserService.instance.getPetList();
      final list = res.pets.map((item) => PetData.fromModel(item)).toList();

      setState(() {
        _pets = list;
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
  void initState() {
    super.initState();

    _getPetList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width * 0.055;

    return Scaffold(
      backgroundColor: PetColors.background,
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
              PetHeader(
                pet: _pets[_selectedPetIndex],
                onPetTap: _selectPet,
                onSettingsTap: _openSettings,
              ),
              const SizedBox(height: 18),
              PetHeroBanner(pet: _pets[_selectedPetIndex], onEditTap: _editPet),
              const SizedBox(height: 18),
              PetSegmentBar(
                tabs: _tabs,
                selectedIndex: _selectedTab,
                onChanged: (index) {
                  setState(() {
                    _selectedTab = index;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildTabContent(),
            ],
          ),
        ),
      ),
    );
  }
}

class PetHeader extends StatelessWidget {
  final PetData pet;
  final VoidCallback onPetTap;
  final VoidCallback onSettingsTap;

  const PetHeader({
    super.key,
    required this.pet,
    required this.onPetTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: onPetTap,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          pet.name,
                          style: TextStyle(
                            fontSize: 24,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                            color: PetColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 24,
                          color: PetColors.textPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${pet.breed}  ·  ${pet.age}',
                style: TextStyle(fontSize: 12, color: PetColors.textSecondary),
              ),
            ],
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onSettingsTap,
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Icon(
                Icons.settings_outlined,
                size: 24,
                color: PetColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PetHeroBanner extends StatelessWidget {
  final PetData pet;
  final VoidCallback onEditTap;

  const PetHeroBanner({super.key, required this.pet, required this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.25,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F7EB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6EEE2)),
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF2F9EE), Color(0xFFDFF1D7)],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Image.network(
                pet.imagePath,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (_, __, ___) {
                  return const Center(
                    child: Icon(
                      Icons.pets,
                      color: Color(0xFF8DC37E),
                      size: 130,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              right: 12,
              bottom: 18,
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 3,
                shadowColor: const Color(0x24000000),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onEditTap,
                  child: const SizedBox(
                    width: 44,
                    height: 44,
                    child: Icon(
                      Icons.edit_outlined,
                      color: PetColors.primary,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PetSegmentBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const PetSegmentBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const icons = [
      Icons.pets_rounded,
      Icons.favorite_border_rounded,
      Icons.inventory_2_outlined,
      Icons.timeline_rounded,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PetColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            blurRadius: 13,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          return Expanded(
            child: PetSegmentItem(
              label: tabs[index],
              icon: icons[index],
              selected: selectedIndex == index,
              onTap: () => onChanged(index),
            ),
          );
        }),
      ),
    );
  }
}

class PetSegmentItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const PetSegmentItem({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFF0F8ED)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFFDCEBD7)
                        : const Color(0xFFE8EBE8),
                  ),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: selected ? PetColors.primary : const Color(0xFF727780),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? PetColors.primary : PetColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PetColors {
  static const primary = Color(0xFF22C55E);
  static const textPrimary = Color(0xFF17191D);
  static const textSecondary = Color(0xFF777B84);
  static const border = Color(0xFFECEFEB);
  static const background = Color(0xFFFCFDFB);
}
