import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

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
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _DateButton(
              date: selectedDate,
              onPressed: () => _selectDate(context),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _TimeButton(
              time: selectedTime,
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

    if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (context) => Container(
          height: 216,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: selectedDate,
              onDateTimeChanged: onDateChanged,
              minimumDate: DateTime(2000),
              maximumDate: DateTime(2100),
            ),
          ),
        ),
      );
    } else {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: theme.copyWith(
              colorScheme: colorScheme,
              dialogBackgroundColor: colorScheme.surface,
              dialogTheme: DialogTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 3,
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) onDateChanged(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (context) => Container(
          height: 216,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              ),
              onDateTimeChanged: (dateTime) {
                onTimeChanged(TimeOfDay(
                  hour: dateTime.hour,
                  minute: dateTime.minute,
                ));
              },
            ),
          ),
        ),
      );
    } else {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (context, child) {
          return Theme(
            data: theme.copyWith(
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) onTimeChanged(picked);
    }
  }
}

class _DateButton extends StatelessWidget {
  final DateTime date;
  final VoidCallback onPressed;

  const _DateButton({
    Key? key,
    required this.date,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 18),
          SizedBox(width: 8),
          Text(
            DateFormat('yyyy-MM-dd').format(date),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeButton extends StatelessWidget {
  final TimeOfDay time;
  final VoidCallback onPressed;

  const _TimeButton({
    Key? key,
    required this.time,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.access_time, size: 18),
          SizedBox(width: 8),
          Text(
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
