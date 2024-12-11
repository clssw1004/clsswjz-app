import 'api_service.dart';
import 'storage_service.dart';
import 'api_config_manager.dart';
import '../constants/storage_keys.dart';

class UserService {
  static Map<String, dynamic>? _userInfo;
  static bool _initialized = false;
  static String? _currentAccountBookId;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    _currentAccountBookId = StorageService.getString(StorageKeys.currentBookId);
  }

  static Future<void> initializeSession() async {
    final hasSession = await hasValidSession();
    if (hasSession) {
      _userInfo = await ApiService.getUserInfo();
    }
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

  static Map<String, dynamic>? getUserInfo() => _userInfo;

  static Future<void> updateUserInfo(Map<String, dynamic> info) async {
    _userInfo = info;
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
