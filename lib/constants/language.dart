import 'package:flutter/material.dart';

enum Language {
  ZH_CN('zh', '简体中文'),
  ZH_TW('zh_Hant', '繁體中文'),
  EN('en', 'English');

  final String code;
  final String label;
  const Language(this.code, this.label);

  static Language fromCode(String code) {
    switch (code) {
      case 'zh':
      case 'zh_CN':
        return Language.ZH_CN;
      case 'zh_Hant':
      case 'zh_TW':
        return Language.ZH_TW;
      case 'en':
        return Language.EN;
      default:
        return Language.ZH_CN;
    }
  }

  Locale toLocale() {
    switch (this) {
      case Language.ZH_CN:
        return const Locale('zh');
      case Language.ZH_TW:
        return const Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hant',
        );
      case Language.EN:
        return const Locale('en');
    }
  }

  static List<Language> get supportedLanguages => Language.values;
}
