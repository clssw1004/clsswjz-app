import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme_provider.dart';

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return ListTile(
          leading: Icon(Icons.dark_mode),
          title: Text('深色模式'),
          trailing: DropdownButton<ThemeMode>(
            value: themeProvider.themeMode,
            underline: SizedBox(),
            items: [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text('跟随系统'),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text('浅色'),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text('深色'),
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