import 'package:flutter/material.dart';

class TypeSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const TypeSelector({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => onChanged('支出'),
            style: OutlinedButton.styleFrom(
              backgroundColor: value == '支出' ? colorScheme.primary : colorScheme.surface,
              foregroundColor: value == '支出' ? colorScheme.onPrimary : colorScheme.primary,
              side: BorderSide(
                color: value == '支出' ? colorScheme.primary : colorScheme.outline,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '支出',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () => onChanged('收入'),
            style: OutlinedButton.styleFrom(
              backgroundColor: value == '收入' ? colorScheme.primary : colorScheme.surface,
              foregroundColor: value == '收入' ? colorScheme.onPrimary : colorScheme.primary,
              side: BorderSide(
                color: value == '收入' ? colorScheme.primary : colorScheme.outline,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '收入',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
} 