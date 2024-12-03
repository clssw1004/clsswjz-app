import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CacheManager {
  static const Duration defaultExpiration = Duration(minutes: 5);

  static Future<void> setCache(String key, dynamic data,
      {Duration? expiration}) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'data': data,
      'timestamp': DateTime.now()
          .add(expiration ?? defaultExpiration)
          .millisecondsSinceEpoch,
    };
    await prefs.setString(key, json.encode(cacheData));
  }

  static Future<T?> getCache<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedString = prefs.getString(key);

    if (cachedString == null) return null;

    final cached = json.decode(cachedString);
    final expiration = DateTime.fromMillisecondsSinceEpoch(cached['timestamp']);

    if (DateTime.now().isAfter(expiration)) {
      await prefs.remove(key);
      return null;
    }

    return cached['data'] as T;
  }
}
