import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme_provider.dart';
import '../../../theme/theme_manager.dart';

class ThemeColorSelector extends StatelessWidget {
  const ThemeColorSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Icon(
        Icons.palette,
        color: colorScheme.primary,
      ),
      title: Text(
        '主题颜色',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      onTap: () => _showThemeColorPicker(context),
    );
  }

  void _showThemeColorPicker(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '主题颜色',
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 8),
              Text(
                '选择您喜欢的主题色',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          content: Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: ThemeManager.themeColors.map((color) {
                      final isSelected = color == theme.primaryColor;
                      return InkWell(
                        onTap: () {
                          themeProvider.setThemeColor(color);
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: isSelected
                              ? Icon(Icons.check, color: colorScheme.onPrimary)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
