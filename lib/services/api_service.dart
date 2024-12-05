import '../data/http/api_endpoints.dart';
import '../data/http/http_method.dart';
import '../models/models.dart';
import '../data/data_source_factory.dart';
import '../data/data_source.dart';

class ApiService {
  static final DataSource _dataSource =
      DataSourceFactory.create(DataSourceType.http);

  // 账本相关
  static Future<List<AccountBook>> getAccountBooks() {
    return _dataSource.getAccountBooks();
  }

  static Future<AccountBook> createAccountBook(AccountBook book) {
    return _dataSource.createAccountBook(book);
  }

  static Future<AccountBook> updateAccountBook(String id, AccountBook book) {
    return _dataSource.updateAccountBook(id, book);
  }

  static Future<void> deleteAccountBook(String id) {
    return _dataSource.deleteAccountBook(id);
  }

  // 账目相关
  static Future<AccountItemResponse> getAccountItems(
    String bookId, {
    List<String>? categories,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _dataSource.getAccountItems(
      bookId,
      categories: categories,
      type: type,
      startDate: startDate,
      endDate: endDate,
    );
  }

  static Future<AccountItem> createAccountItem(AccountItem item) {
    return _dataSource.createAccountItem(item);
  }

  static Future<AccountItem> updateAccountItem(String id, AccountItem item) {
    return _dataSource.updateAccountItem(id, item);
  }

  static Future<void> deleteAccountItem(String id) {
    return _dataSource.deleteAccountItem(id);
  }

  // 分类相关
  static Future<List<Category>> getCategories(String bookId) {
    return _dataSource.getCategories(bookId);
  }

  static Future<Category> createCategory(Category category) {
    return _dataSource.createCategory(category);
  }

  static Future<Category> updateCategory(String id, Category category) {
    return _dataSource.updateCategory(id, category);
  }

  // 商家相关
  static Future<List<Shop>> getShops(String bookId) {
    return _dataSource.getShops(bookId);
  }

  static Future<Shop> createShop(Shop shop) {
    return _dataSource.createShop(shop);
  }

  static Future<Shop> updateShop(String id, Shop shop) {
    return _dataSource.updateShop(id, shop);
  }

  // 资金账户相关
  static Future<List<AccountBookFund>> getBookFunds(String bookId) {
    return _dataSource.getBookFunds(bookId);
  }

  static Future<UserFund> createFund(UserFund fund) {
    return _dataSource.createFund(fund);
  }

  static Future<UserFund> updateFund(String id, UserFund fund) {
    return _dataSource.updateFund(id, fund);
  }

  static Future<List<UserFund>> getUserFunds() {
    return _dataSource.getUserFunds();
  }

  // 用户相关
  static Future<Map<String, dynamic>> getUserByInviteCode(
      String inviteCode) async {
    final response = await _dataSource.request<Map<String, dynamic>>(
      path: '${ApiEndpoints.users}/invite/$inviteCode',
      method: HttpMethod.get,
    );
    return response;
  }

  static Future<void> register({
    required String username,
    required String password,
    required String email,
    String? nickname,
  }) async {
    await _dataSource.request<void>(
      path: '${ApiEndpoints.auth}/register',
      method: HttpMethod.post,
      data: {
        'username': username,
        'password': password,
        'email': email,
        if (nickname != null) 'nickname': nickname,
      },
    );
  }

  static Future<Map<String, dynamic>> getUserInfo() {
    return _dataSource.getUserInfo();
  }

  static Future<Map<String, dynamic>> updateUserInfo(
      Map<String, dynamic> data) {
    return _dataSource.updateUserInfo(data);
  }

  static Future<String> resetInviteCode() {
    return _dataSource.resetInviteCode();
  }
}
