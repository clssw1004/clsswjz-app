/// 存储键常量
/// 所有使用 SharedPreferences 的键都必须在这里定义
class StorageKeys {
  // 主题相关
  static const String themeMode = 'theme_mode';
  static const String themeColor = 'theme_color';
  
  // 语言相关
  static const String locale = 'locale';
  static const String timezone = 'timezone';
  
  // 服务器相关
  static const String serverUrl = 'server_url';
  
  // 用户相关
  static const String token = 'token';
  static const String userId = 'user_id';
  static const String username = 'username';
  
  // 账本相关
  static const String defaultBookId = 'default_book_id';
  static const String lastUsedBookId = 'last_used_book_id';

  // 会话相关
  static const String session = 'user_session';
  static const String sessionToken = 'session_token';
  static const String sessionUserInfo = 'session_user_info';
  static const String sessionExpiry = 'session_expiry';

  // 当前账本相关
  static const String currentBookId = 'current_book_id';
  static const String currentBookName = 'current_book_name';

  // 禁止实例化
  StorageKeys._();
} 