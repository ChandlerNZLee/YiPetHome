// lib/page/my/appointments.dart
import 'package:flutter/material.dart';

import '../pet/appointment.dart';

import 'appointments/appointment-detail.dart';

import '../../view-models/my-appointments.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  static const Color background = Color(0xFFFCFDFB);

  AppointmentFilter _filter = AppointmentFilter.all;

  final List<AppointmentListData> _appointments = [
    AppointmentListData(
      id: 'A000123',
      serviceName: 'Luxury Spa Wash',
      date: DateTime(2024, 5, 16),
      time: '2:00 PM',
      duration: 'About 90 mins',
      storeName: 'YiPet Greenlane Store',
      petName: 'Milo',
      petImagePath: 'assets/images/pet/appointment/milo.png',
      groomerName: 'Emily Zhang',
      groomerImagePath: 'assets/images/pet/appointment/groomer_emily.png',
      isSeniorGroomer: true,
      status: AppointmentStatus.upcoming,
    ),
    AppointmentListData(
      id: 'A000124',
      serviceName: 'Full Grooming & Styling',
      date: DateTime(2024, 5, 25),
      time: '10:30 AM',
      duration: 'About 120 mins',
      storeName: 'YiPet Newmarket Store',
      petName: 'Rocky',
      petImagePath: 'assets/images/pet/appointment/rocky.png',
      groomerName: 'Michael Chen',
      groomerImagePath: 'assets/images/pet/appointment/groomer_michael.png',
      isSeniorGroomer: true,
      status: AppointmentStatus.upcoming,
    ),
    AppointmentListData(
      id: 'A000121',
      serviceName: 'Basic Wash',
      date: DateTime(2024, 5, 2),
      time: '11:00 AM',
      duration: 'About 60 mins',
      storeName: 'YiPet Greenlane Store',
      petName: 'Coco',
      petImagePath: 'assets/images/pet/appointment/coco.png',
      status: AppointmentStatus.completed,
    ),
    AppointmentListData(
      id: 'A000120',
      serviceName: 'Nail Trimming',
      date: DateTime(2024, 4, 28),
      time: '3:30 PM',
      duration: 'About 45 mins',
      storeName: 'YiPet Greenlane Store',
      petName: 'Max',
      petImagePath: 'assets/images/pet/appointment/max.png',
      status: AppointmentStatus.cancelled,
    ),
  ];

  List<AppointmentListData> get _filteredAppointments {
    switch (_filter) {
      case AppointmentFilter.all:
        return _appointments;
      case AppointmentFilter.upcoming:
        return _appointments
            .where((item) => item.status == AppointmentStatus.upcoming)
            .toList();
      case AppointmentFilter.completed:
        return _appointments
            .where((item) => item.status == AppointmentStatus.completed)
            .toList();
      case AppointmentFilter.cancelled:
        return _appointments
            .where((item) => item.status == AppointmentStatus.cancelled)
            .toList();
    }
  }

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  void _createAppointment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AppointmentPage()),
    );
  }

  void _openDetails(AppointmentListData appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AppointmentDetailPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width * 0.034;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                8,
                horizontalPadding,
                0,
              ),
              child: AppointmentsHeader(
                onBackTap: _goBack,
                onCreateTap: _createAppointment,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: AppointmentFilterTabs(
                selected: _filter,
                onChanged: (filter) {
                  setState(() {
                    _filter = filter;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredAppointments.isEmpty
                  ? const EmptyAppointmentsView()
                  : ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        0,
                        horizontalPadding,
                        26,
                      ),
                      children: _buildAppointmentSections(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAppointmentSections() {
    if (_filter != AppointmentFilter.all) {
      return _buildSingleSection(_filteredAppointments, _filterTitle(_filter));
    }

    final upcoming = _appointments
        .where((item) => item.status == AppointmentStatus.upcoming)
        .toList();
    final completed = _appointments
        .where((item) => item.status == AppointmentStatus.completed)
        .toList();
    final cancelled = _appointments
        .where((item) => item.status == AppointmentStatus.cancelled)
        .toList();

    return [
      if (upcoming.isNotEmpty) ...[
        const AppointmentSectionTitle(title: 'Upcoming'),
        const SizedBox(height: 8),
        ...upcoming.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: UpcomingAppointmentCard(
              data: item,
              onDetailsTap: () {
                _openDetails(item);
              },
            ),
          ),
        ),
        const SizedBox(height: 4),
      ],

      if (completed.isNotEmpty) ...[
        const AppointmentSectionTitle(title: 'Completed'),
        const SizedBox(height: 8),
        ...completed.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CompactAppointmentCard(
              data: item,
              onTap: () {
                _openDetails(item);
              },
            ),
          ),
        ),
        const SizedBox(height: 4),
      ],

      if (cancelled.isNotEmpty) ...[
        const AppointmentSectionTitle(title: 'Cancelled'),
        const SizedBox(height: 8),
        ...cancelled.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CompactAppointmentCard(
              data: item,
              onTap: () {
                _openDetails(item);
              },
            ),
          ),
        ),
      ],
    ];
  }

  List<Widget> _buildSingleSection(
    List<AppointmentListData> appointments,
    String title,
  ) {
    return [
      AppointmentSectionTitle(title: title),
      const SizedBox(height: 12),
      ...appointments.map((item) {
        final upcoming = item.status == AppointmentStatus.upcoming;

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: upcoming
              ? UpcomingAppointmentCard(
                  data: item,
                  onDetailsTap: () {
                    _openDetails(item);
                  },
                )
              : CompactAppointmentCard(
                  data: item,
                  onTap: () {
                    _openDetails(item);
                  },
                ),
        );
      }),
    ];
  }

  String _filterTitle(AppointmentFilter filter) {
    switch (filter) {
      case AppointmentFilter.all:
        return 'All';
      case AppointmentFilter.upcoming:
        return 'Upcoming';
      case AppointmentFilter.completed:
        return 'Completed';
      case AppointmentFilter.cancelled:
        return 'Cancelled';
    }
  }
}

class AppointmentsHeader extends StatelessWidget {
  final VoidCallback onBackTap;
  final VoidCallback onCreateTap;

  const AppointmentsHeader({
    super.key,
    required this.onBackTap,
    required this.onCreateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Center(
                child: Text(
                  'My Appointments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF18203A),
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
                        color: Color(0xFF121820),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  elevation: 3,
                  shadowColor: const Color(0x16000000),
                  child: InkWell(
                    onTap: onCreateTap,
                    borderRadius: BorderRadius.circular(14),
                    child: const SizedBox(
                      width: 44,
                      height: 44,
                      child: Icon(
                        Icons.calendar_month_outlined,
                        size: 24,
                        color: Color(0xFF16A52F),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'View and manage your pet grooming appointments',
            style: TextStyle(fontSize: 12, color: Color(0xFF405078)),
          ),
        ),
      ],
    );
  }
}

class AppointmentFilterTabs extends StatelessWidget {
  final AppointmentFilter selected;
  final ValueChanged<AppointmentFilter> onChanged;

  const AppointmentFilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      (AppointmentFilter.all, 'All'),
      (AppointmentFilter.upcoming, 'Upcoming'),
      (AppointmentFilter.completed, 'Completed'),
      (AppointmentFilter.cancelled, 'Cancelled'),
    ];

    return Row(
      children: List.generate(items.length, (index) {
        final filter = items[index].$1;
        final label = items[index].$2;
        final active = selected == filter;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == items.length - 1 ? 0 : 12),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {
                  onChanged(filter);
                },
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFFE8F6E7)
                        : const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: active
                          ? const Color(0xFF169C31)
                          : const Color(0xFF405078),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class AppointmentSectionTitle extends StatelessWidget {
  final String title;

  const AppointmentSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF172038),
      ),
    );
  }
}

class UpcomingAppointmentCard extends StatelessWidget {
  final AppointmentListData data;
  final VoidCallback onDetailsTap;

  const UpcomingAppointmentCard({
    super.key,
    required this.data,
    required this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6EAE6)),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppointmentPetImage(
                path: data.petImagePath,
                width: 120,
                height: 120,
                radius: 12,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const AppointmentStatusBadge(
                          status: AppointmentStatus.upcoming,
                        ),
                        const Spacer(),
                        Text(
                          'Appointment #${data.id}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF53617E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.serviceName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF172038),
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppointmentInfoRow(
                      icon: Icons.calendar_month_outlined,
                      text:
                          '${formatAppointmentDate(data.date)} (${weekdayShort(data.date)})',
                    ),
                    const SizedBox(height: 6),
                    AppointmentInfoRow(
                      icon: Icons.schedule_rounded,
                      text: '${data.time}  |  ${data.duration}',
                    ),
                    const SizedBox(height: 6),
                    AppointmentInfoRow(
                      icon: Icons.location_on_outlined,
                      text: data.storeName,
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (data.groomerName != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFBFAFF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: data.groomerImagePath != null
                        ? Image.asset(
                            data.groomerImagePath!,
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return const _AvatarFallback();
                            },
                          )
                        : const _AvatarFallback(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Groomer',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF566489),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data.isSeniorGroomer
                              ? '${data.groomerName} (Senior Groomer)'
                              : data.groomerName!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF172038),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Material(
                    color: const Color(0xFFF3EAFF),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: onDetailsTap,
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'View Details',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF7E35E9),
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 16,
                              color: Color(0xFF7E35E9),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CompactAppointmentCard extends StatelessWidget {
  final AppointmentListData data;
  final VoidCallback onTap;

  const CompactAppointmentCard({
    super.key,
    required this.data,
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
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE6EAE6)),
              ),
              child: Row(
                children: [
                  AppointmentPetImage(
                    path: data.petImagePath,
                    width: 120,
                    height: 120,
                    radius: 12,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AppointmentStatusBadge(status: data.status),
                            const Spacer(),
                            Text(
                              'Appointment #${data.id}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF53617E),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data.serviceName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF172038),
                          ),
                        ),
                        const SizedBox(height: 8),
                        AppointmentInfoRow(
                          icon: Icons.calendar_month_outlined,
                          text:
                              '${formatAppointmentDate(data.date)} (${weekdayShort(data.date)})',
                        ),
                        const SizedBox(height: 8),
                        AppointmentInfoRow(
                          icon: Icons.schedule_rounded,
                          text: '${data.time}  |  ${data.duration}',
                        ),
                        const SizedBox(height: 8),
                        AppointmentInfoRow(
                          icon: Icons.location_on_outlined,
                          text: data.storeName,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 60,
              right: 8,
              child: const Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: Color(0xFF364158),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentStatusBadge extends StatelessWidget {
  final AppointmentStatus status;

  const AppointmentStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late Color background;
    late Color foreground;
    late String text;

    switch (status) {
      case AppointmentStatus.upcoming:
        background = const Color(0xFFF3EAFF);
        foreground = const Color(0xFF7E35E9);
        text = 'Upcoming';
        break;
      case AppointmentStatus.completed:
        background = const Color(0xFFEAF7E8);
        foreground = const Color(0xFF169C31);
        text = 'Completed';
        break;
      case AppointmentStatus.cancelled:
        background = const Color(0xFFF0F1F4);
        foreground = const Color(0xFF687386);
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
    );
  }
}

class AppointmentInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const AppointmentInfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF16A52F)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF53617E),
            ),
          ),
        ),
      ],
    );
  }
}

class AppointmentPetImage extends StatelessWidget {
  final String path;
  final double width;
  final double height;
  final double radius;

  const AppointmentPetImage({
    super.key,
    required this.path,
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        path,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            width: width,
            height: height,
            color: const Color(0xFFF1F5EF),
            alignment: Alignment.center,
            child: const Icon(
              Icons.pets_rounded,
              size: 45,
              color: Color(0xFF16A52F),
            ),
          );
        },
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      color: const Color(0xFFF0F3EF),
      alignment: Alignment.center,
      child: const Icon(Icons.person_rounded, color: Color(0xFFABB1AB)),
    );
  }
}

class EmptyAppointmentsView extends StatelessWidget {
  const EmptyAppointmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 62,
            color: Color(0xFFADB4AE),
          ),
          SizedBox(height: 16),
          Text(
            'No appointments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF17191D),
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Your grooming appointments will appear here.',
            style: TextStyle(fontSize: 13, color: Color(0xFF667085)),
          ),
        ],
      ),
    );
  }
}

String formatAppointmentDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${months[date.month - 1]} '
      '${date.day}, '
      '${date.year}';
}

String weekdayShort(DateTime date) {
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  return weekdays[date.weekday - 1];
}
