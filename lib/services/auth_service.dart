import '../data/data_source.dart';
import 'api_config_service.dart';
import 'storage_service.dart';
import 'api_config_manager.dart';

class AuthService {
  static late final DataSource _dataSource;

  static void init(DataSource dataSource) {
    _dataSource = dataSource;
  }

  static Future<bool> login(String username, String password) async {
    if (ApiConfigService.isLocalStorage) {
      // 本地存储模式的登录逻辑
      final response = await _dataSource.login(
        username: username,
        password: password,
        isLocalStorage: true,
      );
      if (response != null && response['valid'] == true) {
        await StorageService.setString('username', username);
        return true;
      }
      return false;
    }

    // 远程服务器登录逻辑
    try {
      final response = await _dataSource.login(
        username: username,
        password: password,
      );

      if (response != null && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        final token = data['access_token'] as String?;
        
        if (token != null) {
          // 保存用户信息
          await StorageService.setString('username', data['username'] as String);
          await StorageService.setString('userId', data['userId'] as String);
          
          // 设置 token
          await ApiConfigManager.setToken(token);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  static void setToken(String token) {
    ApiConfigManager.setToken(token);
  }

  static void clearToken() {
    ApiConfigManager.clearToken();
  }

  static Future<void> logout() async {
    clearToken();
    await StorageService.remove('username');
  }

  static Future<bool> hasValidSession() async {
    if (ApiConfigService.isLocalStorage) {
      return StorageService.getString('username') != null;
    }
    
    final token = await StorageService.getString('token');
    if (token == null) return false;

    try {
      final response = await _dataSource.validateToken(token);
      return response != null && response['valid'] == true;
    } catch (e) {
      return false;
    }
  }
}
