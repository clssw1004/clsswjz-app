import 'package:clsswjz/models/account_item_request.dart';
import 'package:file_picker/file_picker.dart';

import '../data/data_source.dart';
import '../data/data_source_factory.dart';
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

  static DataSource get ds {
    if (_dataSource == null) {
      throw Exception('ApiService not initialized');
    }
    return _dataSource!;
  }

  static Future<void> setBaseUrl(String baseUrl) async {
    await ds.setBaseUrl(baseUrl);
  }

  static Future<List<AccountBook>> getAccountBooks() {
    return ds.getAccountBooks();
  }

  static Future<AccountBook> createAccountBook(AccountBook book) {
    return ds.createAccountBook(book);
  }

  static Future<AccountBook> updateAccountBook(String id, AccountBook book) {
    return ds.updateAccountBook(id, book);
  }

  static Future<void> deleteAccountBook(String id) {
    return ds.deleteAccountBook(id);
  }

  static Future<List<Category>> getCategories(String bookId) {
    return ds.getCategories(bookId);
  }

  static Future<Category> createCategory(Category category) {
    return ds.createCategory(category);
  }

  static Future<Category> updateCategory(String id, Category category) {
    return ds.updateCategory(id, category);
  }

  static Future<AccountItemResponse> getAccountItems(
      AccountItemRequest request) async {
    return ds.getAccountItems(request);
  }

  static Future<AccountItem> createAccountItem(AccountItem item) {
    return ds.createAccountItem(item);
  }

  static Future<AccountItem> updateAccountItem(String id, AccountItem item) {
    return ds.updateAccountItem(id, item);
  }

  static Future<void> deleteAccountItem(String id) {
    return ds.deleteAccountItem(id);
  }

  static Future<List<AccountBookFund>> getBookFunds(String bookId) {
    return ds.getBookFunds(bookId);
  }

  static Future<List<UserFund>> getUserFunds() {
    return ds.getUserFunds();
  }

  static Future<UserFund> createFund(UserFund fund) {
    return ds.createFund(fund);
  }

  static Future<UserFund> updateFund(String id, UserFund fund) {
    return ds.updateFund(id, fund);
  }

  static Future<List<Shop>> getShops(String bookId) {
    return ds.getShops(bookId);
  }

  static Future<Shop> createShop(Shop shop) {
    return ds.createShop(shop);
  }

  static Future<Shop> updateShop(String id, Shop shop) {
    return ds.updateShop(id, shop);
  }

  static Future<Map<String, dynamic>> getUserInfo() {
    return ds.getUserInfo();
  }

  static Future<Map<String, dynamic>> updateUserInfo(
      Map<String, dynamic> data) {
    return ds.updateUserInfo(data);
  }

  static Future<String> resetInviteCode() {
    return ds.resetInviteCode();
  }

  // 服务器状态相关
  static Future<ServerStatus> checkServerStatus() {
    return ds.serverStatus();
  }

  // 用户认证相关
  static Future<void> register({
    required String username,
    required String password,
    required String email,
    String? nickname,
  }) {
    return ds.register(
      username: username,
      password: password,
      email: email,
      nickname: nickname,
    );
  }

  static Future<Map<String, dynamic>?> validateToken(String token) {
    return ds.validateToken(token);
  }

  static Future<Map<String, dynamic>?> getUserByInviteCode(String inviteCode) {
    return ds.getUserByInviteCode(inviteCode);
  }

  static Future<BatchDeleteResult> batchDeleteAccountItems(
    List<String> itemIds,
  ) async {
    return ds.batchDeleteAccountItems(itemIds);
  }

  /// 导入数据
  static Future<Map<String, dynamic>> importData({
    required String accountBookId,
    required String dataSource,
    required PlatformFile file,
  }) async {
    return await ds.importData(
      accountBookId: accountBookId,
      dataSource: dataSource,
      file: file,
    );
  }
}
