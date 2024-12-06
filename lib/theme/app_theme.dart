import 'package:flutter/material.dart';
import '../constants/theme_constants.dart';

class AppTheme {
  static ThemeData lightTheme(ColorScheme? colorScheme) {
    final defaultColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    );
    
    final scheme = colorScheme ?? defaultColorScheme;
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      
      // Card主题
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.cardRadius),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.inputRadius),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.padding,
          vertical: AppDimens.paddingSmall,
        ),
      ),
      
      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppDimens.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
          ),
        ),
      ),
      
      // Dialog主题
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.dialogRadius),
        ),
      ),
    );
  }

  static ThemeData darkTheme(ColorScheme? colorScheme) {
    final defaultColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    );
    
    final scheme = colorScheme ?? defaultColorScheme;
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      // 继承lightTheme的其他配置...
    );
  }
}
