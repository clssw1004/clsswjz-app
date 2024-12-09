import '../models/server_config.dart';
import 'api_service.dart';

class ApiConfigService {
  static ServerConfig? _currentConfig;

  static ServerConfig? get currentConfig => _currentConfig;

  static void setConfig(ServerConfig config) {
    _currentConfig = config;

    // 根据服务器类型设置不同的API基础URL
    switch (config.type) {
      case ServerType.selfHosted:
        if (config.serverUrl != null) {
          ApiService.setBaseUrl(config.serverUrl!);
        }
        break;
      case ServerType.clsswjzCloud:
        ApiService.setBaseUrl('https://api.clsswjz.com');
        break;
      case ServerType.localStorage:
        // 本地存储模式不需要设置baseUrl
        break;
    }
  }

  static void clear() {
    _currentConfig = null;
  }

  static bool get isLocalStorage =>
      _currentConfig?.type == ServerType.localStorage;
}
