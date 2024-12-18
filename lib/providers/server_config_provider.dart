import 'package:flutter/foundation.dart';
import '../models/server_config.dart';
import '../services/server_config_service.dart';
import '../services/api_config_service.dart';

class ServerConfigProvider extends ChangeNotifier {
  final ServerConfigService _service;
  List<ServerConfig> _configs = [];
  ServerConfig? _selectedConfig;
  bool _isLoading = true;

  ServerConfigProvider(this._service) {
    _loadConfigs();
  }

  List<ServerConfig> get configs => List.unmodifiable(_configs);
  ServerConfig? get selectedConfig => _selectedConfig;
  set selectedConfig(ServerConfig? value) => _selectedConfig = value;
  bool get isLoading => _isLoading;

  Future<void> _loadConfigs() async {
    _isLoading = true;
    notifyListeners();

    _configs = await _service.getConfigs();
    _selectedConfig = await _service.getSelectedConfig();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addConfig(ServerConfig config) async {
    await _service.addConfig(config);
    await _loadConfigs();
  }

  Future<void> updateConfig(ServerConfig config) async {
    final index = _configs.indexWhere((c) => c.id == config.id);
    if (index != -1) {
      _configs[index] = config;
      notifyListeners();
      await _service.saveConfigs(_configs);
      
      // 如果更新的是当前选中的配置，也更新selectedConfig
      if (_selectedConfig?.id == config.id) {
        _selectedConfig = config;
      }
    }
  }

  Future<void> deleteConfig(String id) async {
    await _service.deleteConfig(id);
    await _loadConfigs();
  }

  Future<void> selectConfig(String id) async {
    await _service.setSelectedConfig(id);
    _selectedConfig = _configs.firstWhere((config) => config.id == id);
    ApiConfigService.setConfig(_selectedConfig!);
    notifyListeners();
  }

  Future<void> saveCredentials(
    String serverId, 
    String username, 
    String password,
  ) async {
    final config = _configs.firstWhere((c) => c.id == serverId);
    final updatedConfig = config.copyWith(
      savedUsername: username,
      savedPassword: password,
    );
    await updateConfig(updatedConfig);
  }

  Future<void> clearCredentials(String serverId) async {
    final config = _configs.firstWhere((c) => c.id == serverId);
    final updatedConfig = config.copyWith(
      savedUsername: null,
      savedPassword: null,
    );
    await updateConfig(updatedConfig);
  }
} 