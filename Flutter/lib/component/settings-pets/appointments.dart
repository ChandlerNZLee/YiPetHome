// lib/component/settings-pets/appointments.dart
import 'package:flutter/material.dart';

import '../../view-models/settings-pets.dart';

class PetAppointmentsContent extends StatefulWidget {
  final PetProfileData pet;

  const PetAppointmentsContent({
    super.key,
    required this.pet,
    this.onManageAppointments,
    this.onAppointmentTap,
  });

  final VoidCallback? onManageAppointments;
  final ValueChanged<String>? onAppointmentTap;

  @override
  State<PetAppointmentsContent> createState() => _PetAppointmentsContentState();
}

class _PetAppointmentsContentState extends State<PetAppointmentsContent> {
  int _selectedTab = 0;

  static const Color _green = Color(0xFF15952A);
  static const Color _dark = Color(0xFF11172E);
  static const Color _textSecondary = Color(0xFF5D6785);
  static const Color _border = Color(0xFFE7EAF0);
  static const Color _softGreen = Color(0xFFF1F9F2);

  final List<String> _tabs = const ['Upcoming', 'Past', 'Cancelled'];

  final List<PetAppointmentData> _upcomingAppointments = const [
    PetAppointmentData(
      id: 'grooming_001',
      title: 'Grooming Appointment',
      subtitle: 'Basic Wash & Groom',
      date: 'May 16, 2024 (Thu)',
      time: '10:00 AM',
      location: 'Happy Paws Pet Grooming',
      address: '123 Queen Street, Auckland',
      type: PetAppointmentType.grooming,
      status: 'Confirmed',
    ),
    PetAppointmentData(
      id: 'checkup_001',
      title: 'Health Check-up',
      subtitle: 'Annual Physical Exam',
      date: 'May 28, 2024 (Tue)',
      time: '2:30 PM',
      location: 'Paws & Claws Vet Clinic',
      address: '45 Khyber Pass Road, Auckland',
      type: PetAppointmentType.checkup,
      status: 'Confirmed',
    ),
    PetAppointmentData(
      id: 'vaccination_001',
      title: 'Vaccination',
      subtitle: 'DHPP Vaccine',
      date: 'Jun 12, 2024 (Wed)',
      time: '11:00 AM',
      location: 'Paws & Claws Vet Clinic',
      address: '45 Khyber Pass Road, Auckland',
      type: PetAppointmentType.vaccination,
      status: 'Confirmed',
    ),
  ];

  final List<PetAppointmentData> _pastAppointments = const [
    PetAppointmentData(
      id: 'past_001',
      title: 'Grooming Appointment',
      subtitle: 'Luxury Spa Wash',
      date: 'Apr 18, 2024 (Thu)',
      time: '1:30 PM',
      location: 'Happy Paws Pet Grooming',
      address: '123 Queen Street, Auckland',
      type: PetAppointmentType.grooming,
      status: 'Completed',
    ),
    PetAppointmentData(
      id: 'past_002',
      title: 'Health Check-up',
      subtitle: 'Routine Health Examination',
      date: 'Mar 15, 2024 (Fri)',
      time: '9:30 AM',
      location: 'Paws & Claws Vet Clinic',
      address: '45 Khyber Pass Road, Auckland',
      type: PetAppointmentType.checkup,
      status: 'Completed',
    ),
  ];

  final List<PetAppointmentData> _cancelledAppointments = const [
    PetAppointmentData(
      id: 'cancelled_001',
      title: 'Grooming Appointment',
      subtitle: 'Basic Wash',
      date: 'Apr 5, 2024 (Fri)',
      time: '3:00 PM',
      location: 'Happy Paws Pet Grooming',
      address: '123 Queen Street, Auckland',
      type: PetAppointmentType.grooming,
      status: 'Cancelled',
    ),
  ];

  List<PetAppointmentData> get _currentAppointments {
    switch (_selectedTab) {
      case 1:
        return _pastAppointments;
      case 2:
        return _cancelledAppointments;
      default:
        return _upcomingAppointments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilterTabs(),
        const SizedBox(height: 12),
        _buildAppointmentList(),

        if (_selectedTab == 0) ...[
          const SizedBox(height: 16),
          _buildManageAppointmentCard(),
        ],
      ],
    );
  }

  Widget _buildFilterTabs() {
    return Row(
      children: List.generate(_tabs.length, (index) {
        final selected = _selectedTab == index;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == _tabs.length - 1 ? 0 : 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFFEAF7EB) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFFDDEFE0)
                        : const Color(0xFFE3E7ED),
                  ),
                ),
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    fontSize: 10,
                    height: 1,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? _green : _textSecondary,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAppointmentList() {
    final appointments = _currentAppointments;

    if (appointments.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: List.generate(appointments.length, (index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == appointments.length - 1 ? 0 : 12,
          ),
          child: _buildAppointmentCard(appointments[index]),
        );
      }),
    );
  }

  Widget _buildAppointmentCard(PetAppointmentData appointment) {
    final style = _getAppointmentStyle(appointment.type);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        widget.onAppointmentTap?.call(appointment.id);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 12,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: style.backgroundColor,
              ),
              child: Icon(style.icon, size: 24, color: style.color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment.title,
                              style: const TextStyle(
                                fontSize: 12,
                                height: 1.2,
                                fontWeight: FontWeight.w700,
                                color: _dark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              appointment.subtitle,
                              style: const TextStyle(
                                fontSize: 10,
                                height: 1.3,
                                fontWeight: FontWeight.w500,
                                color: _textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      _buildStatusBadge(appointment.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSmallInfoIcon(Icons.calendar_month_outlined),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          appointment.date,
                          style: const TextStyle(
                            fontSize: 10,
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                            color: _textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      _buildSmallInfoIcon(Icons.access_time_rounded),
                      const SizedBox(width: 6),
                      Text(
                        appointment.time,
                        style: const TextStyle(
                          fontSize: 10,
                          height: 1.2,
                          fontWeight: FontWeight.w500,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: _buildSmallInfoIcon(Icons.location_on_outlined),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment.location,
                              style: const TextStyle(
                                fontSize: 10,
                                height: 1.3,
                                fontWeight: FontWeight.w500,
                                color: _textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              appointment.address,
                              style: const TextStyle(
                                fontSize: 10,
                                height: 1.3,
                                fontWeight: FontWeight.w500,
                                color: _textSecondary,
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
            const SizedBox(width: 6),
            Padding(
              padding: const EdgeInsets.only(top: 36),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: _textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color background;
    Color foreground;

    switch (status) {
      case 'Completed':
        background = const Color(0xFFEAF7EC);
        foreground = const Color(0xFF15952A);
        break;
      case 'Cancelled':
        background = const Color(0xFFF1F2F5);
        foreground = const Color(0xFF7A8196);
        break;
      default:
        background = const Color(0xFFEDF8EF);
        foreground = const Color(0xFF168C29);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          height: 1,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
    );
  }

  Widget _buildSmallInfoIcon(IconData icon) {
    return Icon(icon, size: 16, color: _textSecondary);
  }

  Widget _buildManageAppointmentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFCFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEF1EE)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFEDF8EF),
            ),
            child: const Icon(
              Icons.event_available_outlined,
              color: _green,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need to change or cancel?',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    color: _dark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'You can reschedule or cancel your appointment up to 24 hours in advance.',
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 44,
            child: OutlinedButton(
              onPressed: widget.onManageAppointments,
              style: OutlinedButton.styleFrom(
                foregroundColor: _green,
                side: const BorderSide(color: _green, width: 1.3),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Manage Appointments',
                style: TextStyle(
                  color: _green,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _softGreen,
            ),
            child: const Icon(
              Icons.calendar_month_outlined,
              color: _green,
              size: 34,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            _selectedTab == 1
                ? 'No past appointments'
                : 'No cancelled appointments',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: _dark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your appointments will appear here.',
            style: TextStyle(fontSize: 14, color: _textSecondary),
          ),
        ],
      ),
    );
  }

  PetAppointmentStyle _getAppointmentStyle(PetAppointmentType type) {
    switch (type) {
      case PetAppointmentType.grooming:
        return const PetAppointmentStyle(
          icon: Icons.content_cut_rounded,
          color: Color(0xFF2FCF69),
          backgroundColor: Color(0xFFEDF9F1),
        );
      case PetAppointmentType.checkup:
        return const PetAppointmentStyle(
          icon: Icons.health_and_safety_outlined,
          color: Color(0xFF2C8DF4),
          backgroundColor: Color(0xFFEEF6FF),
        );
      case PetAppointmentType.vaccination:
        return const PetAppointmentStyle(
          icon: Icons.vaccines_outlined,
          color: Color(0xFF9B3CF2),
          backgroundColor: Color(0xFFF7EEFF),
        );
    }
  }
}
