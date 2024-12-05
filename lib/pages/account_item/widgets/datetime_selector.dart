import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import '../../../l10n/l10n.dart';
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

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withOpacity(0.5),
                ),
              ),
            ),
            child: TextFormField(
              readOnly: true,
              onTap: () => _selectDate(context),
              controller: TextEditingController(
                text: DateFormat('yyyy-MM-dd').format(selectedDate),
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                labelText: l10n.dateLabel,
                suffixIcon: Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withOpacity(0.5),
                ),
              ),
            ),
            child: TextFormField(
              readOnly: true,
              onTap: () => _selectTime(context),
              controller: TextEditingController(
                text: selectedTime.format(context),
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                labelText: l10n.timeLabel,
                suffixIcon: Icon(
                  Icons.access_time_outlined,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
      ],
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
              onDateTimeChanged: (date) {
                final newDateTime = _combineDateAndTime(date, selectedTime);
                onDateChanged(newDateTime);
              },
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
      if (picked != null) {
        final newDateTime = _combineDateAndTime(picked, selectedTime);
        onDateChanged(newDateTime);
      }
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
              initialDateTime: _combineDateAndTime(selectedDate, selectedTime),
              onDateTimeChanged: (dateTime) {
                final newTime = TimeOfDay(
                  hour: dateTime.hour,
                  minute: dateTime.minute,
                );
                final newDateTime = _combineDateAndTime(selectedDate, newTime);
                onTimeChanged(newTime);
                onDateChanged(newDateTime);
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
      if (picked != null) {
        final newDateTime = _combineDateAndTime(selectedDate, picked);
        onTimeChanged(picked);
        onDateChanged(newDateTime);
      }
    }
  }
}
