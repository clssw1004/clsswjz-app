import 'package:flutter/material.dart';
import '../../../models/models.dart';
import '../../../services/api_service.dart';

class AccountItemProvider extends ChangeNotifier {
  Map<String, dynamic>? selectedBook;
  List<Category> categories = [];
  List<Fund> funds = [];
  List<Shop> shops = [];
  String _transactionType = 'EXPENSE';
  bool isLoading = false;

  String get transactionType => _transactionType;
  List<Map<String, dynamic>> get fundList => funds
      .map((f) => {
            'id': f.id,
            'name': f.name,
            'fundType': f.fundType,
            'fundRemark': f.fundRemark,
            'fundBalance': f.fundBalance,
            'isDefault': f.fundBooks.any((book) =>
                book.accountBookId == selectedBook?['id'] && book.isDefault),
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
      funds = futures[1] as List<Fund>;
      shops = futures[2] as List<Shop>;
    } catch (e) {
      print('加载数据失败: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setSelectedBook(Map<String, dynamic>? book) async {
    selectedBook = book;
    await loadData();
  }

  void setTransactionType(String type) {
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
}
