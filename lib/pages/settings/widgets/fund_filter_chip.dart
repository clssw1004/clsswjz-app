import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class FundFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const FundFilterChip({
    Key? key,
    required this.label,
    required this.selected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selected)
            Padding(
              padding: EdgeInsets.only(right: 2),
              child: Icon(
                Icons.check,
                size: 10,
                color: colorScheme.onPrimary,
              ),
            ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
              fontSize: AppDimens.fontSizeTiny,
            ),
          ),
        ],
      ),
      selected: selected,
      onSelected: onSelected,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 0,
      ),
      labelPadding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusTiny),
      ),
      selectedColor: colorScheme.primary,
      backgroundColor: colorScheme.surfaceContainerHighest,
      side: BorderSide.none,
      showCheckmark: false,
      avatar: null,
    );
  }
}
