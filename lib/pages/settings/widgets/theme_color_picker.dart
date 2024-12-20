import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme_provider.dart';
import '../../../l10n/l10n.dart';
import 'theme_color_selector.dart';

class ThemeColorPicker extends StatelessWidget {
  const ThemeColorPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);
    final themeProvider = context.watch<ThemeProvider>();

    return ListTile(
      leading: Icon(
        Icons.palette_outlined,
        color: colorScheme.primary,
      ),
      title: Text(l10n.themeColor),
      trailing: IconButton(
        onPressed: () => _showThemeColorPicker(context, themeProvider),
        icon: Icon(
          Icons.palette,
          color: themeProvider.themeColor,
        ),
      ),
    );
  }

  void _showThemeColorPicker(BuildContext context, ThemeProvider themeProvider) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.themeColorTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.themeColorSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              ThemeColorSelector(
                currentColor: themeProvider.themeColor,
                onColorSelected: (color) {
                  themeProvider.setThemeColor(color);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }
} 