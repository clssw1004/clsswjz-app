import '../../models/account_item_request.dart';
import '../../models/server_status.dart';
import '../../services/api_service.dart';
import '../data_source.dart';
import '../../models/models.dart';
import 'database_helper.dart';
import '../http/http_method.dart';
import '../../services/api_config_service.dart';

class SqliteDataSource implements DataSource {
  final DatabaseHelper _dbHelper;

  SqliteDataSource(this._dbHelper);

  @override
  Future<List<AccountBook>> getAccountBooks() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('account_books');

    // 获取每个账本的成员
    return Future.wait(maps.map((bookMap) async {
      final memberMaps = await db.query(
        'members',
        where: 'account_book_id = ?',
        whereArgs: [bookMap['id']],
      );

      final members = memberMaps
          .map((m) => Member.fromJson({
                'userId': m['user_id'],
                'nickname': m['nickname'],
                'canViewBook': m['can_view_book'] == 1,
                'canEditBook': m['can_edit_book'] == 1,
                'canDeleteBook': m['can_delete_book'] == 1,
                'canViewItem': m['can_view_item'] == 1,
                'canEditItem': m['can_edit_item'] == 1,
                'canDeleteItem': m['can_delete_item'] == 1,
              }))
          .toList();

      return AccountBook.fromJson({
        ...bookMap,
        'members': members,
      });
    }));
  }

  // 账本相关方法
  @override
  Future<AccountBook> createAccountBook(AccountBook book) async {
    final db = await _dbHelper.database;
    await db.insert('account_books', {
      'id': book.id,
      'name': book.name,
      'description': book.description,
      'currency_symbol': book.currencySymbol,
      'icon': book.icon,
      'created_by': book.createdBy,
      'created_at': book.createdAt?.toIso8601String(),
      'updated_at': book.updatedAt?.toIso8601String(),
    });
    return book;
  }

  @override
  Future<AccountBook> updateAccountBook(String id, AccountBook book) async {
    final db = await _dbHelper.database;
    await db.update(
      'account_books',
      {
        'name': book.name,
        'description': book.description,
        'currency_symbol': book.currencySymbol,
        'icon': book.icon,
        'updated_at': book.updatedAt?.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    return book;
  }

  @override
  Future<void> deleteAccountBook(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'account_books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 账目相关方法
  @override
  Future<AccountItemResponse> getAccountItems(
      AccountItemRequest request) async {
    return AccountItemResponse(
      items: [],
      summary: AccountSummary(
          allIn: 347117.44, allOut: 233180.36, allBalance: 113937.08),
      pagination: Pagination(
        isLastPage: true,
        current: 1,
        pageSize: 10,
        total: 100,
        totalPage: 10,
      ),
    );
  }

  @override
  Future<AccountItem> createAccountItem(AccountItem item) async {
    final db = await _dbHelper.database;
    await db.insert('account_items', {
      'id': item.id,
      'account_book_id': item.accountBookId,
      'type': item.type,
      'amount': item.amount,
      'category': item.category,
      'description': item.description,
      'shop': item.shop,
      'fund_id': item.fundId,
      'account_date': item.accountDate.toIso8601String(),
      'created_at': item.createdAt?.toIso8601String(),
      'updated_at': item.updatedAt?.toIso8601String(),
    });
    return item;
  }

  @override
  Future<AccountItem> updateAccountItem(String id, AccountItem item) async {
    final db = await _dbHelper.database;
    await db.update(
      'account_items',
      {
        'account_book_id': item.accountBookId,
        'type': item.type,
        'amount': item.amount,
        'category': item.category,
        'description': item.description,
        'shop': item.shop,
        'fund_id': item.fundId,
        'account_date': item.accountDate.toIso8601String(),
        'updated_at': item.updatedAt?.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    return item;
  }

  @override
  Future<void> deleteAccountItem(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'account_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 分类相关方法
  @override
  Future<List<Category>> getCategories(String bookId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'account_book_id = ?',
      whereArgs: [bookId],
      orderBy: 'name ASC',
    );
    return maps
        .map((map) => Category.fromJson({
              'id': map['id'],
              'name': map['name'],
              'accountBookId': map['account_book_id'],
              'createdAt': map['created_at'],
              'updatedAt': map['updated_at'],
            }))
        .toList();
  }

  @override
  Future<Category> createCategory(Category category) async {
    final db = await _dbHelper.database;
    await db.insert('categories', {
      'id': category.id,
      'name': category.name,
      'account_book_id': category.accountBookId,
      'created_at': category.createdAt?.toIso8601String(),
      'updated_at': category.updatedAt?.toIso8601String(),
    });
    return category;
  }

  @override
  Future<Category> updateCategory(String id, Category category) async {
    final db = await _dbHelper.database;
    await db.update(
      'categories',
      {
        'name': category.name,
        'updated_at': category.updatedAt?.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    return category;
  }

  @override
  Future<void> deleteCategory(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 商家相关方法
  @override
  Future<List<Shop>> getShops(String bookId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'shops',
      where: 'account_book_id = ?',
      whereArgs: [bookId],
      orderBy: 'name ASC',
    );
    return maps
        .map((map) => Shop.fromJson({
              'id': map['id'],
              'name': map['name'],
              'accountBookId': map['account_book_id'],
              'createdAt': map['created_at'],
              'updatedAt': map['updated_at'],
            }))
        .toList();
  }

  @override
  Future<Shop> createShop(Shop shop) async {
    final db = await _dbHelper.database;
    await db.insert('shops', {
      'id': shop.id,
      'name': shop.name,
      'account_book_id': shop.accountBookId,
      'created_at': shop.createdAt?.toIso8601String(),
      'updated_at': shop.updatedAt?.toIso8601String(),
    });
    return shop;
  }

  @override
  Future<Shop> updateShop(String id, Shop shop) async {
    final db = await _dbHelper.database;
    await db.update(
      'shops',
      {
        'name': shop.name,
        'updated_at': shop.updatedAt?.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    return shop;
  }

  @override
  Future<void> deleteShop(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'shops',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 资金账户相关方法
  @override
  Future<List<AccountBookFund>> getBookFunds(String bookId) async {
    final db = await _dbHelper.database;

    // 获取账本信息
    final bookMap = await db.query(
      'account_books',
      where: 'id = ?',
      whereArgs: [bookId],
      limit: 1,
    );
    final bookName = bookMap.isNotEmpty ? bookMap.first['name'] as String : '';

    final List<Map<String, dynamic>> maps = await db.query(
      'funds',
      where: 'account_book_id = ?',
      whereArgs: [bookId],
      orderBy: 'name ASC',
    );

    return maps
        .map((map) => AccountBookFund(
              id: map['id'],
              name: map['name'],
              fundType: map['type'],
              fundRemark: map['remark'] ?? '',
              fundBalance: map['balance'],
              fundIn: map['fund_in'] == 1,
              fundOut: map['fund_out'] == 1,
              isDefault: map['is_default'] == 1,
              accountBookName: bookName,
              createdBy: map['created_by'],
              updatedBy: map['updated_by'],
              createdAt: map['created_at'] != null
                  ? DateTime.parse(map['created_at'])
                  : null,
              updatedAt: map['updated_at'] != null
                  ? DateTime.parse(map['updated_at'])
                  : null,
            ))
        .toList();
  }

  @override
  Future<UserFund> createFund(UserFund fund) async {
    final db = await _dbHelper.database;
    final fundBook = fund.fundBooks.first; // 假设至少有一个账本关联
    await db.insert('funds', {
      'id': fund.id,
      'name': fund.name,
      'type': fund.fundType,
      'remark': fund.fundRemark,
      'balance': fund.fundBalance,
      'account_book_id': fundBook.accountBookId,
      'is_default': fundBook.isDefault ? 1 : 0,
      'fund_in': fundBook.fundIn ? 1 : 0,
      'fund_out': fundBook.fundOut ? 1 : 0,
      'created_by': fund.createdBy,
      'updated_by': fund.updatedBy,
      'created_at': fund.createdAt?.toIso8601String(),
      'updated_at': fund.updatedAt?.toIso8601String(),
    });
    return fund;
  }

  @override
  Future<UserFund> updateFund(String id, UserFund fund) async {
    final db = await _dbHelper.database;
    final fundBook = fund.fundBooks.first; // 假设至少有一个账本关联
    await db.update(
      'funds',
      {
        'name': fund.name,
        'type': fund.fundType,
        'remark': fund.fundRemark,
        'balance': fund.fundBalance,
        'is_default': fundBook.isDefault ? 1 : 0,
        'fund_in': fundBook.fundIn ? 1 : 0,
        'fund_out': fundBook.fundOut ? 1 : 0,
        'updated_by': fund.updatedBy,
        'updated_at': fund.updatedAt?.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    return fund;
  }

  @override
  Future<void> deleteFund(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'funds',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<T> request<T>({
    required String path,
    required HttpMethod method,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) {
    throw UnimplementedError('SQLite does not support HTTP requests');
  }

  @override
  Future<Map<String, dynamic>> getUserInfo() async {
    throw UnimplementedError('SQLite does not support user operations');
  }

  @override
  Future<Map<String, dynamic>> updateUserInfo(Map<String, dynamic> data) async {
    throw UnimplementedError('SQLite does not support user operations');
  }

  @override
  Future<String> resetInviteCode() async {
    throw UnimplementedError('SQLite does not support user operations');
  }

  @override
  Future<List<UserFund>> getUserFunds() async {
    final db = await _dbHelper.database;

    // 获取所有资金账户
    final List<Map<String, dynamic>> fundMaps = await db.query('funds');

    // 获取账本信息
    final List<Map<String, dynamic>> bookMaps = await db.query('account_books');
    final bookNameMap = {for (var book in bookMaps) book['id']: book['name']};

    return fundMaps
        .map((map) => UserFund.fromJson({
              'id': map['id'],
              'name': map['name'],
              'fundType': map['type'],
              'fundRemark': map['remark'] ?? '',
              'fundBalance': map['balance'],
              'fundBooks': [
                {
                  'accountBookId': map['account_book_id'],
                  'accountBookName': bookNameMap[map['account_book_id']] ?? '',
                  'fundIn': map['fund_in'] == 1,
                  'fundOut': map['fund_out'] == 1,
                  'isDefault': map['is_default'] == 1,
                }
              ],
              'createdBy': map['created_by'],
              'updatedBy': map['updated_by'],
              'createdAt': map['created_at'],
              'updatedAt': map['updated_at'],
            }))
        .toList();
  }

  @override
  Future<ServerStatus> serverStatus() {
    throw UnimplementedError('SQLite does not support server status check');
  }

  @override
  Future<Map<String, dynamic>?> login({
    required String username,
    required String password,
    bool isLocalStorage = false,
  }) async {
    if (isLocalStorage) {
      // 本地存储模式下，只需验证用户是否存在
      final db = await _dbHelper.database;
      final result = await db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );

      return result.isNotEmpty ? {'valid': true} : null;
    }

    // 远程服务器模式的实现...
    return null;
  }

  @override
  Future<Map<String, dynamic>?> validateToken(String token) async {
    if (ApiConfigService.isLocalStorage) {
      // 本地存储模式下，token 验证始终返回有效
      return {'valid': true};
    }
    return null;
  }

  @override
  Future<void> register({
    required String username,
    required String password,
    required String email,
    String? nickname,
  }) async {
    throw UnimplementedError('SQLite does not support user registration');
  }

  @override
  Future<Map<String, dynamic>?> getUserByInviteCode(String inviteCode) async {
    throw UnimplementedError('SQLite does not support invite code');
  }

  @override
  Future<void> setBaseUrl(String url) async {
    // SQLite 数据源不需要设置 URL
    return;
  }

  @override
  Future<BatchDeleteResult> batchDeleteAccountItems(
      List<String> itemIds) async {
    final db = await _dbHelper.database;
    int successCount = 0;
    List<String> errors = [];

    for (final id in itemIds) {
      try {
        final count = await db.delete(
          'account_items',
          where: 'id = ?',
          whereArgs: [id],
        );
        if (count > 0) {
          successCount++;
        } else {
          errors.add('账目不存在: $id');
        }
      } catch (e) {
        errors.add('删除失败: $id - ${e.toString()}');
      }
    }

    return BatchDeleteResult(
      successCount: successCount,
      errors: errors.isEmpty ? null : errors,
    );
  }

  @override
  Future<void> importData(
      {required String accountBookId,
      required String dataSource,
      required file}) {
    // TODO: implement importData
    throw UnimplementedError();
  }
}
