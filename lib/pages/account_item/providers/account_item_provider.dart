import 'package:flutter/material.dart';
import '../../../services/data_service.dart';
import '../../../services/api_service.dart';

class AccountItemProvider extends ChangeNotifier {
  final _dataService = DataService();

  List<String> _categories = [];
  List<String> _displayCategories = [];
  List<Map<String, dynamic>> _accountBooks = [];
  List<Map<String, dynamic>> _fundList = [];
  Map<String, dynamic>? _selectedBook;
  String? _selectedCategory;
  String _transactionType = 'EXPENSE';

  // Getters
  List<String> get categories => _categories;
  List<String> get displayCategories => _displayCategories;
  Map<String, dynamic>? get selectedBook => _selectedBook;
  List<Map<String, dynamic>> get fundList => _fundList;
  List<Map<String, dynamic>> get accountBooks => _accountBooks;
  String get transactionType => _transactionType;

  Future<void> loadAccountBooks() async {
    try {
      _accountBooks = await _dataService.fetchAccountBooks(forceRefresh: true);
      notifyListeners();
    } catch (e) {
      print('Error loading account books: $e');
      _accountBooks = [];
      notifyListeners();
    }
  }

  Future<void> loadCategories(BuildContext context, String bookId) async {
    try {
      _categories = await _dataService.fetchCategories(context, bookId,
          forceRefresh: true);
      _updateDisplayCategories();
    } catch (e) {
      _categories = [];
      _displayCategories = [];
    }
  }

  Future<void> loadFundList(String bookId) async {
    try {
      _fundList = await _dataService.fetchFundList(bookId);
    } catch (e) {
      _fundList = [];
    }
  }

  Future<void> saveTransaction(
      BuildContext context, Map<String, dynamic> data) async {
    await ApiService.saveAccountItem(context, data);
    notifyListeners();
  }

  Future<void> setSelectedBook(
      BuildContext context, Map<String, dynamic>? book) async {
    _selectedBook = book;
    if (book != null) {
      try {
        await Future.wait(
            [loadCategories(context, book['id']), loadFundList(book['id'])]);
        notifyListeners();
      } catch (e) {
        print('Error loading book data: $e');
        _categories = [];
        _displayCategories = [];
        _fundList = [];
        notifyListeners();
      }
    } else {
      notifyListeners();
    }
  }

  void _updateDisplayCategories() {
    const maxButtons = 12;
    if (_categories.length <= maxButtons) {
      _displayCategories = List.from(_categories);
    } else {
      if (_selectedCategory != null &&
          !_categories.take(maxButtons - 1).contains(_selectedCategory)) {
        final initialCategories = _categories.take(maxButtons - 2).toList();
        initialCategories.add(_selectedCategory!);
        _displayCategories = initialCategories;
      } else {
        _displayCategories = _categories.take(maxButtons - 1).toList();
      }
    }
  }

  void setTransactionType(String type) {
    _transactionType = type;
    notifyListeners();
  }

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    _updateDisplayCategories();
    notifyListeners();
  }

  void updateDisplayCategories(String newCategory) {
    final List<String> updatedList = List.from(_displayCategories);
    if (updatedList.length >= 11) {
      updatedList[10] = newCategory; // 替换最后一个显示的分类
    }
    _displayCategories = updatedList;
    notifyListeners();
  }
}
