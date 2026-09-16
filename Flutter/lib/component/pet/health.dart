// lib/component/pet/health.dart
import 'package:flutter/material.dart';

import '../../view-models/pet.dart';

class PetHealthContent extends StatelessWidget {
  const PetHealthContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Health Overview',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: PetColors.textPrimary,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Track Milo’s health status and key indicators.',
          style: TextStyle(
            fontSize: 10,
            height: 1.4,
            color: PetColors.textSecondary,
          ),
        ),
        SizedBox(height: 16),
        HealthScoreDashboard(),
        SizedBox(height: 16),
        HealthIndicatorsHeader(),
        SizedBox(height: 12),
        HealthIndicatorGrid(),
        SizedBox(height: 16),
        RecentHealthInsights(),
      ],
    );
  }
}

class HealthScoreDashboard extends StatelessWidget {
  const HealthScoreDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCF5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1EEDD)),
      ),
      child: Row(
        children: [
          // Left
          const Expanded(
            flex: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Health Score',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: PetColors.textSecondary,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '92',
                      style: TextStyle(
                        fontSize: 32,
                        height: 1,
                        fontWeight: FontWeight.w700,
                        color: PetColors.primary,
                      ),
                    ),
                    SizedBox(width: 4),
                    Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Text(
                        '/100',
                        style: TextStyle(
                          fontSize: 12,
                          color: PetColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                HealthStatusPill(label: 'Great'),
                SizedBox(height: 8),
                Text(
                  'Milo is in great health!',
                  style: TextStyle(
                    fontSize: 10,
                    color: PetColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 40,
            child: SizedBox(height: 160, child: HealthScoreRing(value: 0.92)),
          ),
          Expanded(
            flex: 40,
            child: Column(
              children: [
                HealthScoreDetailRow(
                  icon: Icons.event_available_outlined,
                  title: 'Last updated',
                  value: 'May 16, 2024',
                ),
                Divider(height: 16, color: PetColors.border),
                HealthScoreDetailRow(
                  icon: Icons.bar_chart_rounded,
                  title: 'Compared to last month',
                  value: '↗ 5 points',
                ),
                Divider(height: 16, color: PetColors.border),
                HealthScoreDetailRow(
                  icon: Icons.medical_services_outlined,
                  title: 'Next check-up',
                  value: 'May 20, 2024',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HealthStatusPill extends StatelessWidget {
  final String label;

  const HealthStatusPill({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7E7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: PetColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class HealthScoreRing extends StatelessWidget {
  final double value;

  const HealthScoreRing({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HealthScoreRingPainter(value: value),
      child: Center(
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: PetColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.monitor_heart_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class HealthScoreRingPainter extends CustomPainter {
  final double value;

  HealthScoreRingPainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 10;
    final track = Paint()
      ..color = const Color(0xFFD9EEE0)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final progress = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF7BD17E), Color(0xFF22C55E), Color(0xFF169B35)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      6.28318 * value.clamp(0.0, 1.0),
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(covariant HealthScoreRingPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}

class HealthScoreDetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const HealthScoreDetailRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: PetColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 9,
                  color: PetColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: value.startsWith('↗')
                      ? PetColors.primary
                      : PetColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HealthIndicatorsHeader extends StatelessWidget {
  const HealthIndicatorsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Key Health Indicators',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: PetColors.textPrimary,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: const Text(
            'See Details',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: PetColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class HealthIndicatorGrid extends StatelessWidget {
  const HealthIndicatorGrid({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      HealthIndicatorData(
        title: 'Weight',
        value: '23.5 kg',
        status: 'Ideal',
        icon: Icons.monitor_weight_outlined,
        iconColor: Color(0xFF22C55E),
        background: Color(0xFFF0F8ED),
        type: HealthIndicatorType.line,
      ),
      HealthIndicatorData(
        title: 'Body Condition',
        value: '4 / 5',
        status: 'Good',
        icon: Icons.pets_rounded,
        iconColor: Color(0xFF3FAD52),
        background: Color(0xFFF0F8ED),
        type: HealthIndicatorType.slider,
      ),

      HealthIndicatorData(
        title: 'Activity Level',
        value: 'High',
        status: 'Active',
        icon: Icons.directions_run_rounded,
        iconColor: Color(0xFF40B856),
        background: Color(0xFFF0F8ED),
        type: HealthIndicatorType.bar,
      ),
      HealthIndicatorData(
        title: 'Hydration',
        value: 'Good',
        status: 'Good',
        icon: Icons.water_drop_rounded,
        iconColor: Color(0xFF3187F5),
        background: Color(0xFFEDF5FF),
        type: HealthIndicatorType.slider,
      ),
      HealthIndicatorData(
        title: 'Nutrition',
        value: 'Good',
        status: 'Good',
        icon: Icons.rice_bowl_rounded,
        iconColor: Color(0xFFFF941F),
        background: Color(0xFFFFF4E8),
        type: HealthIndicatorType.slider,
      ),
      HealthIndicatorData(
        title: 'Dental Health',
        value: 'Good',
        status: 'Good',
        icon: Icons.health_and_safety_rounded,
        iconColor: Color(0xFF9B42D3),
        background: Color(0xFFF8EEFF),
        type: HealthIndicatorType.slider,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        return HealthIndicatorCard(data: items[index]);
      },
    );
  }
}

class HealthIndicatorCard extends StatelessWidget {
  final HealthIndicatorData data;

  const HealthIndicatorCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PetColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: data.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(data.icon, size: 24, color: data.iconColor),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  data.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.15,
                    fontWeight: FontWeight.w600,
                    color: PetColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            data.value,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 12,
              height: 1.1,
              fontWeight: FontWeight.w800,
              color: PetColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7E7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              data.status,
              style: const TextStyle(
                color: PetColors.primary,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 28,
            child: HealthIndicatorChart(type: data.type, color: data.iconColor),
          ),
        ],
      ),
    );
  }
}

class HealthIndicatorChart extends StatelessWidget {
  final HealthIndicatorType type;
  final Color color;

  const HealthIndicatorChart({
    super.key,
    required this.type,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case HealthIndicatorType.line:
        return SizedBox(
          height: 26,
          child: CustomPaint(painter: MiniLineChartPainter(color: color)),
        );
      case HealthIndicatorType.bar:
        return SizedBox(
          height: 27,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(14, (index) {
              const values = [
                11.0,
                20.0,
                28.0,
                24.0,
                30.0,
                23.0,
                18.0,
                14.0,
                19.0,
                12.0,
                8.0,
                13.0,
                17.0,
                14.0,
              ];

              return Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 3,
                    height: values[index],
                    color: color.withValues(alpha: 0.55 + index * 0.015),
                  ),
                ),
              );
            }),
          ),
        );
      case HealthIndicatorType.slider:
        return HealthMiniSlider(color: color);
    }
  }
}

class HealthMiniSlider extends StatelessWidget {
  final Color color;

  const HealthMiniSlider({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 4,
                width: width,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                height: 4,
                width: width * 0.78,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Positioned(
                left: width * 0.75,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MiniLineChartPainter extends CustomPainter {
  final Color color;

  MiniLineChartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final points = [
      Offset(0, size.height * 0.74),
      Offset(size.width * 0.25, size.height * 0.70),
      Offset(size.width * 0.48, size.height * 0.52),
      Offset(size.width * 0.72, size.height * 0.72),
      Offset(size.width, size.height * 0.15),
    ];

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()..moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final dotBorderPaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final point in points) {
      canvas.drawCircle(point, 3, dotPaint);
      canvas.drawCircle(point, 3, dotBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant MiniLineChartPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class RecentHealthInsights extends StatelessWidget {
  const RecentHealthInsights({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(17, 17, 16, 17),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8EE),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 44,
            height: 44,
            child: Icon(Icons.pets_rounded, size: 44, color: PetColors.primary),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Health Insights',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: PetColors.textPrimary,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Milo’s activity has increased and his\n'
                  'weight is in the ideal range.',
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.45,
                    color: PetColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: PetColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              side: const BorderSide(color: Color(0xFFB8DFB4)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View Insights',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 4),
                Icon(Icons.chevron_right_rounded, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
