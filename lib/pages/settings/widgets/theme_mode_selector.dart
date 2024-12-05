import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme_provider.dart';
import '../../../l10n/l10n.dart';

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return ListTile(
          leading: Icon(
            Icons.dark_mode,
            color: colorScheme.primary,
          ),
          title: Text(
            l10n.themeMode,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          trailing: DropdownButton<ThemeMode>(
            value: themeProvider.themeMode,
            underline: SizedBox(),
            dropdownColor: colorScheme.surface,
            items: [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text(
                  l10n.system,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text(
                  l10n.light,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text(
                  l10n.dark,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
            onChanged: (ThemeMode? mode) {
              if (mode != null) {
                themeProvider.setThemeMode(mode);
              }
            },
          ),
        );
      },
    );
  }
}
