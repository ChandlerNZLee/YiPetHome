// lib/component/appointment/time.dart
import 'package:flutter/material.dart';

import '../../view-models/appointment.dart';

class AppointmentTimeContent extends StatefulWidget {
  final DateTime? selectedDate;
  final List<AppointmentSlotData> slots;
  final AppointmentSlotData? selectedSlot;
  final int duration;
  final String closingTime;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<AppointmentSlotData> onTimeChanged;

  const AppointmentTimeContent({
    super.key,
    required this.selectedDate,
    required this.slots,
    required this.selectedSlot,
    required this.duration,
    required this.closingTime,
    required this.onDateChanged,
    required this.onTimeChanged,
  });

  @override
  State<AppointmentTimeContent> createState() => _AppointmentTimeContentState();
}

class _AppointmentTimeContentState extends State<AppointmentTimeContent> {
  static const Color textPrimary = Color(0xFF17191D);
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    _displayedMonth = widget.selectedDate != null
        ? DateTime(widget.selectedDate!.year, widget.selectedDate!.month)
        : DateTime(now.year, now.month);

    if (widget.selectedDate == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onDateChanged(DateTime(now.year, now.month, now.day));
      });
    }
  }

  void _previousMonth() {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final previousMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month - 1,
    );

    if (previousMonth.isBefore(currentMonth)) {
      return;
    }

    setState(() {
      _displayedMonth = previousMonth;
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  void _selectDate(DateTime date) {
    widget.onDateChanged(date);
  }

  void _selectTime(AppointmentSlotData slot) {
    widget.onTimeChanged(slot);
  }

  void _editSelectedTime() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Select another date or time above'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width * 0.035;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CalendarHeader(
            month: _displayedMonth,
            onPrevious: _previousMonth,
            onNext: _nextMonth,
          ),
          const SizedBox(height: 16),
          _CalendarGrid(
            month: _displayedMonth,
            selectedDate: widget.selectedDate,
            onDateSelected: _selectDate,
          ),
          const SizedBox(height: 16),
          const Text(
            'Available Times',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _TimeGrid(
            slots: widget.slots,
            selectedSlot: widget.selectedSlot,
            onSelected: _selectTime,
          ),
          const SizedBox(height: 24),

          if (widget.selectedDate != null && widget.selectedSlot != null)
            SelectedTimeCard(
              date: widget.selectedDate!,
              slot: widget.selectedSlot!,
              onEdit: _editSelectedTime,
            ),
        ],
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _CalendarHeader({
    required this.month,
    required this.onPrevious,
    required this.onNext,
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
              _monthName(month.month) + ' ${month.year}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF17191D),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onPrevious,
              icon: const Icon(
                Icons.chevron_left_rounded,
                size: 24,
                color: Color(0xFF17191D),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: onNext,
              icon: const Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: Color(0xFF16A52F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _monthName(int month) {
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

    return months[month - 1];
  }
}

class _CalendarGrid extends StatelessWidget {
  final DateTime month;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const _CalendarGrid({
    required this.month,
    required this.selectedDate,
    required this.onDateSelected,
  });

  static const _weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    final days = _buildCalendarDays(month);

    return Column(
      children: [
        Row(
          children: _weekdays.map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF344267),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: days.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            mainAxisSpacing: 8,
            crossAxisSpacing: 4,
          ),
          itemBuilder: (context, index) {
            final item = days[index];
            final selected =
                selectedDate != null &&
                item.date.year == selectedDate!.year &&
                item.date.month == selectedDate!.month &&
                item.date.day == selectedDate!.day;

            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final itemDate = DateTime(
              item.date.year,
              item.date.month,
              item.date.day,
            );
            final disabled = !item.currentMonth || itemDate.isBefore(today);

            return _CalendarDayCell(
              data: item,
              selected: selected,
              disabled: disabled,
              onTap: () {
                if (item.currentMonth) {
                  onDateSelected(item.date);
                }
              },
            );
          },
        ),
      ],
    );
  }

  List<CalendarDayData> _buildCalendarDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final leadingDays = firstDay.weekday % 7;
    final previousMonthLastDay = DateTime(month.year, month.month, 0).day;
    final result = <CalendarDayData>[];

    for (int i = leadingDays - 1; i >= 0; i--) {
      final day = previousMonthLastDay - i;

      result.add(
        CalendarDayData(
          date: DateTime(month.year, month.month - 1, day),
          currentMonth: false,
        ),
      );
    }

    for (int day = 1; day <= lastDay.day; day++) {
      result.add(
        CalendarDayData(
          date: DateTime(month.year, month.month, day),
          currentMonth: true,
        ),
      );
    }
    int nextDay = 1;

    while (result.length % 7 != 0) {
      result.add(
        CalendarDayData(
          date: DateTime(month.year, month.month + 1, nextDay),
          currentMonth: false,
        ),
      );

      nextDay++;
    }

    return result;
  }
}

class _CalendarDayCell extends StatelessWidget {
  final CalendarDayData data;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  const _CalendarDayCell({
    required this.data,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF13A52B) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${data.date.day}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: disabled
                  ? const Color(0xFFBDBDBD)
                  : selected
                  ? Colors.white
                  : const Color(0xFF17191D),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeGrid extends StatelessWidget {
  final List<AppointmentSlotData> slots;
  final AppointmentSlotData? selectedSlot;
  final ValueChanged<AppointmentSlotData> onSelected;

  const _TimeGrid({
    required this.slots,
    required this.selectedSlot,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final width = (constraints.maxWidth - spacing * 2) / 3;

        return Wrap(
          spacing: spacing,
          runSpacing: 12,
          children: slots.map((slot) {
            final utcTime = DateTime.parse(slot.startAt.toString());
            final nzTime = utcTime.toLocal();
            final time =
                '${nzTime.hour.toString().padLeft(2, '0')}:${nzTime.minute.toString().padLeft(2, '0')}';
            final selected = selectedSlot == slot;
            final enabled = slot.available && nzTime.isAfter(DateTime.now());

            return SizedBox(
              width: width,
              height: 44,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: enabled ? () => onSelected(slot) : null,
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: !enabled
                          ? const Color(0xFFF5F5F5)
                          : selected
                          ? const Color(0xFFEAF8ED)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: !enabled
                            ? const Color(0xFFE8E8E8)
                            : selected
                            ? const Color(0xFF16A52F)
                            : const Color(0xFFE4E8E4),
                        width: selected ? 1.6 : 1,
                      ),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: !enabled
                            ? const Color(0xFFBDBDBD)
                            : selected
                            ? const Color(0xFF16A52F)
                            : const Color(0xFF17191D),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class SelectedTimeCard extends StatelessWidget {
  final DateTime date;
  final AppointmentSlotData slot;
  final VoidCallback onEdit;

  const SelectedTimeCard({
    super.key,
    required this.date,
    required this.slot,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final utcTime = DateTime.parse(slot.startAt.toString());
    final nzTime = utcTime.toLocal();
    final time =
        '${nzTime.hour.toString().padLeft(2, '0')}:${nzTime.minute.toString().padLeft(2, '0')}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F9F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFEDF8EE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.schedule_rounded,
              size: 24,
              color: Color(0xFF16A52F),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Time',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF17191D),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_formatDate(date)} at $time',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF17191D),
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.circular(10),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF16A52F),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 24,
                      color: Color(0xFF16A52F),
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

  static String _formatDate(DateTime date) {
    const monthNames = [
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

    return '${monthNames[date.month - 1]} '
        '${date.day}, ${date.year}';
  }
}
