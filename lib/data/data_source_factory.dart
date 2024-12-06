import 'data_source.dart';
import 'http/http_data_source.dart';
import 'sqlite/sqlite_data_source.dart';
import 'sqlite/database_helper.dart';
import '../services/storage_service.dart';
import '../constants/storage_keys.dart';

enum DataSourceType {
  http,
  sqlite,
}

class DataSourceFactory {
  static final Map<DataSourceType, DataSource> _instances = {};

  static Future<DataSource> create(DataSourceType type) async {
    // 如果实例已存在，直接返回
    if (_instances.containsKey(type)) {
      return _instances[type]!;
    }

    late final DataSource instance;
    switch (type) {
      case DataSourceType.http:
        final baseUrl = StorageService.getString(
          StorageKeys.serverUrl,
          defaultValue: 'http://localhost:3000'
        );
        instance = HttpDataSource(baseUrl: baseUrl);
        break;
      case DataSourceType.sqlite:
        instance = SqliteDataSource(DatabaseHelper.instance);
        break;
    }

    _instances[type] = instance;
    return instance;
  }

  // 清除实例（用于测试或重置）
  static void reset() {
    _instances.clear();
  }

  // 获取当前实例（不创建新的）
  static DataSource? getInstance(DataSourceType type) {
    return _instances[type];
  }
}
