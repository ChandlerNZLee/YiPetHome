// lib/component/appointment/appointment-confirm.dart
import 'package:flutter/material.dart';

import '../../view-models/pet.dart';
import '../../view-models/appointment.dart';
import '../../view-models/shop.dart';

class AppointmentConfirmContent extends StatefulWidget {
  final PetData pet;
  final ServiceData service;
  final ServiceData? styling;
  final ServiceData? spa;
  final ShopData shop;
  final GroomerData groomer;
  final DateTime selectedDate;
  final String selectedTime;
  final String initialNotes;
  final ValueChanged<String> onNotesChanged;
  final List<ServiceData> selectedAddons;
  final List<ServiceData> addons;
  final ValueChanged<List<ServiceData>> onChangedAddons;

  const AppointmentConfirmContent({
    super.key,
    required this.pet,
    required this.service,
    required this.styling,
    required this.spa,
    required this.shop,
    required this.groomer,
    required this.selectedDate,
    required this.selectedTime,
    required this.initialNotes,
    required this.onNotesChanged,
    required this.selectedAddons,
    required this.addons,
    required this.onChangedAddons,
  });

  @override
  State<AppointmentConfirmContent> createState() =>
      _AppointmentConfirmContentState();
}

class _AppointmentConfirmContentState extends State<AppointmentConfirmContent> {
  static const Color textPrimary = Color(0xFF17191D);
  static const Color textSecondary = Color(0xFF344267);

  late final TextEditingController _notesController;

  static const int _maxNotesLength = 200;

  @override
  void initState() {
    super.initState();

    _notesController = TextEditingController(text: widget.initialNotes);
    _notesController.addListener(_handleNotesChanged);
  }

  @override
  void didUpdateWidget(covariant AppointmentConfirmContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialNotes != widget.initialNotes &&
        _notesController.text != widget.initialNotes) {
      _notesController.text = widget.initialNotes;
    }
  }

  @override
  void dispose() {
    _notesController.removeListener(_handleNotesChanged);
    _notesController.dispose();

    super.dispose();
  }

  void _handleNotesChanged() {
    widget.onNotesChanged(_notesController.text);

    setState(() {});
  }

  void _toggleAddons(ServiceData addon) {
    final exists = widget.selectedAddons.any((item) => item.id == addon.id);

    if (exists) {
      widget.selectedAddons.removeWhere((item) => item.id == addon.id);
    } else {
      widget.selectedAddons.add(addon);
    }

    widget.onChangedAddons(widget.selectedAddons);
  }

  bool isShopOpen(String openingTime, String closingTime) {
    try {
      final now = DateTime.now();

      DateTime parseTime(String value) {
        final parts = value.split(':');

        return DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
      }

      final opening = parseTime(openingTime);
      final closing = parseTime(closingTime);

      return !now.isBefore(opening) && now.isBefore(closing);
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width * 0.035;
    final duration =
        widget.service.duration +
        (widget.styling?.duration ?? 0) +
        (widget.spa?.duration ?? 0);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PetInformationCard(
            name: widget.pet.name,
            breed: widget.pet.breed,
            age: widget.pet.age,
            gender: widget.pet.gender,
            imagePath: widget.pet.imagePath,
          ),
          const SizedBox(height: 12),
          AppointmentSummaryCard(
            serviceName: widget.service.name,
            stylingName: widget.styling?.name,
            spaName: widget.spa?.name,
            shopName: widget.shop.name,
            shopAddress: widget.shop.address,
            groomerName: widget.groomer.name,
            isSeniorGroomer: widget.groomer.category == GroomerCategory.senior,
            selectedDate: widget.selectedDate,
            selectedTime: widget.selectedTime,
            duration: duration.toString(),
            petImagePath: widget.pet.imagePath,
          ),
          const SizedBox(height: 12),
          const Text(
            'Grooming Notes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const Text(
            'Any special requests or notes for the groomer?',
            style: TextStyle(fontSize: 12, color: textSecondary),
          ),
          const SizedBox(height: 8),
          GroomingNotesField(
            controller: _notesController,
            maxLength: _maxNotesLength,
          ),
          const SizedBox(height: 16),
          const Text(
            'Add-ons',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ConfirmAddonsCard(
            items: widget.addons,
            selectedAddons: widget.selectedAddons,
            onToggleAddons: _toggleAddons,
          ),
          const SizedBox(height: 18),
          const ConfirmInformationBanner(),
        ],
      ),
    );
  }
}

class PetInformationCard extends StatelessWidget {
  final String name;
  final String breed;
  final String age;
  final String gender;
  final String imagePath;
  final VoidCallback? onTap;

  const PetInformationCard({
    super.key,
    required this.name,
    required this.breed,
    required this.age,
    required this.gender,
    required this.imagePath,
    this.onTap,
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE4E8E4)),
          ),
          child: Row(
            children: [
              ClipOval(
                child: Image.network(
                  imagePath,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (_, __, ___) {
                    return Container(
                      width: 48,
                      height: 48,
                      color: const Color(0xFFF0F4EF),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.pets_rounded,
                        color: Color(0xFF16A52F),
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
                      name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF17191D),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$breed  •  $age  •  $gender',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF344267),
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

class AppointmentSummaryCard extends StatelessWidget {
  final String serviceName;
  final String? stylingName;
  final String? spaName;
  final String shopName;
  final String shopAddress;
  final String groomerName;
  final bool isSeniorGroomer;
  final DateTime? selectedDate;
  final String? selectedTime;
  final String duration;
  final String petImagePath;

  const AppointmentSummaryCard({
    super.key,
    required this.serviceName,
    this.stylingName,
    this.spaName,
    required this.shopName,
    required this.shopAddress,
    required this.groomerName,
    required this.isSeniorGroomer,
    required this.selectedDate,
    required this.selectedTime,
    required this.duration,
    required this.petImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3E8E3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Appointment Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF17191D),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _SummaryItem(
                      icon: Icons.pets_rounded,
                      label: 'Service',
                      value: serviceName,
                    ),
                    if (stylingName != null) ...[
                      const SizedBox(height: 6),
                      _SummaryItem(
                        icon: Icons.content_cut_rounded,
                        label: 'Styling',
                        value: stylingName!,
                      ),
                    ],
                    if (spaName != null) ...[
                      const SizedBox(height: 6),
                      _SummaryItem(
                        icon: Icons.spa_rounded,
                        label: 'SPA',
                        value: spaName!,
                      ),
                    ],
                    const SizedBox(height: 6),
                    _SummaryItem(
                      icon: Icons.storefront_rounded,
                      label: 'Shop',
                      value: '$shopName: $shopAddress',
                    ),
                    const SizedBox(height: 6),
                    _SummaryItem(
                      icon: Icons.person_rounded,
                      label: 'Groomer',
                      value: isSeniorGroomer
                          ? '$groomerName (Senior Groomer)'
                          : groomerName,
                    ),
                    const SizedBox(height: 6),
                    _SummaryItem(
                      icon: Icons.calendar_month_outlined,
                      label: 'Date & Time',
                      value: _formatDateAndTime(selectedDate, selectedTime),
                    ),
                    const SizedBox(height: 6),
                    _SummaryItem(
                      icon: Icons.access_time_rounded,
                      label: 'Duration',
                      value: '${double.parse(duration) / 2} h',
                      showInfo: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatDateAndTime(DateTime? date, String? time) {
    if (date == null || time == null) {
      return 'Not selected';
    }

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} '
        '${date.day}, ${date.year} at $time';
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool showInfo;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    this.showInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFF0F8EE),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF16A52F)),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 66,
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF344267)),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF28344F),
                  ),
                ),
              ),

              if (showInfo) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: Color(0xFF647089),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class GroomingNotesField extends StatelessWidget {
  final TextEditingController controller;
  final int maxLength;

  const GroomingNotesField({
    super.key,
    required this.controller,
    required this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDFE5DF)),
      ),
      child: Stack(
        children: [
          TextField(
            controller: controller,
            maxLength: maxLength,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            cursorColor: const Color(0xFF16A52F),
            style: const TextStyle(
              fontSize: 10,
              height: 1.5,
              color: Color(0xFF28344F),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
              hintText: 'Enter grooming notes...',
              hintStyle: TextStyle(color: Color(0xFF9BA3AF)),
              contentPadding: EdgeInsets.fromLTRB(16, 12, 16, 32),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 8,
            child: AnimatedBuilder(
              animation: controller,
              builder: (_, __) {
                return Text(
                  '${controller.text.length}/$maxLength',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF657089),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmAddonsCard extends StatelessWidget {
  final List<ServiceData> items;
  final List<ServiceData> selectedAddons;
  final ValueChanged<ServiceData> onToggleAddons;

  const ConfirmAddonsCard({
    super.key,
    required this.items,
    required this.selectedAddons,
    required this.onToggleAddons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3E8E3)),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];

          return Column(
            children: [
              ConfirmAddOnRow(
                data: item,
                selected: selectedAddons.any(
                  (selectedItem) => selectedItem.id == item.id,
                ),
                onTap: () => onToggleAddons(item),
              ),

              if (index != items.length - 1)
                const Divider(height: 1, color: Color(0xFFE8ECE8)),
            ],
          );
        }),
      ),
    );
  }
}

class ConfirmAddOnRow extends StatelessWidget {
  final ServiceData data;
  final bool selected;
  final VoidCallback onTap;

  const ConfirmAddOnRow({
    super.key,
    required this.data,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F8EE),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_circle_outline_rounded,
                  size: 20,
                  color: const Color(0xFF16A52F),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF17191D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.description,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF52617D),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '+\$${data.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF28344F),
                ),
              ),
              const SizedBox(width: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 24,
                height: 24,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: selected
                        ? AppointmentServiceColors.primary
                        : const Color(0xFFD6D9DE),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 16,
                        weight: 800,
                        color: AppointmentServiceColors.primary,
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

class ConfirmInformationBanner extends StatelessWidget {
  const ConfirmInformationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_rounded, size: 16, color: Color(0xFF16A52F)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'You can discuss more details with the groomer in person.',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF199231),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
