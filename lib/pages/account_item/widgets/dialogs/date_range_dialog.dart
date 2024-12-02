import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeDialog extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?) onStartDateChanged;
  final Function(DateTime?) onEndDateChanged;

  const DateRangeDialog({
    Key? key,
    this.startDate,
    this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
  }) : super(key: key);

  @override
  State<DateRangeDialog> createState() => _DateRangeDialogState();
}

class _DateRangeDialogState extends State<DateRangeDialog> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(
        '日期范围',
        style: theme.textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('开始日期'),
            subtitle: Text(
              _startDate != null
                  ? DateFormat('yyyy-MM-dd').format(_startDate!)
                  : '未选择',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _startDate != null
                    ? colorScheme.onSurface
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Icon(Icons.calendar_today, size: 20),
            onTap: () => _selectDate(context, true),
          ),
          Divider(height: 1),
          ListTile(
            title: Text('结束日期'),
            subtitle: Text(
              _endDate != null
                  ? DateFormat('yyyy-MM-dd').format(_endDate!)
                  : '未选择',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _endDate != null
                    ? colorScheme.onSurface
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Icon(Icons.calendar_today, size: 20),
            onTap: () => _selectDate(context, false),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onStartDateChanged(null);
            widget.onEndDateChanged(null);
            Navigator.pop(context);
          },
          child: Text(
            '清除',
            style: TextStyle(color: colorScheme.error),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            widget.onStartDateChanged(_startDate);
            widget.onEndDateChanged(_endDate);
            Navigator.pop(context);
          },
          child: Text('确定'),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final initialDate = isStart ? _startDate : _endDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          // 如果结束日期早于开始日期，清除结束日期
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
          // 如果开始日期晚于结束日期，清除开始日期
          if (_startDate != null && _startDate!.isAfter(picked)) {
            _startDate = null;
          }
        }
      });
    }
  }
}
