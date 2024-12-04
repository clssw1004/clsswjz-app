import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "clsswjz.db";
  static const _databaseVersion = 1;

  // 单例模式
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 账本表
    await db.execute('''
      CREATE TABLE account_books (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        currency_symbol TEXT NOT NULL,
        icon TEXT,
        created_by TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // 成员表
    await db.execute('''
      CREATE TABLE members (
        user_id TEXT NOT NULL,
        account_book_id TEXT NOT NULL,
        nickname TEXT NOT NULL,
        can_view_book INTEGER NOT NULL DEFAULT 0,
        can_edit_book INTEGER NOT NULL DEFAULT 0,
        can_delete_book INTEGER NOT NULL DEFAULT 0,
        can_view_item INTEGER NOT NULL DEFAULT 0,
        can_edit_item INTEGER NOT NULL DEFAULT 0,
        can_delete_item INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (user_id, account_book_id),
        FOREIGN KEY (account_book_id) REFERENCES account_books (id) ON DELETE CASCADE
      )
    ''');

    // 账目表
    await db.execute('''
      CREATE TABLE account_items (
        id TEXT PRIMARY KEY,
        account_book_id TEXT NOT NULL,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        description TEXT,
        shop TEXT,
        fund_id TEXT,
        account_date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (account_book_id) REFERENCES account_books (id) ON DELETE CASCADE,
        FOREIGN KEY (fund_id) REFERENCES funds (id) ON DELETE SET NULL
      )
    ''');

    // 分类表
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        account_book_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (account_book_id) REFERENCES account_books (id) ON DELETE CASCADE
      )
    ''');

    // 商家表
    await db.execute('''
      CREATE TABLE shops (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        shop_code TEXT NOT NULL,
        created_by TEXT NOT NULL,
        updated_by TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // 资金账户表
    await db.execute('''
      CREATE TABLE funds (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        remark TEXT,
        balance REAL NOT NULL DEFAULT 0,
        account_book_id TEXT NOT NULL,
        is_default INTEGER NOT NULL DEFAULT 0,
        fund_in INTEGER NOT NULL DEFAULT 1,
        fund_out INTEGER NOT NULL DEFAULT 1,
        created_by TEXT NOT NULL,
        updated_by TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (account_book_id) REFERENCES account_books (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 处理数据库升级
  }
}
