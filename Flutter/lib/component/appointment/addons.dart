// lib/component/appointment/addons.dart
import 'package:flutter/material.dart';

import '../../view-models/appointment.dart';

class AppointmentAddonsContent extends StatelessWidget {
  final ServiceData? selectedStyling;
  final ServiceData? selectedSPA;
  final List<ServiceData> premiums;
  final List<ServiceData> selectedAddons;
  final List<ServiceData> addons;
  final ValueChanged<ServiceData?> onChangedStyling;
  final ValueChanged<ServiceData?> onChangedSPA;
  final ValueChanged<List<ServiceData>> onChangedAddons;

  const AppointmentAddonsContent({
    super.key,
    required this.selectedStyling,
    required this.selectedSPA,
    required this.premiums,
    required this.selectedAddons,
    required this.addons,
    required this.onChangedStyling,
    required this.onChangedSPA,
    required this.onChangedAddons,
  });

  static const Color textPrimary = Color(0xFF17191D);

  void _toggleStyling(ServiceData styling) {
    if (selectedStyling?.id == styling.id) {
      onChangedStyling(null);
    } else {
      onChangedStyling(styling);
    }
  }

  void _toggleSPA(ServiceData spa) {
    if (selectedSPA?.id == spa.id) {
      onChangedSPA(null);
    } else {
      onChangedSPA(spa);
    }
  }

  void _toggleAddons(ServiceData addon) {
    final exists = selectedAddons.any((item) => item.id == addon.id);
    if (exists) {
      selectedAddons.removeWhere((item) => item.id == addon.id);
    } else {
      selectedAddons.add(addon);
    }

    onChangedAddons(selectedAddons);
  }

  void _askGroomer(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ask Groomer'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width * 0.035;
    final styling = premiums[0];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AddOnsInfoBanner(),
          const SizedBox(height: 16),
          const Text(
            'Popular Styling',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.only(bottom: 0),
            child: AddOnServiceCard(
              isMultiChoose: false,
              data: styling,
              selected: selectedStyling?.id == styling.id,
              onTap: () => _toggleStyling(styling),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Popular SPAs',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(premiums.length - 1, (index) {
            final item = premiums[index + 1];

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == premiums.length - 1 ? 0 : 12,
              ),
              child: AddOnServiceCard(
                isMultiChoose: false,
                data: item,
                selected: selectedSPA?.id == item.id,
                onTap: () => _toggleSPA(item),
              ),
            );
          }),
          const SizedBox(height: 16),
          const Text(
            'Popular Add-ons',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(addons.length, (index) {
            final item = addons[index];

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == addons.length - 1 ? 0 : 12,
              ),
              child: AddOnServiceCard(
                isMultiChoose: true,
                data: item,
                selected: selectedAddons.any(
                  (selectedItem) => selectedItem.id == item.id,
                ),
                onTap: () => _toggleAddons(item),
              ),
            );
          }),
          const SizedBox(height: 20),
          AskGroomerAddOnCard(onTap: () => _askGroomer(context)),
        ],
      ),
    );
  }
}

class AddOnsInfoBanner extends StatelessWidget {
  const AddOnsInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_rounded, size: 24, color: AddonColors.primary),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Add-on services can be combined with any\n'
              'grooming package.',
              style: TextStyle(
                fontSize: 10,
                height: 1.5,
                color: AddonColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddOnServiceCard extends StatelessWidget {
  final bool isMultiChoose;
  final ServiceData data;
  final bool selected;
  final VoidCallback onTap;

  const AddOnServiceCard({
    super.key,
    required this.isMultiChoose,
    required this.data,
    required this.selected,
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: double.infinity,
          height: 120,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AddonColors.primary : AddonColors.border,
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
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  data.type == 1
                      ? Icons.content_cut_rounded
                      : (data.type == 3
                            ? Icons.add_circle_outline_rounded
                            : Icons.spa_rounded),
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AddonColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.description,
                      style: const TextStyle(
                        fontSize: 10,
                        height: 1.45,
                        color: AddonColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '\$${data.price}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AddonColors.textPrimary,
                    ),
                  ),
                  if (data.type != 3) ...[
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppointmentServiceColors.primary.withValues(
                          alpha: 0.09,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Est. ${data.duration / 2} h',
                        style: TextStyle(
                          color: AppointmentServiceColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(width: 16),
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 24,
                height: 24,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: isMultiChoose ? BoxShape.rectangle : BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? AppointmentServiceColors.primary
                        : const Color(0xFFD6D9DE),
                    width: 1.5,
                  ),
                  borderRadius: isMultiChoose ? BorderRadius.circular(4) : null,
                ),
                child: selected
                    ? isMultiChoose
                          ? const Icon(
                              Icons.check_rounded,
                              size: 16,
                              weight: 800,
                              color: AppointmentServiceColors.primary,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: AppointmentServiceColors.primary,
                                shape: BoxShape.circle,
                              ),
                            )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AskGroomerAddOnCard extends StatelessWidget {
  final VoidCallback onTap;

  const AskGroomerAddOnCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F8ED),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              size: 24,
              color: AddonColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Not sure which add-ons to choose?',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AddonColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Our groomers can recommend the best options for your pet.',
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.45,
                    color: AddonColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              foregroundColor: AddonColors.primary,
              side: const BorderSide(color: AddonColors.primary),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Ask Groomer',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
