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
  bool _disposed = false;

  String get transactionType => _transactionType;

  List<Map<String, dynamic>> get fundList => funds
      .where((fund) {
        return transactionType == 'EXPENSE' ? fund.fundOut : fund.fundIn;
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

  // 添加 getter 获取已筛选的分类
  List<Category> get filteredCategories => categories
      .where(
          (c) => c.categoryType.isEmpty || c.categoryType == _transactionType)
      .toList(growable: false);

  AccountItemProvider({this.selectedBook}) {
    if (selectedBook != null) {
      loadData();
    }
  }

  Future<void> loadData() async {
    if (selectedBook == null) return;

    try {
      isLoading = true;
      notifyListeners();

      final bookId = selectedBook!['id'];
      final results = await Future.wait([
        ApiService.getCategories(bookId),
        ApiService.getBookFunds(bookId),
        ApiService.getShops(bookId),
      ]);

      categories = results[0] as List<Category>;
      funds = results[1] as List<AccountBookFund>;
      shops = results[2] as List<Shop>;

      // 如果没有选择账户，设置默认账户
      if (_selectedFund == null && funds.isNotEmpty) {
        final defaultFund = funds.firstWhere(
          (fund) => fund.isDefault,
          orElse: () => funds.first,
        );
        _selectedFund = {
          'id': defaultFund.id,
          'name': defaultFund.name,
          'fundType': defaultFund.fundType,
          'fundRemark': defaultFund.fundRemark,
          'fundBalance': defaultFund.fundBalance,
          'isDefault': defaultFund.isDefault,
        };
      }
    } catch (e) {
      print('加载数据失败: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setSelectedBook(Map<String, dynamic>? book) async {
    if (book == null || book['id'] == selectedBook?['id']) return;
    selectedBook = book;
    await loadData();
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
          categoryType: _transactionType,
        )
      ];
      notifyListeners();
    }
  }

  // 添加选中账户相关字段和方法
  Map<String, dynamic>? _selectedFund;
  Map<String, dynamic>? get selectedFund => _selectedFund;

  void setSelectedFund(Map<String, dynamic>? fund) {
    _selectedFund = fund;
    notifyListeners();
  }

  void addCategory(String newCategory) {
    if (_disposed) return;
    try {
      final category = Category(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: newCategory,
        accountBookId: selectedBook?['id'],
        categoryType: _transactionType,
      );

      categories.add(category);
      notifyListeners();
    } catch (e) {
      debugPrint('添加分类失败: $e');
    }
  }

  Future<void> addShop(Shop shop) async {
    try {
      final newShop = await ApiService.createShop(shop);
      shops.add(newShop);
      notifyListeners();
    } catch (e) {
      debugPrint('添加商家失败: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
