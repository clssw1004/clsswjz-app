import 'package:flutter/material.dart';

class TypeSelectorDialog extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String?> onTypeSelected;

  const TypeSelectorDialog({
    Key? key,
    this.selectedType,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(
        '选择类型',
        style: theme.textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTypeOption(context, null, '全部'),
          _buildTypeOption(context, 'EXPENSE', '支出'),
          _buildTypeOption(context, 'INCOME', '收入'),
        ],
      ),
    );
  }

  Widget _buildTypeOption(BuildContext context, String? type, String label) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = selectedType == type;

    return ListTile(
      selected: isSelected,
      selectedColor: colorScheme.primary,
      selectedTileColor: colorScheme.primaryContainer.withOpacity(0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        ),
      ),
      onTap: () => onTypeSelected(type),
    );
  }
}
