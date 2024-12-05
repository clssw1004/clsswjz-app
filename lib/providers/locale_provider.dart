import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/language.dart';
import '../l10n/l10n.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'app_locale';
  Locale _locale = const Locale('zh', 'CN');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(_localeKey);
      if (savedLocale != null) {
        final language = Language.fromCode(savedLocale);
        _setLocale(language);
      } else {
        _setLocale(Language.ZH_CN);
      }
    } catch (e) {
      print('加载语言设置失败: $e');
      _setLocale(Language.ZH_CN);
    }
  }

  Future<void> loadSavedLocale() async {
    await _loadSavedLocale();
  }

  Future<void> setLocale(Language language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, language.code);
    _setLocale(language);
  }

  void _setLocale(Language language) {
    switch (language) {
      case Language.ZH_CN:
        _locale = const Locale('zh', 'CN');
        break;
      case Language.ZH_TW:
        _locale = const Locale('zh', 'Hant');
        break;
      case Language.EN:
        _locale = const Locale('en');
        break;
    }
    notifyListeners();
  }
}
