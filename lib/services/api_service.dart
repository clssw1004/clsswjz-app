import 'package:clsswjz/models/account_item_request.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
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

  static Future<AccountItem> createAccountItem(AccountItem item,
      [List<File>? attachments]) async {
    return ds.createAccountItem(item, attachments);
  }

  static Future<void> updateAccountItem(String id, AccountItem item,
      [List<File>? attachments]) async {
    await ds.updateAccountItem(
      id,
      item,
      attachments,
    );
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

  static Future<User> getUserInfo() {
    return ds.getUserInfo();
  }

  static Future<User> updateUserInfo(
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

  /// 下载附件
  static Future<File> downloadAttachment(
    String id, {
    void Function(int received, int total)? onProgress,
  }) {
    return ds.downloadAttachment(id, onProgress: onProgress);
  }

  static Future<Map<String, List<AccountSymbol>>> getBookSymbols(
      String bookId) {
    return ds.getBookSymbols(bookId);
  }

  /// 获取账本下指定类型的标识数据
  static Future<List<AccountSymbol>> getBookSymbolsByType(
    String accountBookId,
    String symbolType,
  ) {
    return ds.getBookSymbolsByType(accountBookId, symbolType);
  }

  /// 增加标识数据
  static Future<void> createSymbol(AccountSymbol symbol) {
    return ds.createSymbol(symbol);
  }

  /// 更新标识数据
  static Future<void> updateSymbol(String id, AccountSymbol symbol) {
    return ds.updateSymbol(id, symbol);
  }

  /// 删除标识数据
  static Future<void> deleteSymbol(String id) {
    return ds.deleteSymbol(id);
  }
}
