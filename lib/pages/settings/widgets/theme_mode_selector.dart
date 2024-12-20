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
    final themeProvider = context.watch<ThemeProvider>();

    return ListTile(
      leading: Icon(
        Icons.brightness_6_outlined,
        color: colorScheme.primary,
      ),
      title: Text(l10n.themeMode),
      trailing: DropdownButton<ThemeMode>(
        value: themeProvider.themeMode,
        onChanged: (ThemeMode? mode) {
          if (mode != null) {
            themeProvider.setThemeMode(mode);
          }
        },
        items: [
          DropdownMenuItem(
            value: ThemeMode.system,
            child: Text(l10n.system),
          ),
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Text(l10n.light),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Text(l10n.dark),
          ),
        ],
      ),
    );
  }
}
