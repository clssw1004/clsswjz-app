import 'dart:convert';
import '../models/server_config.dart';
import '../constants/storage_keys.dart';
import './storage_service.dart';

class ServerConfigService {
  static const String _configsKey = StorageKeys.serverConfigs;
  static const String _selectedConfigKey = StorageKeys.selectedServerId;

  Future<List<ServerConfig>> getConfigs() async {
    final String? jsonStr = StorageService.getString(_configsKey);
    if (jsonStr!.isEmpty) return [];

    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList
        .map((json) => ServerConfig.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveConfigs(List<ServerConfig> configs) async {
    final jsonList = configs.map((config) => config.toJson()).toList();
    await StorageService.setString(_configsKey, json.encode(jsonList));
  }

  Future<void> addConfig(ServerConfig config) async {
    final configs = await getConfigs();
    configs.add(config);
    await saveConfigs(configs);
  }

  Future<void> updateConfig(ServerConfig config) async {
    final configs = await getConfigs();
    final index = configs.indexWhere((c) => c.id == config.id);
    if (index != -1) {
      configs[index] = config;
      await saveConfigs(configs);
    }
  }

  Future<void> deleteConfig(String id) async {
    final configs = await getConfigs();
    configs.removeWhere((config) => config.id == id);
    await saveConfigs(configs);
  }

  Future<ServerConfig?> getSelectedConfig() async {
    final String selectedId = StorageService.getString(_selectedConfigKey);
    if (selectedId.isEmpty) return null;

    final configs = await getConfigs();
    return configs.isEmpty
        ? null
        : configs.firstWhere(
            (config) => config.id == selectedId,
            orElse: () => configs.first,
          );
  }

  Future<void> setSelectedConfig(String id) async {
    await StorageService.setString(_selectedConfigKey, id);
  }
}
