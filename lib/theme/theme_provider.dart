import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../constants/storage_keys.dart';
import '../theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  Color _themeColor = Colors.blue;
  ThemeMode _themeMode = ThemeMode.system;
  bool _isInitialized = false;
  late ThemeData _lightTheme;
  late ThemeData _darkTheme;

  // 添加主题颜色列表
  static final List<Color> themeColors = [
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.deepPurple,
    Colors.pink,
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.yellow,
    Colors.lime,
    Colors.lightGreen,
    Colors.green,
    Colors.teal,
    Colors.cyan,
    Colors.lightBlue,
    Colors.brown,
    Colors.blueGrey,
  ];

  ThemeProvider() {
    _updateThemes();
    loadSavedTheme();
  }

  Color get themeColor => _themeColor;
  ThemeMode get themeMode => _themeMode;
  bool get isInitialized => _isInitialized;
  ThemeData get lightTheme => _lightTheme;
  ThemeData get darkTheme => _darkTheme;

  void _updateThemes() {
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: _themeColor,
      brightness: Brightness.light,
    );

    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: _themeColor,
      brightness: Brightness.dark,
    );

    _lightTheme = AppTheme.lightTheme(lightColorScheme);
    _darkTheme = AppTheme.darkTheme(darkColorScheme);
  }

  Future<void> loadSavedTheme() async {
    final savedMode = StorageService.getString(StorageKeys.themeMode,
        defaultValue: ThemeMode.system.toString());
    _themeMode = ThemeMode.values.firstWhere(
      (mode) => mode.toString() == savedMode,
      orElse: () => ThemeMode.system,
    );

    final savedColor = StorageService.getString(StorageKeys.themeColor,
        defaultValue: Colors.blue.value.toString());
    _themeColor = Color(int.parse(savedColor));

    _updateThemes();
    _isInitialized = true;
    notifyListeners();
  }

  void setThemeColor(Color color) {
    _themeColor = color;
    _updateThemes();
    StorageService.setString(StorageKeys.themeColor, color.value.toString());
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    StorageService.setString(StorageKeys.themeMode, mode.toString());
    notifyListeners();
  }
}
