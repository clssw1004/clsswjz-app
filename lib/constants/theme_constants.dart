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
  static const double buttonHeight = 48.0;
  static const double inputHeight = 40.0;
  static const double chipHeight = 32.0;

  // 字体大小
  static const double fontSizeTiny = 12.0;
}
