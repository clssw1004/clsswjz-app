import '../models/models.dart';
import 'http/http_method.dart';

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
  Future<List<AccountItem>> getAccountItems(
    String bookId, {
    List<String>? categories,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
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
  Future<List<Fund>> getBookFunds(String bookId);
  Future<List<Fund>> getUserFunds();
  Future<Fund> createFund(Fund fund);
  Future<Fund> updateFund(String id, Fund fund);
}
