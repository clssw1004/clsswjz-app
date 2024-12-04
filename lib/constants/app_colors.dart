import 'package:flutter/material.dart';

/// 应用程序颜色常量
/// 注意：这里只定义非主题相关的颜色值
/// 主题相关的颜色应该从 Theme.of(context).colorScheme 中获取
class AppColors {
  // 收支类型颜色
  static const expense = Color(0xFFE53935); // Material Red 600
  static const income = Color(0xFF43A047); // Material Green 600

  // 状态颜色
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFA726);
  static const error = Color(0xFFEF5350);
  static const info = Color(0xFF42A5F5);

  // 禁止直接实例化
  AppColors._();
}
