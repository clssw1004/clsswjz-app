import 'package:clsswjz/models/account_item_request.dart';

import '../data/data_source.dart';
import '../models/models.dart';
import '../models/server_status.dart';

class BatchDeleteResult {
  final int successCount;
  final List<String>? errors;

  BatchDeleteResult({
    required this.successCount,
    this.errors,
  });

  factory BatchDeleteResult.fromJson(Map<String, dynamic> json) {
    return BatchDeleteResult(
      successCount: json['successCount'] as int,
      errors: (json['errors'] as List<dynamic>?)?.cast<String>(),
    );
  }
}

class ApiService {
  static DataSource? _dataSource;

  static void init(DataSource dataSource) {
    _dataSource = dataSource;
  }

  static DataSource get dataSource {
    if (_dataSource == null) {
      throw Exception('ApiService not initialized');
    }
    return _dataSource!;
  }

  static Future<void> setBaseUrl(String baseUrl) async {
    await dataSource.setBaseUrl(baseUrl);
  }

  static Future<List<AccountBook>> getAccountBooks() {
    return dataSource.getAccountBooks();
  }

  static Future<AccountBook> createAccountBook(AccountBook book) {
    return dataSource.createAccountBook(book);
  }

  static Future<AccountBook> updateAccountBook(String id, AccountBook book) {
    return dataSource.updateAccountBook(id, book);
  }

  static Future<void> deleteAccountBook(String id) {
    return dataSource.deleteAccountBook(id);
  }

  static Future<List<Category>> getCategories(String bookId) {
    return dataSource.getCategories(bookId);
  }

  static Future<Category> createCategory(Category category) {
    return dataSource.createCategory(category);
  }

  static Future<Category> updateCategory(String id, Category category) {
    return dataSource.updateCategory(id, category);
  }

  static Future<AccountItemResponse> getAccountItems(
      AccountItemRequest request) async {
    return dataSource.getAccountItems(request);
  }

  static Future<AccountItem> createAccountItem(AccountItem item) {
    return dataSource.createAccountItem(item);
  }

  static Future<AccountItem> updateAccountItem(String id, AccountItem item) {
    return dataSource.updateAccountItem(id, item);
  }

  static Future<void> deleteAccountItem(String id) {
    return dataSource.deleteAccountItem(id);
  }

  static Future<List<AccountBookFund>> getBookFunds(String bookId) {
    return dataSource.getBookFunds(bookId);
  }

  static Future<List<UserFund>> getUserFunds() {
    return dataSource.getUserFunds();
  }

  static Future<UserFund> createFund(UserFund fund) {
    return dataSource.createFund(fund);
  }

  static Future<UserFund> updateFund(String id, UserFund fund) {
    return dataSource.updateFund(id, fund);
  }

  static Future<List<Shop>> getShops(String bookId) {
    return dataSource.getShops(bookId);
  }

  static Future<Shop> createShop(Shop shop) {
    return dataSource.createShop(shop);
  }

  static Future<Shop> updateShop(String id, Shop shop) {
    return dataSource.updateShop(id, shop);
  }

  static Future<Map<String, dynamic>> getUserInfo() {
    return dataSource.getUserInfo();
  }

  static Future<Map<String, dynamic>> updateUserInfo(
      Map<String, dynamic> data) {
    return dataSource.updateUserInfo(data);
  }

  static Future<String> resetInviteCode() {
    return dataSource.resetInviteCode();
  }

  // 服务器状态相关
  static Future<ServerStatus> checkServerStatus() {
    return dataSource.serverStatus();
  }

  // 用户认证相关
  static Future<void> register({
    required String username,
    required String password,
    required String email,
    String? nickname,
  }) {
    return dataSource.register(
      username: username,
      password: password,
      email: email,
      nickname: nickname,
    );
  }

  static Future<Map<String, dynamic>?> validateToken(String token) {
    return dataSource.validateToken(token);
  }

  static Future<Map<String, dynamic>?> getUserByInviteCode(String inviteCode) {
    return dataSource.getUserByInviteCode(inviteCode);
  }

  static Future<BatchDeleteResult> batchDeleteAccountItems(
    List<String> itemIds,
  ) async {
    return dataSource.batchDeleteAccountItems(itemIds);
  }
}
