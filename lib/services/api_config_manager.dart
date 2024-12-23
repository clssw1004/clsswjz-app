import '../data/http/http_data_source.dart';
import 'api_service.dart';
import 'storage_service.dart';

class ApiConfigManager {
  static String? _token;

  static Future<void> initialize() async {
    final savedToken = StorageService.getString('token');
    await setToken(savedToken);
  }

  static Future<void> setToken(String token) async {
    _token = token;
    await StorageService.setString('token', token);
    if (ApiService.ds is HttpDataSource) {
      (ApiService.ds as HttpDataSource).setToken(token);
    }
  }

  static void clearToken() {
    _token = null;
    StorageService.remove('token');
    if (ApiService.ds is HttpDataSource) {
      (ApiService.ds as HttpDataSource).clearToken();
    }
  }

  static String? get token => _token;
}
