import 'package:clsswjz/models/models.dart';

import 'api_service.dart';
import 'storage_service.dart';
import 'api_config_manager.dart';
import '../constants/storage_keys.dart';

class UserService {
  static User? _userInfo;
  static bool _initialized = false;
  static String? _currentAccountBookId;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    _currentAccountBookId = StorageService.getString(StorageKeys.currentBookId);
  }

  static Future<bool> initializeSession() async {
    final hasSession = await hasValidSession();
    if (hasSession) {
      _userInfo = await ApiService.getUserInfo();
    }
    return hasSession;
  }

  static Future<bool> hasValidSession() async {
    final token = StorageService.getString(StorageKeys.token);

    try {
      final response = await ApiService.validateToken(token);
      return response != null && response['valid'] == true;
    } catch (e) {
      return false;
    }
  }

  static User? getUserInfo() => _userInfo;

  static Future<void> updateUserInfo(User info) async {
    _userInfo = _userInfo?.copyWith(
      nickname: info.nickname,
      email: info.email,
      phone: info.phone,
    );
  }

  static Future<void> logout() async {
    _userInfo = null;
    _currentAccountBookId = null;
    ApiConfigManager.clearToken();
    await StorageService.remove(StorageKeys.token);
    await StorageService.remove(StorageKeys.username);
    await StorageService.remove(StorageKeys.currentBookId);
  }

  static String? getCurrentAccountBookId() {
    return _currentAccountBookId;
  }

  static Future<void> setCurrentAccountBookId(String? bookId) async {
    _currentAccountBookId = bookId;
    if (bookId != null) {
      await StorageService.setString(StorageKeys.currentBookId, bookId);
    } else {
      await StorageService.remove(StorageKeys.currentBookId);
    }
  }
}
