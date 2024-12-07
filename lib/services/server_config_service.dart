import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/server_config.dart';

class ServerConfigService {
  static const String _storageKey = 'server_configs';
  final SharedPreferences _prefs;

  ServerConfigService(this._prefs);

  Future<List<ServerConfig>> getConfigs() async {
    final String? jsonStr = _prefs.getString(_storageKey);
    if (jsonStr == null) return [];

    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList
        .map((json) => ServerConfig.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveConfigs(List<ServerConfig> configs) async {
    final jsonList = configs.map((config) => config.toJson()).toList();
    await _prefs.setString(_storageKey, json.encode(jsonList));
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
    final String? selectedId = _prefs.getString('selected_server_id');
    if (selectedId == null) return null;

    final configs = await getConfigs();
    return configs.firstWhere(
      (config) => config.id == selectedId,
      orElse: () => configs.first,
    );
  }

  Future<void> setSelectedConfig(String id) async {
    await _prefs.setString('selected_server_id', id);
  }
} 