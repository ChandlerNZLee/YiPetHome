// lib/component/settings-pets/overview.dart
import 'package:flutter/material.dart';

import '../../view-models/settings-pets.dart';

class PetOverviewContent extends StatelessWidget {
  final PetProfileData pet;
  final VoidCallback onEditAbout;

  const PetOverviewContent({
    super.key,
    required this.pet,
    required this.onEditAbout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('overview'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pet Information',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF172038),
          ),
        ),
        const SizedBox(height: 8),
        PetInformationCard(
          items: [
            PetInformationData(
              icon: Icons.pets_outlined,
              label: 'Name',
              value: pet.name,
            ),
            PetInformationData(
              icon: Icons.psychology_alt_outlined,
              label: 'Breed',
              value: pet.breed,
            ),
            PetInformationData(
              icon: pet.gender == 'Male'
                  ? Icons.male_rounded
                  : Icons.female_rounded,
              label: 'Gender',
              value: pet.gender,
            ),
            PetInformationData(
              icon: Icons.calendar_month_outlined,
              label: 'Date of Birth',
              value: formatPetDate(pet.dateOfBirth),
            ),
            PetInformationData(
              icon: Icons.monitor_weight_outlined,
              label: 'Weight',
              value: pet.weight,
            ),
            PetInformationData(
              icon: Icons.straighten_rounded,
              label: 'Neutered',
              value: pet.neutered,
            ),
            PetInformationData(
              icon: Icons.palette_outlined,
              label: 'Color',
              value: pet.color,
            ),
            PetInformationData(
              icon: Icons.article_outlined,
              label: 'Microchip ID',
              value: pet.microchipId,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'About ${pet.name}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF172038),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE4E8E4)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  pet.description,
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.55,
                    color: Color(0xFF35415E),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onEditAbout,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 24,
                    color: Color(0xFF16A52F),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PetInformationCard extends StatelessWidget {
  final List<PetInformationData> items;

  const PetInformationCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E9E5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];

          return Column(
            children: [
              PetInformationRow(data: item),
              if (index != items.length - 1)
                const Padding(
                  padding: EdgeInsets.only(left: 68),
                  child: Divider(height: 1, color: Color(0xFFE9ECE9)),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class PetInformationRow extends StatelessWidget {
  final PetInformationData data;

  const PetInformationRow({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Icon(data.icon, size: 16, color: const Color(0xFF16A52F)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                data.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF273047),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 126,
              child: Text(
                data.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF5B6682),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
