import '../models/models.dart';

class AccountItemCache {
  static final Map<String, CacheEntry> _cache = {};
  static const int _maxCacheSize = 50;  // 最大缓存账本数
  static const Duration _maxAge = Duration(seconds: 30);  // 缓存有效期缩短到30秒

  static void cacheItems(String bookId, List<AccountItem> items) {
    _cache[bookId] = CacheEntry(
      items: items,
      timestamp: DateTime.now(),
    );
    _trimCache();
  }

  static List<AccountItem>? getCachedItems(String bookId) {
    final entry = _cache[bookId];
    if (entry == null) return null;
    
    // 检查缓存是否过期
    if (DateTime.now().difference(entry.timestamp) > _maxAge) {
      _cache.remove(bookId);
      return null;
    }
    
    return entry.items;
  }

  static void _trimCache() {
    if (_cache.length > _maxCacheSize) {
      // 按时间戳排序，移除最旧的缓存
      final sortedEntries = _cache.entries.toList()
        ..sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));
      
      final entriesToRemove = sortedEntries.take(_cache.length - _maxCacheSize);
      for (final entry in entriesToRemove) {
        _cache.remove(entry.key);
      }
    }
  }

  static void clearCache() {
    _cache.clear();
  }

  static bool isCacheValid(String bookId) {
    final entry = _cache[bookId];
    if (entry == null) return false;
    
    return DateTime.now().difference(entry.timestamp) <= _maxAge;
  }
}

class CacheEntry {
  final List<AccountItem> items;
  final DateTime timestamp;

  CacheEntry({
    required this.items,
    required this.timestamp,
  });
} 