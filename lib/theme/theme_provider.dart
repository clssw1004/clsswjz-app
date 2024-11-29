import 'package:flutter/material.dart';
import 'theme_manager.dart';

class ThemeProvider extends ChangeNotifier {
  Color _themeColor = Colors.blue;
  bool _isInitialized = false;

  ThemeProvider() {
    loadSavedTheme();
  }

  Color get themeColor => _themeColor;
  bool get isInitialized => _isInitialized;

  Future<void> loadSavedTheme() async {
    _themeColor = await ThemeManager.getThemeColor();
    _isInitialized = true;
    notifyListeners();
  }

  void setThemeColor(Color color) {
    _themeColor = color;
    ThemeManager.setThemeColor(color);
    notifyListeners();
  }
}
