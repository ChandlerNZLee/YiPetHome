// lib/page/my/appointments/appointment-detail.dart
import 'package:flutter/material.dart';

import '../../../view-models/appointment.dart';

class AppointmentDetailPage extends StatefulWidget {
  const AppointmentDetailPage({super.key, this.appointment});

  final AppointmentDetailData? appointment;

  @override
  State<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  static const Color primary = Color(0xFF15952A);
  static const Color textPrimary = Color(0xFF172038);
  static const Color textSecondary = Color(0xFF667087);
  static const Color background = Color(0xFFFCFDFB);
  static const Color border = Color(0xFFE6EAE6);
  static const Color purple = Color(0xFF8B4DFF);
  static const Color danger = Color(0xFFE54444);

  late AppointmentDetailData appointment;

  @override
  void initState() {
    super.initState();

    appointment =
        widget.appointment ??
        const AppointmentDetailData(
          id: 'A000123',
          status: AppointmentStatus.upcoming,
          serviceName: 'Luxury Spa Wash',
          date: 'May 16, 2024 (Thu)',
          time: '2:00 PM',
          duration: 'About 90 mins',
          storeName: 'YiPet Greenlane Store',
          storeAddress:
              '217 Greenlane West, Epsom\n'
              'Auckland 1051, New Zealand',
          petName: 'Milo',
          petBreed: 'Golden Retriever',
          petGender: 'Male',
          petAge: '3 years old',
          petWeight: '28.5 kg',
          petImagePath: 'assets/images/pets/milo.png',
          groomerName: 'Emily Zhang',
          groomerLevel: 'Senior Groomer',
          groomerRating: '4.9',
          groomerReviews: 128,
          groomerExperience: '8 years of experience',
          groomerImagePath: 'assets/images/groomers/emily_zhang.png',
          addOns: [
            AppointmentAddOnData(name: 'Teeth Brushing', price: 15),
            AppointmentAddOnData(name: 'Paw Balm', price: 10),
          ],
          notes: 'No special notes',
          servicePrice: 85,
        );
  }

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

  void _reschedule() {
    _showMessage('Reschedule Appointment');
  }

  void _viewPetProfile() {
    _showMessage('View ${appointment.petName} Profile');
  }

  void _callGroomer() {
    _showMessage('Call ${appointment.groomerName}');
  }

  void _messageGroomer() {
    _showMessage('Message ${appointment.groomerName}');
  }

  void _addToCalendar() {
    _showMessage('Appointment added to calendar');
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8DCE2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 18),
                ListTile(
                  leading: const Icon(
                    Icons.calendar_month_outlined,
                    color: primary,
                  ),
                  title: const Text('Reschedule'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _reschedule();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.calendar_today_outlined,
                    color: primary,
                  ),
                  title: const Text('Add to Calendar'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _addToCalendar();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.close_rounded, color: danger),
                  title: const Text(
                    'Cancel Appointment',
                    style: TextStyle(color: danger),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _cancelAppointment();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _cancelAppointment() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Cancel Appointment?',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: const Text(
            'Are you sure you want to cancel this appointment?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Keep Appointment'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Cancel Appointment',
                style: TextStyle(color: danger),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      appointment = appointment.copyWith(status: AppointmentStatus.cancelled);
    });

    _showMessage('Appointment cancelled');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Column(
                  children: [
                    _buildAppointmentCard(),
                    const SizedBox(height: 12),
                    _buildPetInformationCard(),
                    const SizedBox(height: 12),
                    _buildGroomerCard(),
                    const SizedBox(height: 12),
                    _buildAppointmentDetailsCard(),
                    const SizedBox(height: 12),
                    _buildPriceSummaryCard(),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SizedBox(
        height: 72,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: _goBack,
                borderRadius: BorderRadius.circular(24),
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 24,
                    color: textPrimary,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Appointment Detail',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Appointment #${appointment.id}',
                  style: const TextStyle(fontSize: 12, color: textSecondary),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: _showMoreMenu,
                borderRadius: BorderRadius.circular(24),
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.more_horiz_rounded,
                    size: 24,
                    color: textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard() {
    return _CardContainer(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatusBadge(status: appointment.status),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    appointment.petImagePath,
                    width: 88,
                    height: 88,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        width: 88,
                        height: 88,
                        alignment: Alignment.center,
                        color: const Color(0xFFF1F8EF),
                        child: const Icon(
                          Icons.pets_rounded,
                          size: 44,
                          color: primary,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.serviceName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _InfoLine(
                        icon: Icons.calendar_month_outlined,
                        text: appointment.date,
                      ),
                      const SizedBox(height: 4),
                      _InfoLine(
                        icon: Icons.access_time_rounded,
                        text: '${appointment.time}  |  ${appointment.duration}',
                      ),
                      const SizedBox(height: 4),
                      _InfoLine(
                        icon: Icons.location_on_outlined,
                        text: appointment.storeName,
                      ),
                    ],
                  ),
                ),

                if (appointment.status == AppointmentStatus.upcoming)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: OutlinedButton.icon(
                      onPressed: _reschedule,
                      icon: const Icon(Icons.calendar_month_outlined, size: 16),
                      label: const Text(
                        'Reschedule',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: purple,
                        backgroundColor: const Color(0xFFF3ECFF),
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetInformationCard() {
    return _CardContainer(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pet Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                ),
                InkWell(
                  onTap: _viewPetProfile,
                  child: const Row(
                    children: [
                      Text(
                        'View Profile',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: primary,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    appointment.petImagePath,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        width: 60,
                        height: 60,
                        color: const Color(0xFFF1F8EF),
                        child: const Icon(Icons.pets_rounded, color: primary),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.petName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${appointment.petBreed}  •  '
                        '${appointment.petGender}  •  '
                        '${appointment.petAge}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        appointment.petWeight,
                        style: const TextStyle(
                          fontSize: 10,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroomerCard() {
    return _CardContainer(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Groomer',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    appointment.groomerImagePath,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        width: 60,
                        height: 60,
                        color: const Color(0xFFF1F8EF),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.person_rounded,
                          size: 32,
                          color: primary,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${appointment.groomerName} '
                        '(${appointment.groomerLevel})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: Color(0xFFFFB000),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            appointment.groomerRating,
                            style: const TextStyle(
                              fontSize: 10,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 1,
                            height: 10,
                            color: const Color(0xFFE0E3E7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${appointment.groomerReviews} reviews',
                            style: const TextStyle(
                              fontSize: 10,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        appointment.groomerExperience,
                        style: const TextStyle(
                          fontSize: 10,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                _ActionSquareButton(
                  icon: Icons.call_outlined,
                  onTap: _callGroomer,
                ),
                const SizedBox(width: 12),
                _ActionSquareButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  onTap: _messageGroomer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentDetailsCard() {
    final addOnNames = appointment.addOns.map((item) => item.name).join(', ');

    return _CardContainer(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appointment Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.content_cut_rounded,
              label: 'Service',
              value: appointment.serviceName,
            ),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.add_circle_outline_rounded,
              label: 'Add-on Services',
              value: addOnNames.isEmpty ? 'None' : addOnNames,
            ),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.access_time_rounded,
              label: 'Duration',
              value: appointment.duration,
            ),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.location_on_outlined,
              label: 'Store',
              value:
                  '${appointment.storeName}\n'
                  '${appointment.storeAddress}',
            ),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.notes_rounded,
              label: 'Notes',
              value: appointment.notes,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummaryCard() {
    final total =
        appointment.servicePrice +
        appointment.addOns.fold<double>(0, (sum, item) => sum + item.price);

    return _CardContainer(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _PriceRow(
              label: appointment.serviceName,
              price: appointment.servicePrice,
            ),
            ...appointment.addOns.map(
              (item) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: _PriceRow(label: item.name, price: item.price),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: border),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return SafeArea(
      top: false,
      child: Container(
        color: background,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: appointment.status == AppointmentStatus.cancelled
                      ? null
                      : _cancelAppointment,
                  icon: const Icon(Icons.close_rounded, size: 16),
                  label: const Text(
                    'Cancel Appointment',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: danger,
                    disabledForegroundColor: const Color(0xFFB8BDC6),
                    side: const BorderSide(color: Color(0xFFE8DADA)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: _addToCalendar,
                  icon: const Icon(Icons.calendar_today_outlined, size: 16),
                  label: const Text(
                    'Add to Calendar',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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

class _CardContainer extends StatelessWidget {
  final Widget child;

  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAE6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final AppointmentStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch (status) {
      AppointmentStatus.upcoming => const Color(0xFFF1E8FF),
      AppointmentStatus.completed => const Color(0xFFEAF7E9),
      AppointmentStatus.cancelled => const Color(0xFFF1F2F4),
    };

    final textColor = switch (status) {
      AppointmentStatus.upcoming => const Color(0xFF8B4DFF),
      AppointmentStatus.completed => const Color(0xFF15952A),
      AppointmentStatus.cancelled => const Color(0xFF717784),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF15952A)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 10, color: Color(0xFF4F5970)),
          ),
        ),
      ],
    );
  }
}

class _ActionSquareButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionSquareButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFEDF8EE),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 24, color: const Color(0xFF15952A)),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          child: Icon(icon, size: 16, color: const Color(0xFF15952A)),
        ),
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF374055)),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              height: 1.45,
              color: Color(0xFF374055),
            ),
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double price;

  const _PriceRow({required this.label, required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF374055)),
          ),
        ),
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 12, color: Color(0xFF172038)),
        ),
      ],
    );
  }
}
