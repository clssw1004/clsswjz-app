import '../data_source.dart';
import '../../models/models.dart';
import 'database_helper.dart';
import '../http/http_method.dart';

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
    await db.transaction((txn) async {
      // 插入账本
      await txn.insert(
        'account_books',
        {
          'id': book.id,
          'name': book.name,
          'description': book.description,
          'currency_symbol': book.currencySymbol,
          'icon': book.icon,
          'created_by': book.createdBy,
          'created_at': book.createdAt.toIso8601String(),
          'updated_at': book.updatedAt.toIso8601String(),
        },
      );

      // 插入成员
      for (var member in book.members) {
        await txn.insert(
          'members',
          {
            'user_id': member.userId,
            'account_book_id': book.id,
            'nickname': member.nickname,
            'can_view_book': member.canViewBook ? 1 : 0,
            'can_edit_book': member.canEditBook ? 1 : 0,
            'can_delete_book': member.canDeleteBook ? 1 : 0,
            'can_view_item': member.canViewItem ? 1 : 0,
            'can_edit_item': member.canEditItem ? 1 : 0,
            'can_delete_item': member.canDeleteItem ? 1 : 0,
          },
        );
      }
    });

    return book;
  }

  @override
  Future<AccountBook> updateAccountBook(String id, AccountBook book) async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      // 更新账本
      await txn.update(
        'account_books',
        {
          'name': book.name,
          'description': book.description,
          'currency_symbol': book.currencySymbol,
          'icon': book.icon,
          'updated_at': book.updatedAt.toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id],
      );

      // 删除旧成员
      await txn.delete(
        'members',
        where: 'account_book_id = ?',
        whereArgs: [id],
      );

      // 插入新成员
      for (var member in book.members) {
        await txn.insert('members', {
          'user_id': member.userId,
          'account_book_id': id,
          'nickname': member.nickname,
          'can_view_book': member.canViewBook ? 1 : 0,
          'can_edit_book': member.canEditBook ? 1 : 0,
          'can_delete_book': member.canDeleteBook ? 1 : 0,
          'can_view_item': member.canViewItem ? 1 : 0,
          'can_edit_item': member.canEditItem ? 1 : 0,
          'can_delete_item': member.canDeleteItem ? 1 : 0,
        });
      }
    });

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
  Future<List<AccountItem>> getAccountItems(
    String bookId, {
    List<String>? categories,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await _dbHelper.database;

    String whereClause = 'account_book_id = ?';
    List<dynamic> whereArgs = [bookId];

    if (categories?.isNotEmpty ?? false) {
      whereClause +=
          ' AND category IN (${List.filled(categories!.length, '?').join(',')})';
      whereArgs.addAll(categories);
    }
    if (type != null) {
      whereClause += ' AND type = ?';
      whereArgs.add(type);
    }
    if (startDate != null) {
      whereClause += ' AND account_date >= ?';
      whereArgs.add(startDate.toIso8601String());
    }
    if (endDate != null) {
      whereClause += ' AND account_date <= ?';
      whereArgs.add(endDate.toIso8601String());
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'account_items',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'account_date DESC',
    );

    return maps.map((map) => AccountItem.fromJson(map)).toList();
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
      'created_at': item.createdAt.toIso8601String(),
      'updated_at': item.updatedAt.toIso8601String(),
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
        'updated_at': item.updatedAt.toIso8601String(),
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
      'created_at': category.createdAt.toIso8601String(),
      'updated_at': category.updatedAt.toIso8601String(),
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
        'updated_at': category.updatedAt.toIso8601String(),
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
      'created_at': shop.createdAt.toIso8601String(),
      'updated_at': shop.updatedAt.toIso8601String(),
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
        'updated_at': shop.updatedAt.toIso8601String(),
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
  Future<List<Fund>> getFunds(String bookId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'funds',
      where: 'account_book_id = ?',
      whereArgs: [bookId],
      orderBy: 'name ASC',
    );
    return maps
        .map((map) => Fund.fromJson({
              'id': map['id'],
              'name': map['name'],
              'accountBookId': map['account_book_id'],
              'type': map['type'],
              'balance': map['balance'],
              'isDefault': map['is_default'] == 1,
              'createdAt': map['created_at'],
              'updatedAt': map['updated_at'],
            }))
        .toList();
  }

  @override
  Future<Fund> createFund(Fund fund) async {
    final db = await _dbHelper.database;
    await db.insert('funds', {
      'id': fund.id,
      'name': fund.name,
      'account_book_id': fund.accountBookId,
      'type': fund.type,
      'balance': fund.balance,
      'is_default': fund.isDefault ? 1 : 0,
      'created_at': fund.createdAt.toIso8601String(),
      'updated_at': fund.updatedAt.toIso8601String(),
    });
    return fund;
  }

  @override
  Future<Fund> updateFund(String id, Fund fund) async {
    final db = await _dbHelper.database;
    await db.update(
      'funds',
      {
        'name': fund.name,
        'type': fund.type,
        'balance': fund.balance,
        'is_default': fund.isDefault ? 1 : 0,
        'updated_at': fund.updatedAt.toIso8601String(),
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
}