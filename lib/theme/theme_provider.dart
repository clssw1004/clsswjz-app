import 'package:flutter/material.dart';
import 'theme_manager.dart';

class ThemeProvider extends ChangeNotifier {
  Color _themeColor = Colors.blue;
  ThemeMode _themeMode = ThemeMode.system;
  bool _isInitialized = false;
  late ThemeData _lightTheme;
  late ThemeData _darkTheme;

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
    // 亮色主题
    _lightTheme = _createThemeData(_themeColor, Brightness.light);
    // 暗色主题
    _darkTheme = _createThemeData(_themeColor, Brightness.dark);
  }

  ThemeData _createThemeData(Color color, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: color,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      primaryColor: color,
      brightness: brightness,

      // 背景色
      scaffoldBackgroundColor: isDark ? Color(0xFF121212) : Colors.white,

      // 卡片主题
      cardTheme: CardTheme(
        color: isDark ? Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
      ),

      // 分割线颜色
      dividerColor: isDark ? Colors.white12 : Colors.black12,

      // 文字主题
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: isDark ? Colors.white70 : Colors.black87,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: isDark ? Colors.white60 : Colors.black54,
          fontSize: 14,
        ),
      ),

      // 图标主题
      iconTheme: IconThemeData(
        color: isDark ? Colors.white70 : Colors.black87,
        size: 24,
      ),

      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        fillColor: isDark ? Colors.white10 : Colors.grey[100],
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Colors.white24 : Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Colors.white24 : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: color),
        ),
      ),

      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // 对话框主题
      dialogTheme: DialogTheme(
        backgroundColor: isDark ? Color(0xFF2C2C2C) : Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // 列表瓦片主题
      listTileTheme: ListTileThemeData(
        iconColor: isDark ? Colors.white70 : Colors.black87,
        textColor: isDark ? Colors.white : Colors.black87,
        selectedColor: color,
        selectedTileColor: color.withOpacity(0.1),
      ),

      // 底部导航栏主题
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
        selectedItemColor: color,
        unselectedItemColor: isDark ? Colors.white60 : Colors.black54,
      ),

      // AppBar主题
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? Color(0xFF1E1E1E) : color,
        foregroundColor: isDark ? Colors.white : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.white,
        ),
      ),

      // 按钮主题
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Future<void> loadSavedTheme() async {
    _themeColor = await ThemeManager.getThemeColor();
    _themeMode = await ThemeManager.getThemeMode();
    _updateThemes();
    _isInitialized = true;
    notifyListeners();
  }

  void setThemeColor(Color color) {
    _themeColor = color;
    _updateThemes();
    ThemeManager.setThemeColor(color);
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    ThemeManager.setThemeMode(mode);
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
