import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../constants/storage_keys.dart';
import '../constants/language.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('zh');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final savedLocale = StorageService.getString(
        StorageKeys.locale,
        defaultValue: 'zh'
      );
      final language = Language.fromCode(savedLocale);
      _setLocale(language);
    } catch (e) {
      print('加载语言设置失败: $e');
    }
  }

  Future<void> loadSavedLocale() async {
    await _loadSavedLocale();
  }

  Future<void> setLocale(Language language) async {
    try {
      await StorageService.setString(StorageKeys.locale, language.code);
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
