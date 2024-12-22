import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/theme_provider.dart';

class ThemeColorSelector extends StatelessWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorSelected;

  const ThemeColorSelector({
    super.key,
    required this.currentColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: ThemeProvider.themeColors.map((color) {
        final isSelected = color.value == currentColor.value;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onColorSelected(color),
            borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? colorScheme.primary : Colors.transparent,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: color.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white,
                    )
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
