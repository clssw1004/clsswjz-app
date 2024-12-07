import '../data/data_source.dart';
import 'api_config_service.dart';
import 'storage_service.dart';
import 'api_service.dart';

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

      if (response != null && response['access_token'] != null) {
        final token = response['access_token'] as String;
        print('Login success, token: $token'); // 添加调试日志
        
        // 保存用户信息
        await StorageService.setString('token', token);
        await StorageService.setString('username', response['username'] as String);
        await StorageService.setString('userId', response['userId'] as String);
        
        // 设置 token 到 API 服务
        ApiService.setToken(token);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e'); // 添加调试日志
      return false;
    }
  }

  static void setToken(String token) {
    ApiService.setToken(token);
  }

  static void clearToken() {
    ApiService.clearToken();
  }

  static Future<void> logout() async {
    clearToken();
    await StorageService.remove('token');
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
