import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';

/// 本地存储服务
/// 所有需要使用 SharedPreferences 的地方都必须通过这个服务类访问
class StorageService {
  static SharedPreferences? _prefs;
  
  /// 初始化存储服务
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  /// 检查是否已初始化
  static void _checkInit() {
    if (_prefs == null) {
      throw StateError('StorageService has not been initialized');
    }
  }

  // 字符串操作
  static Future<bool> setString(String key, String value) async {
    _checkInit();
    return _prefs!.setString(key, value);
  }
  
  static String getString(String key, {String defaultValue = ''}) {
    _checkInit();
    return _prefs!.getString(key) ?? defaultValue;
  }
  
  // 整数操作
  static Future<bool> setInt(String key, int value) async {
    _checkInit();
    return _prefs!.setInt(key, value);
  }
  
  static int getInt(String key, {int defaultValue = 0}) {
    _checkInit();
    return _prefs!.getInt(key) ?? defaultValue;
  }
  
  // 布尔值操作
  static Future<bool> setBool(String key, bool value) async {
    _checkInit();
    return _prefs!.setBool(key, value);
  }
  
  static bool getBool(String key, {bool defaultValue = false}) {
    _checkInit();
    return _prefs!.getBool(key) ?? defaultValue;
  }
  
  // 删除操作
  static Future<bool> remove(String key) async {
    _checkInit();
    return _prefs!.remove(key);
  }
  
  // 清空所有数据
  static Future<bool> clear() async {
    _checkInit();
    return _prefs!.clear();
  }

  // 主题相关方法
  static Future<bool> saveThemeMode(String mode) async {
    return setString(StorageKeys.themeMode, mode);
  }
  
  static String? getThemeMode({String? defaultMode}) {
    final value = _prefs?.getString(StorageKeys.themeMode);
    return value ?? defaultMode;
  }
  
  static Future<bool> saveThemeColor(String color) async {
    return setString(StorageKeys.themeColor, color);
  }
  
  static String? getThemeColor({String? defaultColor}) {
    final value = _prefs?.getString(StorageKeys.themeColor);
    return value ?? defaultColor;
  }
  
  // 语言相关方法
  static Future<bool> saveLocale(String locale) async {
    return setString(StorageKeys.locale, locale);
  }
  
  static String? getLocale({String? defaultLocale}) {
    final value = _prefs?.getString(StorageKeys.locale);
    return value ?? defaultLocale;
  }
  
  static Future<bool> saveTimezone(String timezone) async {
    return setString(StorageKeys.timezone, timezone);
  }
  
  static String? getTimezone({String? defaultTimezone}) {
    final value = _prefs?.getString(StorageKeys.timezone);
    return value ?? defaultTimezone;
  }
  
  // 服务器相关方法
  static Future<bool> saveServerUrl(String url) async {
    return setString(StorageKeys.serverUrl, url);
  }
  
  static String? getServerUrl({String? defaultUrl}) {
    final value = _prefs?.getString(StorageKeys.serverUrl);
    return value ?? defaultUrl;
  }
  
  // 用户相关方法
  static Future<bool> saveToken(String token) async {
    return setString(StorageKeys.token, token);
  }
  
  static String? getToken({String? defaultToken}) {
    final value = _prefs?.getString(StorageKeys.token);
    return value ?? defaultToken;
  }
  
  static Future<bool> saveUserId(String id) async {
    return setString(StorageKeys.userId, id);
  }
  
  static String? getUserId({String? defaultId}) {
    final value = _prefs?.getString(StorageKeys.userId);
    return value ?? defaultId;
  }
  
  // 账本相关方法
  static Future<bool> saveDefaultBookId(String id) async {
    return setString(StorageKeys.defaultBookId, id);
  }
  
  static String? getDefaultBookId({String? defaultId}) {
    final value = _prefs?.getString(StorageKeys.defaultBookId);
    return value ?? defaultId;
  }
  
  static Future<bool> saveLastUsedBookId(String id) async {
    return setString(StorageKeys.lastUsedBookId, id);
  }
  
  static String? getLastUsedBookId({String? defaultId}) {
    final value = _prefs?.getString(StorageKeys.lastUsedBookId);
    return value ?? defaultId;
  }
} 