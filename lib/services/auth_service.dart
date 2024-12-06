import '../data/data_source_factory.dart';
import '../data/http/http_data_source.dart';

class AuthService {
  static late final HttpDataSource _dataSource;

  static Future<void> init() async {
    _dataSource = await DataSourceFactory.create(DataSourceType.http) as HttpDataSource;
  }

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    try {
      final response = await _dataSource.login(username, password);
      print('Login response raw: $response'); // 添加日志

      final token = response['access_token'] as String?;
      if (token == null || token.isEmpty) {
        throw Exception('Invalid token received');
      }

      // 确保在这里设置 token
      _dataSource.setToken(token);
      print('Token set in AuthService: $token'); // 添加日志

      return {
        'token': token,
        'userInfo': {
          'userId': response['userId'],
          'username': response['username'],
          'nickname': response['nickname'],
          'email': response['email'],
        },
      };
    } catch (e) {
      print('Login error in AuthService: $e'); // 添加日志
      rethrow;
    }
  }

  static void setToken(String token) {
    print('Setting token in AuthService: $token'); // 添加日志
    _dataSource.setToken(token);
  }

  static void clearToken() {
    print('Clearing token in AuthService'); // 添加日志
    _dataSource.clearToken();
  }
}
