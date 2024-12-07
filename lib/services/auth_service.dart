import '../data/data_source.dart';
import 'api_config_service.dart';
import 'storage_service.dart';
import 'api_config_manager.dart';
import 'user_service.dart';

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
        final token = response['access_token'] as String?;

        if (token != null) {
          // 保存用户信息
          await StorageService.setString(
              'username', response['username'] as String);
          await StorageService.setString(
              'userId', response['userId'] as String);

          // 设置 token
          await ApiConfigManager.setToken(token);

          // 更新用户信息缓存
          await UserService.updateUserInfo(response);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  static Future<void> logout() async {
    await UserService.logout();
  }
}
