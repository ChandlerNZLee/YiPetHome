// lib/page/pet/pet-list.dart
import 'package:flutter/material.dart';

import '../../services/user-service.dart';
import '../../core/network/api-exception.dart';

import 'add-pet.dart';
import 'edit-pet.dart';

import '../../view-models/pet.dart';

class PetListPage extends StatefulWidget {
  const PetListPage({super.key});

  @override
  State<PetListPage> createState() => _PetListPageState();
}

class _PetListPageState extends State<PetListPage> {
  static const Color primaryGreen = Color(0xFF15952A);
  static const Color textPrimary = Color(0xFF11182E);
  static const Color textSecondary = Color(0xFF65708A);
  static const Color pageBackground = Color(0xFFFCFDFC);

  List<PetData> pets = [];

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _goToAddPet() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddPetPage()),
    );
  }

  void _goToPet(PetData pet) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditPetPage(pet: pet)),
    );
  }

  @override
  void initState() {
    super.initState();

    _getPetList();
  }

  Future<void> _getPetList() async {
    try {
      final res = await UserService.instance.getPetList();
      final list = res.pets.map((item) => PetData.fromModel(item)).toList();

      setState(() {
        pets = list;
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 24,
                ),
                child: Column(
                  children: [
                    const Text(
                      'Manage your pets and their information',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        height: 1.3,
                        fontWeight: FontWeight.w400,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          ...pets.map(
                            (pet) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _PetCard(
                                pet: pet,
                                onTap: () => _goToPet(pet),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const _PetCareTips(),
                          const SizedBox(height: 16),
                        ],
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 56,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _goBack,
                  borderRadius: BorderRadius.circular(12),
                  child: const SizedBox(
                    width: 44,
                    height: 44,
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 24,
                        color: Color(0xFF11182E),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Text(
              'My Pets',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Material(
                color: const Color(0xFFF0F8F0),
                borderRadius: BorderRadius.circular(22),
                child: InkWell(
                  onTap: _goToAddPet,
                  borderRadius: BorderRadius.circular(22),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_rounded, size: 24, color: primaryGreen),
                        SizedBox(width: 2),
                        Text(
                          'Add Pet',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primaryGreen,
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
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  final PetData pet;
  final VoidCallback onTap;

  const _PetCard({required this.pet, required this.onTap});

  static const Color textPrimary = Color(0xFF11182E);
  static const Color textSecondary = Color(0xFF65708A);
  static const Color cardBorder = Color(0xFFE8ECE8);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 156,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cardBorder, width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              _PetAvatar(pet: pet),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            pet.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.1,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // _PetTypeBadge(type: pet.type),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pet.breed,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.2,
                        fontWeight: FontWeight.w400,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 16,
                          color: Color(0xFF68728B),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            pet.age,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 1,
                          height: 16,
                          color: const Color(0xFFE1E4E8),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          pet.gender == PetGender.male
                              ? Icons.male_rounded
                              : Icons.female_rounded,
                          size: 16,
                          color: const Color(0xFF68728B),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          pet.gender,
                          style: const TextStyle(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 8),
                    // Wrap(
                    //   spacing: 6,
                    //   runSpacing: 4,
                    //   children: pet.tags
                    //       .map((tag) => _PersonalityBadge(tag: tag))
                    //       .toList(),
                    // ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Color(0xFF667087),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PetAvatar extends StatelessWidget {
  final PetData pet;

  const _PetAvatar({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _backgroundColor,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        pet.imagePath,
        width: 88,
        height: 88,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(_fallbackIcon, size: 44, color: _fallbackColor),
          );
        },
      ),
    );
  }

  Color get _backgroundColor {
    if (pet.breed == 'Dog') {
      return const Color(0xFFF0F8E9);
    } else if (pet.breed == 'Cat') {
      return const Color(0xFFFFEEF1);
    } else {
      return const Color(0xFFF2EFFA);
    }
  }

  Color get _fallbackColor {
    if (pet.breed == 'Dog') {
      return const Color(0xFF79AE61);
    } else if (pet.breed == 'Cat') {
      return const Color(0xFFD77A91);
    } else {
      return const Color(0xFF8C72B5);
    }
  }

  IconData get _fallbackIcon {
    if (pet.breed == 'Dog') {
      return Icons.pets_rounded;
    } else if (pet.breed == 'Cat') {
      return Icons.pets_rounded;
    } else {
      return Icons.cruelty_free_rounded;
    }
  }
}

class _PetTypeBadge extends StatelessWidget {
  final PetType type;

  const _PetTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        type.label,
        style: TextStyle(
          fontSize: 12,
          height: 1,
          fontWeight: FontWeight.w700,
          color: _textColor,
        ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (type) {
      case PetType.dog:
        return const Color(0xFFEAF7EA);
      case PetType.cat:
        return const Color(0xFFFFEDF1);
      case PetType.others:
        return const Color(0xFFF0EBFA);
    }
  }

  Color get _textColor {
    switch (type) {
      case PetType.dog:
        return const Color(0xFF1A9230);
      case PetType.cat:
        return const Color(0xFFC85C78);
      case PetType.others:
        return const Color(0xFF7651A8);
    }
  }
}

class _PersonalityBadge extends StatelessWidget {
  final PetPersonalityTag tag;

  const _PersonalityBadge({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tag.colorType.backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        tag.name,
        style: TextStyle(
          fontSize: 12,
          height: 1,
          fontWeight: FontWeight.w600,
          color: tag.colorType.textColor,
        ),
      ),
    );
  }
}

class _PetCareTips extends StatelessWidget {
  const _PetCareTips();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 108),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FBF6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDF3EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE9F6E8),
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              size: 24,
              color: Color(0xFF15952A),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pet Care Tips',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF168D2A),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Keep your pet's information up to date for better care and more personalized services.",
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: Color(0xFF65708A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 72,
            height: 60,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 72,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F2DC),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Icon(
                    Icons.house_rounded,
                    size: 66,
                    color: const Color(0xFF8ACB73),
                  ),
                ),
                const Positioned(
                  bottom: 10,
                  child: Icon(
                    Icons.pets_rounded,
                    size: 16,
                    color: Color(0xFF4BAA46),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
