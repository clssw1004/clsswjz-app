import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;
import '../data/data_source_factory.dart';
import '../data/http/http_data_source.dart';
import 'auth_service.dart';

class UserService {
  static Database? _database;
  static Map<String, dynamic>? _cachedUserInfo;
  static const String _currentAccountBookKey = 'currentAccountBook';
  static const String _sessionKey = 'user_session';
  static const String _tokenKey = 'auth_token';
  static late final HttpDataSource _httpDataSource;

  static Future<void> init() async {
    _httpDataSource =
        await DataSourceFactory.create(DataSourceType.http) as HttpDataSource;
  }

  // Web 平台的存储实现
  static Future<void> _saveToWeb(Map<String, dynamic> data) async {
    html.window.localStorage[_sessionKey] = jsonEncode(data);
  }

  static Future<Map<String, dynamic>?> _loadFromWeb() async {
    final data = html.window.localStorage[_sessionKey];
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }

  static Future<void> _clearWeb() async {
    html.window.localStorage.remove(_sessionKey);
  }

  // 初始化数据库
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    if (kIsWeb) {
      // Web 平台初始化
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = kIsWeb ? '' : await getDatabasesPath();
    final path = kIsWeb ? 'user_data.db' : join(dbPath, 'user_data.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE user_session(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            token TEXT,
            user_info TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        ''');
      },
    );
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
      AuthService.setToken(sessionData['token']);
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
      print('Saving session - token: $token'); // 添加调试日志

      // 立即设置 token 到 HTTP 客户端
      _httpDataSource.setToken(token);

      if (kIsWeb) {
        await _saveToWeb({
          'token': token,
          'userInfo': userInfo,
        });
      } else {
        final db = await database;
        await db.delete('user_session');
        await db.insert('user_session', {
          'token': token,
          'user_info': jsonEncode(userInfo),
        });
      }

      _cachedUserInfo = userInfo;
    } catch (e) {
      print('Error saving session: $e'); // 添加调试日志
      rethrow;
    }
  }

  // 获取用户会话信息
  static Future<Map<String, dynamic>?> getUserSession() async {
    try {
      if (kIsWeb) {
        final sessionData = await _loadFromWeb();
        if (sessionData != null) {
          AuthService.setToken(sessionData['token']);
          _cachedUserInfo = sessionData['userInfo'];
          return sessionData;
        }
      } else {
        final db = await database;
        final List<Map<String, dynamic>> results = await db.query(
          'user_session',
          orderBy: 'created_at DESC',
          limit: 1,
        );

        if (results.isNotEmpty) {
          final sessionData = {
            'token': results.first['token'],
            'userInfo': jsonDecode(results.first['user_info']),
          };

          AuthService.setToken(sessionData['token']);
          _cachedUserInfo = sessionData['userInfo'];
          return sessionData;
        }
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
      if (kIsWeb) {
        await _clearWeb();
      } else {
        final db = await database;
        await db.delete('user_session');
      }
      _cachedUserInfo = null;
      AuthService.clearToken();
    } catch (e) {
      print('退出登录失败: $e');
    }
  }

  // 账本相关方法保持不变
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

      // 更新数据库中的用户信息
      final sessionData = await getUserSession();
      if (sessionData != null) {
        final db = await database;
        await db.update(
          'user_session',
          {'user_info': jsonEncode(_cachedUserInfo)},
          where: 'token = ?',
          whereArgs: [sessionData['token']],
        );
      }
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
      return html.window.localStorage[_tokenKey];
    } else {
      // 从 SQLite 获取最新的 token
      final sessionData = _cachedUserInfo;
      return sessionData?['token'];
    }
  }
}
