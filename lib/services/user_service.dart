import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _sessionFileName = 'user_session.json';
  static Map<String, dynamic>? _cachedUserInfo;
  static const String _tokenKey = 'token';
  static const String _userInfoKey = 'userInfo';
  static const String _currentAccountBookKey = 'currentAccountBook';

  // 获取本地存储文件
  static Future<File> get _sessionFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_sessionFileName');
  }

  // 检查是否有有效的会话
  static Future<bool> hasValidSession() async {
    final sessionData = await getUserSession();
    return sessionData != null && sessionData['token'] != null;
  }

  // 初始化会话
  static Future<void> initializeSession() async {
    final sessionData = await getUserSession();
    if (sessionData != null) {
      _cachedUserInfo = sessionData['userInfo'];
      ApiService.setToken(sessionData['token']);
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
    final file = await _sessionFile;
    final sessionData = {
      'token': token,
      'userInfo': userInfo,
    };
    await file.writeAsString(json.encode(sessionData));
    _cachedUserInfo = userInfo;
    ApiService.setToken(token);
  }

  // 获取用户会话信息
  static Future<Map<String, dynamic>?> getUserSession() async {
    try {
      final file = await _sessionFile;
      if (await file.exists()) {
        final sessionData = json.decode(await file.readAsString());
        ApiService.setToken(sessionData['token']);
        _cachedUserInfo = sessionData['userInfo'];
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
      final file = await _sessionFile;
      if (await file.exists()) {
        final sessionData = json.decode(await file.readAsString());
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
      final file = await _sessionFile;
      if (await file.exists()) {
        await file.delete();
      }
      _cachedUserInfo = null;
      ApiService.clearToken(); // 需要在 ApiService 中添加这个方法
    } catch (e) {
      print('退出登录失败: $e');
    }
  }

  // 添加账本相关方法
  static Future<void> setCurrentAccountBookId(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentAccountBookKey, bookId);
  }

  static Future<String?> getCurrentAccountBookId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentAccountBookKey);
  }

  // 更新缓存的用户信息
  static Future<void> updateUserInfo(Map<String, dynamic> newInfo) async {
    if (_cachedUserInfo != null) {
      _cachedUserInfo = {
        ..._cachedUserInfo!,
        ...newInfo,
      };
      // 同时更新本地存储
      final sessionData = await getUserSession();
      if (sessionData != null) {
        sessionData['userInfo'] = _cachedUserInfo;
        final file = await _sessionFile;
        await file.writeAsString(json.encode(sessionData));
      }
    }
  }
}
