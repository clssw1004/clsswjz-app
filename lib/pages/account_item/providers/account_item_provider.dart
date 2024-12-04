import 'package:flutter/material.dart';
import '../../../models/models.dart';
import '../../../services/api_service.dart';

class AccountItemProvider extends ChangeNotifier {
  Map<String, dynamic>? selectedBook;
  List<Category> categories = [];
  List<AccountBookFund> funds = [];
  List<Shop> shops = [];
  String _transactionType = 'EXPENSE';
  bool isLoading = false;

  String get transactionType => _transactionType;
  List<Map<String, dynamic>> get fundList => funds
      .where((fund) {
        // 根据交易类型过滤
        if (transactionType == 'EXPENSE') {
          return fund.fundOut;
        } else {
          return fund.fundIn;
        }
      })
      .map((f) => {
            'id': f.id,
            'name': f.name,
            'fundType': f.fundType,
            'fundRemark': f.fundRemark,
            'fundBalance': f.fundBalance,
            'isDefault': f.isDefault,
          })
      .toList();
  List<Map<String, dynamic>> get displayCategories =>
      categories.take(11).map((c) => {'name': c.name}).toList();
  List<Map<String, dynamic>> get shopList => shops
      .map((s) => {
            'id': s.id,
            'name': s.name,
            'shopCode': s.shopCode,
          })
      .toList();

  AccountItemProvider({this.selectedBook}) {
    if (selectedBook != null) {
      loadData();
    }
  }

  Future<void> loadData() async {
    if (selectedBook == null) return;
    isLoading = true;
    notifyListeners();

    try {
      final bookId = selectedBook!['id'];
      final futures = await Future.wait([
        ApiService.getCategories(bookId),
        ApiService.getBookFunds(bookId),
        ApiService.getShops(bookId),
      ]);

      categories = futures[0] as List<Category>;
      funds = futures[1] as List<AccountBookFund>;
      shops = futures[2] as List<Shop>;

      // 如果没有选择账户，设置默认账户
      if (_selectedFund == null) {
        final defaultFund = getDefaultFund();
        if (defaultFund != null) {
          _selectedFund = defaultFund;
        }
      }

      notifyListeners();
    } catch (e) {
      print('加载数据失败: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setSelectedBook(Map<String, dynamic>? book) async {
    selectedBook = book;
    if (book != null) {
      await loadFundList();
    }
    notifyListeners();
  }

  void setTransactionType(String type) {
    if (_transactionType == type) return;
    _transactionType = type == '支出' ? 'EXPENSE' : 'INCOME';
    notifyListeners();
  }

  void updateDisplayCategories(String category) {
    if (!categories.any((c) => c.name == category)) {
      categories = [
        ...categories.take(10),
        Category(
          id: '',
          name: category,
          accountBookId: selectedBook!['id'],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        )
      ];
      notifyListeners();
    }
  }

  void updateShops(List<Shop> newShops) {
    shops = newShops;
    notifyListeners();
  }

  // 获取默认资金账户
  Map<String, dynamic>? getDefaultFund() {
    if (selectedBook == null) return null;

    final defaultFund = funds.firstWhere(
      (fund) => fund.isDefault,
      orElse: () => funds.firstWhere(
        (fund) => transactionType == 'EXPENSE' ? fund.fundOut : fund.fundIn,
        orElse: () => funds.first,
      ),
    );

    return {
      'id': defaultFund.id,
      'name': defaultFund.name,
      'fundType': defaultFund.fundType,
      'fundRemark': defaultFund.fundRemark,
      'fundBalance': defaultFund.fundBalance,
      'isDefault': defaultFund.isDefault,
    };
  }

  // 加载资金账户列表
  Future<void> loadFundList() async {
    if (selectedBook == null) return;

    try {
      final bookFunds = await ApiService.getBookFunds(selectedBook!['id']);
      funds = bookFunds;
      notifyListeners();
    } catch (e) {
      print('加载资金账户失败: $e');
    }
  }

  // 添加账目数据相关字段和方法
  List<AccountItem> _accountItems = [];
  List<AccountItem> get accountItems => _accountItems;

  // 添加选中账户相关字段和方法
  Map<String, dynamic>? _selectedFund;
  Map<String, dynamic>? get selectedFund => _selectedFund;
  void setSelectedFund(Map<String, dynamic>? fund) {
    _selectedFund = fund;
    notifyListeners();
  }
}
