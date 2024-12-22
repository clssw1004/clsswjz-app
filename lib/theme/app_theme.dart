import 'package:flutter/material.dart';

/// 主题相关常量
class AppDimens {
  // 圆角
  static const double cardRadius = 16.0;
  static const double buttonRadius = 8.0;
  static const double inputRadius = 8.0;
  static const double dialogRadius = 28.0;

  // 间距
  static const double padding = 16.0;
  static const double paddingSmall = 8.0;
  static const double paddingLarge = 24.0;

  // 高度
  static const double buttonHeight = 48.0;
  static const double inputHeight = 48.0;
  static const double appBarHeight = 56.0;

  // 边距
  static const double paddingTiny = 4.0;

  // 圆角
  static const double radius = 12.0;
  static const double radiusSmall = 8.0;
  static const double radiusTiny = 4.0;

  // 高度
  static const double chipHeight = 32.0;

  // 字体大小
  static const double fontSizeTiny = 12.0;

  // 断点
  static const double breakpointMobile = 600;
  static const double breakpointTablet = 900;
  static const double breakpointDesktop = 1200;

  // 对话框
  static const double dialogMaxWidth = 560.0;
  static const double dialogPadding = 24.0;

  // 间距
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;

  // 列表项
  static const double listItemHeight = 56.0;
  static const double listItemPadding = 16.0;

  // 图标
  static const double iconSizeSmall = 18.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;

  // 头像
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 40.0;
  static const double avatarSizeLarge = 48.0;

  // 透明度
  static const double opacityDisabled = 0.38;
  static const double opacityHint = 0.6;
  static const double opacityOverlay = 0.08;

  const AppDimens._();
}

/// 颜色常量
class AppColors {
  // 基础颜色
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  // 功能颜色
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFFA000);
  static const Color info = Color(0xFF1E88E5);

  const AppColors._();
}

/// 主题配置
class AppTheme {
  static ThemeData lightTheme(ColorScheme? colorScheme) {
    final scheme = colorScheme ??
        ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.light,

      // 卡片主题
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
        fillColor: Colors.grey[100],
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

      // 对话框主题
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.dialogRadius),
        ),
      ),

      // ListTile主题
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.listItemPadding,
        ),
        minLeadingWidth: 0,
        minVerticalPadding: 0,
      ),

      // Icon主题
      iconTheme: IconThemeData(
        size: AppDimens.iconSizeMedium,
        color: scheme.onSurface,
      ),

      // Chip主题
      chipTheme: ChipThemeData(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingSmall,
          vertical: AppDimens.paddingTiny,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
        ),
      ),
    );
  }

  static ThemeData darkTheme(ColorScheme? colorScheme) {
    final scheme = colorScheme ??
        ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.dark,

      // 卡片主题
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.cardRadius),
        ),
        clipBehavior: Clip.antiAlias,
        color: const Color(0xFF1E1E1E),
      ),

      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white10,
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

      // 对话框主题
      dialogTheme: DialogTheme(
        backgroundColor: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.dialogRadius),
        ),
      ),

      // ListTile主题
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.listItemPadding,
        ),
        minLeadingWidth: 0,
        minVerticalPadding: 0,
      ),

      // Icon主题
      iconTheme: IconThemeData(
        size: AppDimens.iconSizeMedium,
        color: scheme.onSurface,
      ),

      // Chip主题
      chipTheme: ChipThemeData(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingSmall,
          vertical: AppDimens.paddingTiny,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
        ),
      ),
    );
  }

  const AppTheme._();
}
