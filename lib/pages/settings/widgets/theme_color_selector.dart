import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme_provider.dart';
import '../../../theme/theme_manager.dart';
import '../../../l10n/l10n.dart';

class ThemeColorSelector extends StatelessWidget {
  const ThemeColorSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return ListTile(
          leading: Icon(
            Icons.palette_outlined,
            color: colorScheme.primary,
          ),
          title: Text(
            l10n.themeColor,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          trailing: _buildColorPicker(context, themeProvider),
        );
      },
    );
  }

  Widget _buildColorPicker(BuildContext context, ThemeProvider themeProvider) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return IconButton(
      onPressed: () => _showThemeColorPicker(context, themeProvider),
      icon: Icon(
        Icons.palette,
        color: colorScheme.primary,
      ),
    );
  }

  void _showThemeColorPicker(
      BuildContext context, ThemeProvider themeProvider) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.themeColorTitle,
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 8),
              Text(
                l10n.themeColorSubtitle,
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
