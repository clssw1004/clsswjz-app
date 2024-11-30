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
    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: Icon(Icons.calendar_today, color: themeColor, size: 18),
              label: Text(
                DateFormat('yyyy年MM月dd日').format(selectedDate),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.grey[800]!,
                  fontSize: 14,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: themeColor,
                backgroundColor: Colors.transparent,
                side: BorderSide(color: isDark ? Colors.white24 : Colors.grey[300]!),
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
              icon: Icon(Icons.access_time, color: themeColor, size: 18),
              label: Text(
                '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.grey[800]!,
                  fontSize: 14,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: themeColor,
                backgroundColor: Colors.transparent,
                side: BorderSide(color: isDark ? Colors.white24 : Colors.grey[300]!),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColor = Theme.of(context).primaryColor;
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: themeColor,
              onPrimary: Colors.white,
              surface: isDark ? Color(0xFF2C2C2C) : Colors.white,
              onSurface: isDark ? Colors.white : Colors.grey[800]!,
            ),
            dialogBackgroundColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: isDark ? Colors.white70 : themeColor,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeColor = Theme.of(context).primaryColor;
    
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: themeColor,
              onPrimary: Colors.white,
              surface: isDark ? Color(0xFF2C2C2C) : Colors.white,
              onSurface: isDark ? Colors.white : Colors.grey[800]!,
            ),
            dialogBackgroundColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: isDark ? Colors.white70 : themeColor,
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
              hourMinuteColor: isDark ? Colors.white10 : Colors.grey.shade100,
              hourMinuteTextColor: isDark ? Colors.white : Colors.grey[800]!,
              dayPeriodColor: isDark ? Colors.white10 : Colors.grey.shade100,
              dayPeriodTextColor: isDark ? Colors.white : Colors.grey[800]!,
              dialBackgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
              dialHandColor: themeColor,
              dialTextColor: isDark ? Colors.white : Colors.grey[800]!,
              entryModeIconColor: isDark ? Colors.white70 : Colors.grey[600],
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