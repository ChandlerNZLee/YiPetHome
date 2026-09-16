// lib/component/appointment/common.dart
import 'package:flutter/material.dart';

class AppointmentHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const AppointmentHeader({
    super.key,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF17191D),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onBack,
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 24,
                    color: Color(0xFF17191D),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum AppointmentStep { service, groomer, time, confirm }

class AppointmentProgress extends StatelessWidget {
  final AppointmentStep currentStep;

  const AppointmentProgress({super.key, required this.currentStep});

  static const Color _primary = Color(0xFF16A52F);
  static const Color _inactiveBackground = Color(0xFFF2F3F6);
  static const Color _inactiveText = Color(0xFF344267);
  static const Color _lineColor = Color(0xFFD8DDE6);

  static const List<String> _labels = ['Service', 'Groomer', 'Time', 'Confirm'];

  int get _currentIndex => AppointmentStep.values.indexOf(currentStep);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_labels.length * 2 - 1, (index) {
        if (index.isOdd) {
          return const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: _ProgressLine(),
            ),
          );
        }

        final stepIndex = index ~/ 2;

        return _ProgressItem(
          index: stepIndex,
          label: _labels[stepIndex],
          active: stepIndex == _currentIndex,
        );
      }),
    );
  }
}

class _ProgressItem extends StatelessWidget {
  final int index;
  final String label;
  final bool active;

  const _ProgressItem({
    required this.index,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? AppointmentProgress._primary
                : AppointmentProgress._inactiveBackground,
            shape: BoxShape.circle,
          ),
          child: active && index == 0
              ? const Icon(Icons.pets_rounded, size: 16, color: Colors.white)
              : Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: active
                        ? Colors.white
                        : AppointmentProgress._inactiveText,
                  ),
                ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: active ? FontWeight.w700 : FontWeight.w600,
            color: active
                ? AppointmentProgress._primary
                : AppointmentProgress._inactiveText,
          ),
        ),
      ],
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: CustomPaint(painter: _DashedLinePainter()),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppointmentProgress._lineColor
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    const dashWidth = 4.0;
    const dashSpace = 4.0;

    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset((startX + dashWidth).clamp(0, size.width), 0),
        paint,
      );

      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AppointmentBottomBar extends StatelessWidget {
  final double subtotal;
  final int duration;
  final String buttonText;
  final VoidCallback onNext;
  final VoidCallback? onViewDetails;

  const AppointmentBottomBar({
    super.key,
    required this.subtotal,
    required this.duration,
    required this.buttonText,
    required this.onNext,
    this.onViewDetails,
  });

  static const Color _primary = Color(0xFF16A52F);
  static const Color _textPrimary = Color(0xFF17191D);
  static const Color _textSecondary = Color(0xFF344267);
  static const Color _border = Color(0xFFE8ECE8);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding + 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _border)),
        boxShadow: [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(flex: 5, child: _buildPriceSection()),
          const SizedBox(width: 12),
          Expanded(flex: 5, child: _buildNextButton()),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Subtotal',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '\$${subtotal.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 18,
                height: 1,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
              ),
            ),
          ],
        ),

        if (duration != 0) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Flexible(
                child: Text(
                  'Duration: ${duration / 2} h',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _textSecondary,
                  ),
                ),
              ),

              if (onViewDetails != null) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onViewDetails,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View details',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: _primary,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: _primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildNextButton() {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onNext,
        child: Ink(
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF18AD31), Color(0xFF08A629)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  buttonText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
