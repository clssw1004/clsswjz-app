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

  static AppLocalizations of(BuildContext context) {
    final localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    if (localizations == null) {
      // 如果在初始化前访问，返回一个默认值
      return _getDefaultLocalizations();
    }
    return localizations;
  }

  // 提供默认的本地化文本
  static AppLocalizations _getDefaultLocalizations() {
    return lookupAppLocalizations(const Locale('zh', 'CN'));
  }
}
