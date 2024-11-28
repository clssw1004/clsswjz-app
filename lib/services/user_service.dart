import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'api_service.dart';

class UserService {
  static const String _sessionFileName = 'user_session.json';

  // 获取本地存储文件
  static Future<File> get _sessionFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_sessionFileName');
  }

  // 保存用户会话信息
  static Future<void> saveUserSession(
    String token,
    Map<String, dynamic> userInfo,
  ) async {
    final sessionData = {
      'token': token,
      'userInfo': userInfo,
      'timestamp': DateTime.now().toIso8601String(),
    };

    final file = await _sessionFile;
    await file.writeAsString(json.encode(sessionData));
  }

  // 检查会话是否有效
  static Future<bool> hasValidSession() async {
    try {
      final file = await _sessionFile;
      if (!await file.exists()) {
        return false;
      }

      final sessionData = json.decode(await file.readAsString());
      final timestamp = DateTime.parse(sessionData['timestamp']);
      final now = DateTime.now();

      // 检查会话是否过期（例如30天）
      if (now.difference(timestamp).inDays > 30) {
        await clearSession();
        return false;
      }

      return sessionData['token'] != null;
    } catch (e) {
      print('检查会话状态失败: $e');
      return false;
    }
  }

  // 获取用户信息
  static Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      final file = await _sessionFile;
      if (!await file.exists()) {
        return null;
      }

      final sessionData = json.decode(await file.readAsString());
      return sessionData['userInfo'];
    } catch (e) {
      print('获取用户信息失败: $e');
      return null;
    }
  }

  // 清除会话
  static Future<void> clearSession() async {
    try {
      final file = await _sessionFile;
      if (await file.exists()) {
        await file.delete();
      }
      ApiService.clearToken();
    } catch (e) {
      print('清除会话失败: $e');
    }
  }

  // 初始化会话
  static Future<void> initializeSession() async {
    try {
      final file = await _sessionFile;
      if (await file.exists()) {
        final sessionData = json.decode(await file.readAsString());
        final token = sessionData['token'];
        if (token != null) {
          ApiService.setToken(token);

          // 更新会话时间戳
          await saveUserSession(
            token,
            sessionData['userInfo'],
          );
        }
      }
    } catch (e) {
      print('初始化会话失败: $e');
    }
  }

  // 刷新会话时间戳
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
}
