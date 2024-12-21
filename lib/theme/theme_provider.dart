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
    // 亮色主题
    _lightTheme = _createThemeData(_themeColor, Brightness.light);
    // 暗色主题
    _darkTheme = _createThemeData(_themeColor, Brightness.dark);
  }

  ThemeData _createThemeData(Color color, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final baseColorScheme = ColorScheme.fromSeed(
      seedColor: color,
      brightness: brightness,
    );

    // 创建自定义的容器颜色
    final surfaceContainerLowest = isDark
        ? Color.alphaBlend(
            baseColorScheme.primary.withOpacity(0.03), baseColorScheme.surface)
        : Color.alphaBlend(
            baseColorScheme.primary.withOpacity(0.02), baseColorScheme.surface);
    final surfaceContainerLow = isDark
        ? Color.alphaBlend(
            baseColorScheme.primary.withOpacity(0.05), baseColorScheme.surface)
        : Color.alphaBlend(
            baseColorScheme.primary.withOpacity(0.03), baseColorScheme.surface);
    final surfaceContainer = isDark
        ? Color.alphaBlend(
            baseColorScheme.primary.withOpacity(0.08), baseColorScheme.surface)
        : Color.alphaBlend(
            baseColorScheme.primary.withOpacity(0.05), baseColorScheme.surface);
    final surfaceContainerHigh = isDark
        ? Color.alphaBlend(
            baseColorScheme.primary.withOpacity(0.11), baseColorScheme.surface)
        : Color.alphaBlend(
            baseColorScheme.primary.withOpacity(0.08), baseColorScheme.surface);
    final surfaceContainerHighest = isDark
        ? Color.alphaBlend(
            baseColorScheme.primary.withOpacity(0.14), baseColorScheme.surface)
        : Color.alphaBlend(
            baseColorScheme.primary.withOpacity(0.1), baseColorScheme.surface);

    final colorScheme = baseColorScheme.copyWith(
      // 自定义颜色
      tertiary: Color(0xFF43A047), // 收入颜色
      error: Color(0xFFE53935), // 支出颜色
      // 调整容器颜色
      surfaceContainerLowest: surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow,
      surfaceContainer: surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      primaryColor: color,
      brightness: brightness,

      // 背景色
      scaffoldBackgroundColor:
          isDark ? colorScheme.background : colorScheme.surface,

      // 卡片主题
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(0.2),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // 分割线颜色
      dividerColor: colorScheme.outlineVariant.withOpacity(0.2),

      // 文字主题
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        titleMedium: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.3,
        ),
        titleSmall: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.2,
        ),
        bodyLarge: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 16,
          letterSpacing: -0.2,
        ),
        bodyMedium: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 14,
          letterSpacing: -0.15,
        ),
        bodySmall: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 12,
          letterSpacing: -0.1,
        ),
        labelLarge: TextStyle(
          color: colorScheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.1,
        ),
        labelMedium: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.1,
        ),
        labelSmall: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.1,
        ),
      ),

      // 图标主题
      iconTheme: IconThemeData(
        color: colorScheme.onSurfaceVariant,
        size: 24,
      ),

      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1.5,
          ),
        ),
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
        ),
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withOpacity(0.7),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // 对话框主题
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 14,
        ),
      ),

      // 列表瓦片主题
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
        selectedColor: colorScheme.primary,
        selectedTileColor: colorScheme.primaryContainer.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),

      // 底部导航栏主题
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      ),

      // AppBar主题
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurfaceVariant,
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: colorScheme.onSurfaceVariant,
          size: 24,
        ),
      ),

      // 浮动按钮主题
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // OutlinedButton主题
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(
            color: colorScheme.outline.withOpacity(0.5),
            width: 1,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // TextButton主题
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Chip主题
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
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
