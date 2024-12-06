import 'package:intl/intl.dart';

class AmountFormatter {
  static String format(double amount, [String? locale]) {
    final numberFormat = NumberFormat.compact(locale: locale ?? 'zh');
    
    if (amount.abs() < 1000) {
      return amount.toStringAsFixed(2);
    }
    
    return numberFormat.format(amount);
  }

  static String formatWithSymbol(double amount, String symbol, [String? locale]) {
    // 根据语言环境决定货币符号的位置
    if (locale?.startsWith('zh') ?? true) {
      // 中文环境：¥100
      return '$symbol${format(amount, locale)}';
    } else {
      // 英文环境：$100
      return '$symbol ${format(amount, locale)}';
    }
  }

  static String formatFull(double amount, [String? locale]) {
    // 完整格式，带千位分隔符
    final numberFormat = NumberFormat('#,##0.00', locale ?? 'zh');
    return numberFormat.format(amount);
  }

  static String formatFullWithSymbol(double amount, String symbol, [String? locale]) {
    if (locale?.startsWith('zh') ?? true) {
      return '$symbol${formatFull(amount, locale)}';
    } else {
      return '$symbol ${formatFull(amount, locale)}';
    }
  }
} 