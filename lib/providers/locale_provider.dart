import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/language.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'app_locale';
  Locale _locale = const Locale('zh');

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
      }
    } catch (e) {
      print('加载语言设置失败: $e');
    }
  }

  Future<void> loadSavedLocale() async {
    await _loadSavedLocale();
  }

  Future<void> setLocale(Language language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, language.code);
      _setLocale(language);
    } catch (e) {
      print('保存语言设置失败: $e');
    }
  }

  void _setLocale(Language language) {
    _locale = language.toLocale();
    notifyListeners();
  }
}
