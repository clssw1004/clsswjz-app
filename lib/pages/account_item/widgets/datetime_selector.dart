import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeSelector extends StatelessWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const DateTimeSelector({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateChanged,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: Icon(Icons.calendar_today,
                  color: colorScheme.primary, size: 18),
              label: Text(
                DateFormat('yyyy年MM月dd日').format(selectedDate),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                backgroundColor: Colors.transparent,
                side: BorderSide(color: colorScheme.outlineVariant),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => _selectDate(context),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              icon:
                  Icon(Icons.access_time, color: colorScheme.primary, size: 18),
              label: Text(
                '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                backgroundColor: Colors.transparent,
                side: BorderSide(color: colorScheme.outlineVariant),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => _selectTime(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: colorScheme,
            dialogBackgroundColor: colorScheme.surface,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateChanged(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: colorScheme,
            timePickerTheme: TimePickerThemeData(
              backgroundColor: colorScheme.surface,
              hourMinuteColor: colorScheme.surfaceContainerHighest,
              hourMinuteTextColor: colorScheme.onSurface,
              dayPeriodColor: colorScheme.surfaceContainerHighest,
              dayPeriodTextColor: colorScheme.onSurface,
              dialBackgroundColor: colorScheme.surfaceContainerHighest,
              dialHandColor: colorScheme.primary,
              dialTextColor: colorScheme.onSurface,
              entryModeIconColor: colorScheme.onSurfaceVariant,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onTimeChanged(picked);
    }
  }
}
