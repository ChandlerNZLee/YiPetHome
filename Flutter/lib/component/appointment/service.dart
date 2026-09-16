// lib/component/appointment/service.dart
import 'package:flutter/material.dart';

import '../../view-models/pet.dart';
import '../../view-models/appointment.dart';

class AppointmentServiceContent extends StatefulWidget {
  final PetData? selectedPet;
  final List<PetData> pets;
  final ServiceData? selectedService;
  final List<ServiceData> services;
  final void Function(ServiceData service) onServiceChanged;
  final VoidCallback? onChangePet;
  final VoidCallback? onAskGroomer;

  const AppointmentServiceContent({
    super.key,
    required this.selectedPet,
    required this.pets,
    required this.selectedService,
    required this.services,
    required this.onServiceChanged,
    this.onChangePet,
    this.onAskGroomer,
  });

  @override
  State<AppointmentServiceContent> createState() =>
      _AppointmentServiceContentState();
}

class _AppointmentServiceContentState extends State<AppointmentServiceContent> {
  bool _showMoreOptions = false;

  List<ServiceData> _basicServices = [];
  List<ServiceData> _extraServices = [];

  void _toggleMoreOptions() {
    setState(() {
      _showMoreOptions = !_showMoreOptions;
    });
  }

  void _changePet() {
    if (widget.onChangePet != null) {
      widget.onChangePet!();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Change Pet'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _askGroomer() {
    if (widget.onAskGroomer != null) {
      widget.onAskGroomer!();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ask Groomer'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  bool _isSelected(ServiceData service) {
    return widget.selectedService?.name == service.name;
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _basicServices = widget.services.reversed.toList();
      _basicServices.removeLast();
      _extraServices = [widget.services.first];
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width * 0.04;

    return SingleChildScrollView(
      key: const PageStorageKey<String>('appointment_service_content'),
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PetSelectionCard(pet: widget.selectedPet, onChangePet: _changePet),
          const SizedBox(height: 16),
          const Text(
            'Choose Basic Grooming',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppointmentServiceColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select the grooming level that best suits your pet',
            style: TextStyle(
              fontSize: 10,
              color: AppointmentServiceColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          const ServiceInfoBanner(),
          const SizedBox(height: 18),
          ...List.generate(_basicServices.length, (index) {
            final service = _basicServices[index];

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == _basicServices.length - 1 ? 0 : 14,
              ),
              child: GroomingServiceCard(
                data: service,
                selected: _isSelected(service),
                onTap: () => widget.onServiceChanged(service),
              ),
            );
          }),
          const SizedBox(height: 14),
          MoreOptionsButton(
            expanded: _showMoreOptions,
            onTap: _toggleMoreOptions,
          ),
          if (_showMoreOptions) ...[
            const SizedBox(height: 14),
            GroomingServiceCard(
              data: _extraServices[0],
              compact: true,
              selected: _isSelected(_extraServices[0]),
              onTap: () => widget.onServiceChanged(_extraServices[0]),
            ),
          ],
          const SizedBox(height: 20),
          AskGroomerCard(onTap: _askGroomer),
        ],
      ),
    );
  }
}

class PetSelectionCard extends StatelessWidget {
  final PetData? pet;
  final VoidCallback onChangePet;

  const PetSelectionCard({
    super.key,
    required this.pet,
    required this.onChangePet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppointmentServiceColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              pet?.imagePath ?? '',
              width: 88,
              height: 88,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }

                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 88,
                  height: 88,
                  color: const Color(0xFFF2F6EF),
                  child: const Icon(
                    Icons.pets_rounded,
                    size: 44,
                    color: AppointmentServiceColors.primary,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet?.name ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppointmentServiceColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.male_rounded,
                      size: 16,
                      color: Color(0xFF3187F5),
                    ),
                    SizedBox(width: 4),
                    Text(
                      pet?.gender ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppointmentServiceColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: 8),
                    PetTag(label: 'Short Hair'),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '${pet?.weight ?? ''} kg   |   ${pet?.age ?? ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppointmentServiceColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onChangePet,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      'Change Pet',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppointmentServiceColors.primary,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: AppointmentServiceColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PetTag extends StatelessWidget {
  final String label;

  const PetTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF9C5C1A),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ServiceInfoBanner extends StatelessWidget {
  const ServiceInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F9F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.info_rounded,
            size: 16,
            color: AppointmentServiceColors.primary,
          ),
          SizedBox(width: 6),
          Text(
            'Service duration is an estimate and may vary.',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppointmentServiceColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class GroomingServiceCard extends StatelessWidget {
  final ServiceData data;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  const GroomingServiceCard({
    super.key,
    required this.data,
    required this.selected,
    required this.onTap,
    this.compact = false,
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
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            16,
            compact ? 12 : 16,
            16,
            compact ? 12 : 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppointmentServiceColors.primary
                  : AppointmentServiceColors.border,
              width: selected ? 1.6 : 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            data.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppointmentServiceColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
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
                    ),
                    const SizedBox(height: 6),
                    Text(
                      data.description,
                      style: const TextStyle(
                        fontSize: 10,
                        height: 1.45,
                        color: AppointmentServiceColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${data.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppointmentServiceColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? AppointmentServiceColors.primary
                            : const Color(0xFFD6D9DE),
                        width: 1.5,
                      ),
                    ),
                    child: selected
                        ? Container(
                            decoration: BoxDecoration(
                              color: AppointmentServiceColors.primary,
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceFeatureItem extends StatelessWidget {
  final GroomingFeature feature;
  final Color color;

  const ServiceFeatureItem({
    super.key,
    required this.feature,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(feature.icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          feature.label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppointmentServiceColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class MoreOptionsButton extends StatelessWidget {
  final bool expanded;
  final VoidCallback onTap;

  const MoreOptionsButton({
    super.key,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppointmentServiceColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedRotation(
                turns: expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 24,
                  color: AppointmentServiceColors.textSecondary,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                expanded ? 'Hide More Options' : 'Show More Options',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppointmentServiceColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AskGroomerCard extends StatelessWidget {
  final VoidCallback onTap;

  const AskGroomerCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppointmentServiceColors.border),
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
              color: AppointmentServiceColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Not sure which one to choose?',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppointmentServiceColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Our groomers can help you choose the best option for Milo at the salon.',
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.45,
                    color: AppointmentServiceColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppointmentServiceColors.primary,
              side: const BorderSide(color: AppointmentServiceColors.primary),
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

class ServiceDetailPanel extends StatelessWidget {
  final ServiceData data;

  const ServiceDetailPanel({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBF7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppointmentServiceColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppointmentServiceColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            data.description.replaceAll('\n', ' '),
            style: const TextStyle(
              fontSize: 11.5,
              height: 1.5,
              color: AppointmentServiceColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
