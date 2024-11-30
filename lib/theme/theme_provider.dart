import 'package:flutter/material.dart';
import 'theme_manager.dart';

class ThemeProvider extends ChangeNotifier {
  Color _themeColor = Colors.blue;
  bool _isInitialized = false;
  late ThemeData _themeData;

  ThemeProvider() {
    _themeData = _createThemeData(_themeColor);
    loadSavedTheme();
  }

  Color get themeColor => _themeColor;
  bool get isInitialized => _isInitialized;
  ThemeData get themeData => _themeData;

  ThemeData _createThemeData(Color color) {
    return ThemeData(
      primaryColor: color,
      primarySwatch: _createMaterialColor(color),
      colorScheme: ColorScheme.fromSeed(seedColor: color),
    );
  }

  Future<void> loadSavedTheme() async {
    _themeColor = await ThemeManager.getThemeColor();
    _themeData = _createThemeData(_themeColor);
    _isInitialized = true;
    notifyListeners();
  }

  void setThemeColor(Color color) {
    _themeColor = color;
    _themeData = _createThemeData(color);
    ThemeManager.setThemeColor(color);
    notifyListeners();
  }

  // 辅助方法：将任意Color转换为MaterialColor
  MaterialColor _createMaterialColor(Color color) {
    List<double> strengths = <double>[.05, .1, .2, .3, .4, .5, .6, .7, .8, .9];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 0; i < 10; i++) {
      final double ds = 0.5 - strengths[i];
      swatch[(strengths[i] * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
