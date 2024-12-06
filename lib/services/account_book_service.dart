import '../services/storage_service.dart';
import '../constants/storage_keys.dart';

class AccountBookService {
  static Future<void> setDefaultBookId(String id) async {
    await StorageService.setString(StorageKeys.defaultBookId, id);
  }

  static String getDefaultBookId({String defaultId = ''}) {
    return StorageService.getString(StorageKeys.defaultBookId, defaultValue: defaultId);
  }

  static Future<void> setLastUsedBookId(String id) async {
    await StorageService.setString(StorageKeys.lastUsedBookId, id);
  }

  static String getLastUsedBookId({String defaultId = ''}) {
    return StorageService.getString(StorageKeys.lastUsedBookId, defaultValue: defaultId);
  }
} 