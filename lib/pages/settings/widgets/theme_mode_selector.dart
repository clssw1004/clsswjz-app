import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme_provider.dart';

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return ListTile(
          leading: Icon(
            Icons.dark_mode,
            color: colorScheme.primary,
          ),
          title: Text(
            '深色模式',
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
                  '跟随系统',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text(
                  '浅色',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text(
                  '深色',
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