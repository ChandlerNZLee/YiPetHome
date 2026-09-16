// lib/component/pet/overview.dart
import 'package:flutter/material.dart';

class PetOverviewContent extends StatelessWidget {
  const PetOverviewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HealthOverviewSection(),
        SizedBox(height: 16),
        UpcomingSection(),
      ],
    );
  }
}

class HealthOverviewSection extends StatelessWidget {
  const HealthOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Health Overview',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: PetColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        HealthInfoCard(
          icon: Icons.monitor_weight_outlined,
          title: 'Weight',
          trailing: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '23.5 kg',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: PetColors.textPrimary,
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Ideal',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: PetColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const HealthInfoCard(
          icon: Icons.accessibility_new_rounded,
          title: 'Body Condition',
          trailing: Text(
            'Good',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: PetColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const HealthScoreOverviewCard(),
      ],
    );
  }
}

class HealthInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;

  const HealthInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PetColors.border),
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
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F8EE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: PetColors.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: PetColors.textPrimary,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class HealthScoreOverviewCard extends StatelessWidget {
  const HealthScoreOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PetColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8EE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.speed_rounded,
                  color: PetColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Health Score',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: PetColors.textPrimary,
                  ),
                ),
              ),
              const Text(
                '92',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: PetColors.textPrimary,
                ),
              ),
              const Text(
                '/100',
                style: TextStyle(fontSize: 12, color: PetColors.textSecondary),
              ),
              const SizedBox(width: 8),
              const Text(
                'Great',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: PetColors.primary,
                ),
              ),
            ],
          ),
          const HealthProgressBar(value: 0.92),
        ],
      ),
    );
  }
}

class HealthProgressBar extends StatelessWidget {
  final double value;

  const HealthProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final progress = value.clamp(0.0, 1.0);

        return Padding(
          padding: EdgeInsets.only(left: 56),
          child: Container(
            height: 10,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE9F2E6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  width: (constraints.maxWidth - 56) * progress,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF20B956), Color(0xFF7ACB73)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class UpcomingSection extends StatelessWidget {
  const UpcomingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: PetColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
          child: const Column(
            children: [
              UpcomingItem(
                icon: Icons.vaccines_outlined,
                title: 'Rabies Vaccine',
                date: 'May 20, 2024',
                status: 'In 5 days',
              ),
              Divider(height: 1, indent: 56, color: PetColors.border),
              UpcomingItem(
                icon: Icons.medical_services_outlined,
                title: 'Vet Check-up',
                date: 'Jun 10, 2024',
                status: 'In 20 days',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class UpcomingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String status;

  const UpcomingItem({
    super.key,
    required this.icon,
    required this.title,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(title),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8EE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: PetColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: PetColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: PetColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: PetColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF858A92),
                size: 24,
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
