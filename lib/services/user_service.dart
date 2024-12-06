import 'package:flutter/foundation.dart' show kIsWeb;
import '../data/data_source.dart';
import '../data/http/http_data_source.dart';
import 'auth_service.dart';
import '../services/storage_service.dart';
import '../constants/storage_keys.dart';

class UserService {
  static Map<String, dynamic>? _cachedUserInfo;
  static late final HttpDataSource _httpDataSource;

  static void init(DataSource dataSource) {
    _httpDataSource = dataSource as HttpDataSource;
  }

  // 检查是否有有效的会话
  static Future<bool> hasValidSession() async {
    final token = StorageService.getString(StorageKeys.token);
    return token.isNotEmpty;
  }

  // 初始化会话
  static Future<void> initializeSession() async {
    final token = StorageService.getString(StorageKeys.token);
    if (token.isNotEmpty) {
      final userId = StorageService.getString(StorageKeys.userId);
      final username = StorageService.getString(StorageKeys.username);
      
      _cachedUserInfo = {
        'id': userId,
        'username': username,
      };
      
      AuthService.setToken(token);
    }
  }

  // 获取用户信息
  static Map<String, dynamic>? getUserInfo() {
    return _cachedUserInfo;
  }

  // 保存用户会话信息
  static Future<void> saveUserSession(
    String token,
    Map<String, dynamic> userInfo,
  ) async {
    try {
      await StorageService.setString(StorageKeys.token, token);
      await StorageService.setString(StorageKeys.userId, userInfo['id']?.toString() ?? '');
      await StorageService.setString(StorageKeys.username, userInfo['username']?.toString() ?? '');
      
      _cachedUserInfo = userInfo;
      _httpDataSource.setToken(token);
    } catch (e) {
      print('Error saving session: $e');
      rethrow;
    }
  }

  // 获取用户会话信息
  static Future<Map<String, dynamic>?> getUserSession() async {
    try {
      final token = StorageService.getString(StorageKeys.token);
      if (token.isNotEmpty) {
        final userId = StorageService.getString(StorageKeys.userId);
        final username = StorageService.getString(StorageKeys.username);
        
        final sessionData = {
          'token': token,
          'userInfo': {
            'id': userId,
            'username': username,
          }
        };

        _cachedUserInfo = sessionData['userInfo'] as Map<String, dynamic>;
        AuthService.setToken(token);
        return sessionData;
      }
    } catch (e) {
      print('获取用户会话失败: $e');
    }
    return null;
  }

  // 刷新会话
  static Future<void> refreshSession() async {
    try {
      final sessionData = await getUserSession();
      if (sessionData != null) {
        await saveUserSession(
          sessionData['token'],
          sessionData['userInfo'],
        );
      }
    } catch (e) {
      print('刷新会话失败: $e');
    }
  }

  // 退出登录
  static Future<void> logout() async {
    try {
      await StorageService.remove(StorageKeys.token);
      await StorageService.remove(StorageKeys.userId);
      await StorageService.remove(StorageKeys.username);
      
      _cachedUserInfo = null;
      AuthService.clearToken();
    } catch (e) {
      print('退出登录失败: $e');
    }
  }

  // 账本相关方法
  static Future<void> setCurrentAccountBookId(String bookId) async {
    await StorageService.setString(StorageKeys.lastUsedBookId, bookId);
  }

  static String getCurrentAccountBookId({String defaultId = ''}) {
    return StorageService.getString(StorageKeys.lastUsedBookId, defaultValue: defaultId);
  }

  static Future<void> saveToken(String token) async {
    await StorageService.setString(StorageKeys.token, token);
  }

  static String? getToken() {
    return StorageService.getString(StorageKeys.token);
  }

  // 更新缓存的用户信息
  static Future<void> updateUserInfo(Map<String, dynamic> newInfo) async {
    if (_cachedUserInfo != null) {
      _cachedUserInfo = {
        ..._cachedUserInfo!,
        ...newInfo,
      };

      await StorageService.setString(
        StorageKeys.userId, 
        newInfo['id']?.toString() ?? ''
      );
      await StorageService.setString(
        StorageKeys.username, 
        newInfo['username']?.toString() ?? ''
      );
    }
  }

  static void setToken(String token) {
    _httpDataSource.setToken(token);
  }

  static void clearToken() {
    _httpDataSource.clearToken();
  }

  static String? getStoredToken() {
    if (kIsWeb) {
      return StorageService.getString(StorageKeys.token);
    } else {
      // 从缓存获取 token
      final sessionData = _cachedUserInfo;
      return sessionData?['token'];
    }
  }
}
