import '../models/models.dart';
import '../models/server_status.dart';
import 'http/http_method.dart';

class ServerMemory {
  final String heapUsed;
  final String heapTotal;
  final String rss;

  ServerMemory({
    required this.heapUsed,
    required this.heapTotal,
    required this.rss,
  });

  factory ServerMemory.fromJson(Map<String, dynamic> json) => ServerMemory(
        heapUsed: json['heapUsed'],
        heapTotal: json['heapTotal'],
        rss: json['rss'],
      );
}

class DatabaseStatus {
  final String status;

  DatabaseStatus({required this.status});

  factory DatabaseStatus.fromJson(Map<String, dynamic> json) => DatabaseStatus(
        status: json['status'],
      );
}

abstract class DataSource {
  Future<T> request<T>({
    required String path,
    required HttpMethod method,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  });

  // 用户相关方法
  Future<Map<String, dynamic>> getUserInfo();
  Future<Map<String, dynamic>> updateUserInfo(Map<String, dynamic> data);
  Future<String> resetInviteCode();

  // 账本相关
  Future<List<AccountBook>> getAccountBooks();
  Future<AccountBook> createAccountBook(AccountBook book);
  Future<AccountBook> updateAccountBook(String id, AccountBook book);
  Future<void> deleteAccountBook(String id);

  // 账目相关
  Future<AccountItemResponse> getAccountItems(
    String bookId, {
    List<String>? categories,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? shopCodes,
  });
  Future<AccountItem> createAccountItem(AccountItem item);
  Future<AccountItem> updateAccountItem(String id, AccountItem item);
  Future<void> deleteAccountItem(String id);

  // 分类相关
  Future<List<Category>> getCategories(String bookId);
  Future<Category> createCategory(Category category);
  Future<Category> updateCategory(String id, Category category);

  // 商家相关
  Future<List<Shop>> getShops(String bookId);
  Future<Shop> createShop(Shop shop);
  Future<Shop> updateShop(String id, Shop shop);

  // 资金账户相关
  Future<List<AccountBookFund>> getBookFunds(String bookId);
  Future<List<UserFund>> getUserFunds();
  Future<UserFund> createFund(UserFund fund);
  Future<UserFund> updateFund(String id, UserFund fund);

  Future<ServerStatus> serverStatus();

  Future<Map<String, dynamic>?> login({
    required String username,
    required String password,
    bool isLocalStorage = false,
  });

  Future<Map<String, dynamic>?> validateToken(String token);

  Future<void> register({
    required String username,
    required String password,
    required String email,
    String? nickname,
  });

  Future<Map<String, dynamic>?> getUserByInviteCode(String inviteCode);

  // 添加基础 URL 设置方法
  Future<void> setBaseUrl(String url);
}
