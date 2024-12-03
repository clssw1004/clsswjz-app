import 'data_source.dart';
import 'http/http_data_source.dart';
import 'sqlite/sqlite_data_source.dart';
import 'sqlite/database_helper.dart';

enum DataSourceType {
  http,
  sqlite,
}

class DataSourceFactory {
  static final Map<DataSourceType, DataSource> _instances = {};

  static DataSource create(DataSourceType type) {
    // 如果实例已存在，直接返回
    if (_instances.containsKey(type)) {
      print('Reusing existing DataSource instance of type: $type');
      return _instances[type]!;
    }

    // 创建新实例
    late final DataSource instance;
    switch (type) {
      case DataSourceType.http:
        instance = HttpDataSource(baseUrl: 'http://192.168.2.147:3000');
        break;
      case DataSourceType.sqlite:
        instance = SqliteDataSource(DatabaseHelper.instance);
        break;
    }

    // 缓存实例
    _instances[type] = instance;
    print('Created new DataSource instance of type: $type');

    return instance;
  }

  // 清除实例（用于测试或重置）
  static void reset() {
    _instances.clear();
    print('DataSourceFactory reset');
  }

  // 获取当前实例（不创建新的）
  static DataSource? getInstance(DataSourceType type) {
    return _instances[type];
  }
}
