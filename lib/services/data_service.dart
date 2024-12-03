import 'api_service.dart';
import 'package:flutter/material.dart';
import 'user_service.dart';

class DataService {
  // 单例模式
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // 缓存数据
  List<Map<String, dynamic>>? _cachedBooks;
  List<Map<String, dynamic>>? _cachedCategories;

  // 获取账本列表
  Future<List<Map<String, dynamic>>> fetchAccountBooks(
      {bool forceRefresh = false}) async {
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
  Future<List<Map<String, dynamic>>> fetchCategories(
    BuildContext context,
    String accountBookId, {
    bool forceRefresh = false,
  }) async {
    try {
      if (_cachedCategories == null || forceRefresh) {
        _cachedCategories =
            await ApiService.fetchCategories(context, accountBookId);
      }
      return List<Map<String, dynamic>>.from(_cachedCategories ?? []);
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
  Future<Map<String, dynamic>?> getDefaultBook() async {
    if (_cachedBooks?.isEmpty ?? true) return null;

    // 获取保存的账本ID
    final savedBookId = await UserService.getCurrentAccountBookId();
    if (savedBookId != null) {
      // 尝试找到保存的账本
      final savedBook = _cachedBooks!.firstWhere(
        (book) => book['id'] == savedBookId,
        orElse: () => _getFirstOwnedBook() ?? _cachedBooks!.first,
      );
      return savedBook;
    }

    // 如果没有保存的账本ID，返回第一个本人的账本或第一个可用账本
    return _getFirstOwnedBook() ?? _cachedBooks!.first;
  }

  Map<String, dynamic>? _getFirstOwnedBook() {
    final currentUserId = UserService.getUserInfo()?['userId'];
    return _cachedBooks?.firstWhere(
      (book) => book['createdBy'] == currentUserId,
      orElse: () => _cachedBooks!.first,
    );
  }

  Future<List<Map<String, dynamic>>> fetchFundList(String bookId) async {
    try {
      final response = await ApiService.fetchFundList(bookId);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error in fetchFundList: $e');
      return [];
    }
  }

  Future<void> refreshData(BuildContext context) async {
    await Future.wait([
      fetchAccountBooks(forceRefresh: true),
      if (_cachedBooks?.isNotEmpty ?? false)
        fetchCategories(
          context,
          _cachedBooks!.first['id'],
          forceRefresh: true,
        ),
    ]);
  }
}
