import 'package:flutter/material.dart';

/// 定义应用中使用的所有非主题相关的颜色常量
class AppColors {
  // 禁止实例化
  AppColors._();

  static const transparent = Colors.transparent;
  static const white = Colors.white;
}

/// 定义应用中使用的所有尺寸常量
class AppDimens {
  AppDimens._();

  // 边距
  static const double padding = 16.0;
  static const double paddingSmall = 8.0;
  static const double paddingTiny = 4.0;

  // 圆角
  static const double radius = 12.0;
  static const double radiusSmall = 8.0;
  static const double radiusTiny = 4.0;

  // 高度
  static const double inputHeight = 40.0;
  static const double chipHeight = 32.0;

  // 字体大小
  static const double fontSizeTiny = 12.0;

  // 断点
  static const double breakpointMobile = 600;
  static const double breakpointTablet = 900;
  static const double breakpointDesktop = 1200;

  // 对话框
  static const double dialogRadius = 28.0;
  static const double dialogMaxWidth = 560.0;
  static const double dialogPadding = 24.0;

  // 输入框
  static const double inputRadius = 12.0;

  // 按钮
  static const double buttonRadius = 20.0;
  static const double buttonHeight = 40.0;

  // 卡片
  static const double cardRadius = 12.0;

  // 间距
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
}
