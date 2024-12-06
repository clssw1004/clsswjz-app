import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../generated/app_localizations.dart';

class L10n {
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('zh', 'CN'), // 简体中文
    Locale('zh', 'Hant'), // 繁体中文
    Locale('en'), // 英文
  ];

  /// 获取默认的语言环境
  static Locale get defaultLocale => const Locale('zh', 'CN');

  static AppLocalizations of(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      throw FlutterError('AppLocalizations 未正确初始化。\n'
          '请确保在 MaterialApp/CupertinoApp 中配置了 localizationsDelegates 和 supportedLocales。');
    }
    return localizations;
  }
}
