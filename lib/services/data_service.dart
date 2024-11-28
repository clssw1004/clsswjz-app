import 'api_service.dart';

class DataService {
  // 单例模式
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // 缓存数据
  List<Map<String, dynamic>>? _cachedBooks;
  List<String>? _cachedCategories;
  
  // 获取账本列表
  Future<List<Map<String, dynamic>>> fetchAccountBooks({bool forceRefresh = false}) async {
    try {
      if (_cachedBooks == null || forceRefresh) {
        _cachedBooks = await ApiService.fetchAccountBooks();
      }
      return _cachedBooks ?? [];
    } catch (e) {
      print('加载账本失败: $e');
      rethrow;
    }
  }

  // 获取分类列表
  Future<List<String>> fetchCategories(String accountBookId, {bool forceRefresh = false}) async {
    try {
      if (_cachedCategories == null || forceRefresh) {
        _cachedCategories = await ApiService.fetchCategories(accountBookId);
      }
      return _cachedCategories ?? [];
    } catch (e) {
      print('获取分类失败: $e');
      rethrow;
    }
  }

  // 清除缓存
  void clearCache() {
    _cachedBooks = null;
    _cachedCategories = null;
  }

  // 获取默认账本
  Map<String, dynamic>? getDefaultBook() {
    return _cachedBooks?.isNotEmpty == true ? _cachedBooks!.first : null;
  }
} 