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

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TypeButton(
            label: '支出',
            isSelected: value == '支出',
            onPressed: () => onChanged('支出'),
            color: Color(0xFFE53935), // Material Red 600
          ),
          _TypeButton(
            label: '收入',
            isSelected: value == '收入',
            onPressed: () => onChanged('收入'),
            color: Color(0xFF43A047), // Material Green 600
          ),
        ],
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;
  final Color color;

  const _TypeButton({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: isSelected ? color : colorScheme.onSurfaceVariant,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              color: isSelected ? color : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
