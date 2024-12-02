import 'package:shared_preferences/shared_preferences.dart';

class RunModeUtil {
  static const String _runModeKey = 'runMode';
  static const String debugMode = 'debug';
  static const String productMode = 'product';

  // 获取当前运行模式
  static Future<String> getRunMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_runModeKey) ?? productMode;
  }

  // 设置运行模式
  static Future<void> setRunMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_runModeKey, mode);
  }

  // 判断是否为调试模式
  static Future<bool> isDebugMode() async {
    return await getRunMode() == debugMode;
  }
}
