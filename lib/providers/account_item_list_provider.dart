import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../services/user_service.dart';
import '../models/account_item_request.dart';
import '../models/filter_state.dart';

class AccountItemListProvider with ChangeNotifier {
  int _currentPage = 1;
  static const int _pageSize = 100;
  bool _hasMoreData = true;
  bool _isLoading = false;
  bool _isInitialized = false;
  List<AccountItem> _items = [];
  List<AccountBook> _accountBooks = [];
  List<String> _categories = [];
  AccountBook? _selectedBook;
  bool _isFilterExpanded = false;
  AccountSummary? _summary;
  List<ShopOption> _shops = [];
  bool _isBatchMode = false;
  final Set<String> _selectedItems = {};
  final Set<String> _selectedDates = {};
  Map<String, List<AccountItem>> _groupedItems = {};
  FilterState _filterState = const FilterState();

  // Getters
  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;
  bool get isInitialized => _isInitialized;
  List<AccountItem> get items => _items;
  List<AccountBook> get accountBooks => _accountBooks;
  List<String> get categories => _categories;
  AccountBook? get selectedBook => _selectedBook;
  bool get isFilterExpanded => _isFilterExpanded;
  AccountSummary? get summary => _summary;
  List<ShopOption> get shops => _shops;
  bool get isBatchMode => _isBatchMode;
  Set<String> get selectedItems => _selectedItems;
  Set<String> get selectedDates => _selectedDates;
  Map<String, List<AccountItem>> get groupedItems => _groupedItems;
  FilterState get filterState => _filterState;

  // Methods
  Future<void> loadAccountItems({bool isRefresh = false}) async {
    if (_selectedBook == null) return;
    if (_isLoading && !isRefresh) return;

    if (isRefresh) {
      _isLoading = true;
      notifyListeners();
    }

    try {
      if (isRefresh) {
        _currentPage = 1;
        _hasMoreData = true;
        _items.clear();
        _groupedItems.clear();
      }

      final request = AccountItemRequest(
        accountBookId: _selectedBook!.id,
        page: _currentPage,
        pageSize: _pageSize,
        categories: _filterState.selectedCategories,
        type: _filterState.selectedType,
        startDate: _filterState.startDate,
        endDate: _filterState.endDate,
        shopCodes: _filterState.selectedShopCodes,
        minAmount: _filterState.minAmount,
        maxAmount: _filterState.maxAmount,
      );

      final response = await ApiService.getAccountItems(request);

      if (!isRefresh) {
        _items.addAll(response.items);
      } else {
        _items = response.items;
      }
      _updateGroupedItems();
      _summary = response.summary;
      _hasMoreData = !response.pagination.isLastPage;
      if (isRefresh) {
        _isLoading = false;
      }
      notifyListeners();
    } catch (e) {
      if (isRefresh) {
        _isLoading = false;
        notifyListeners();
      }
      rethrow;
    }
  }

  Future<void> loadMoreData() async {
    if (!_hasMoreData || _isLoading) return;
    _currentPage++;
    await loadAccountItems();
  }

  void _updateGroupedItems() {
    _groupedItems = <String, List<AccountItem>>{};
    for (var item in _items) {
      final date = item.accountDate.split(' ')[0];
      _groupedItems.putIfAbsent(date, () => []).add(item);
    }
  }

  Future<void> initializeAccountBooks() async {
    if (_isInitialized) return;
    
    try {
      final savedBookId = UserService.getCurrentAccountBookId();
      final books = await ApiService.getAccountBooks();

      AccountBook? defaultBook;
      defaultBook = books.firstWhere(
        (book) => book.id == savedBookId,
        orElse: () => _getFirstOwnedBook(books) ?? books.first,
      );

      _accountBooks = books;
      _selectedBook = defaultBook;
      notifyListeners();

      if (_selectedBook != null) {
        await UserService.setCurrentAccountBookId(_selectedBook!.id);
        await loadCategories();
        await loadShops();
        await loadAccountItems(isRefresh: true);
      }
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  AccountBook? _getFirstOwnedBook(List<AccountBook> books) {
    final currentUserId = UserService.getUserInfo()?.id;
    try {
      return books.firstWhere(
        (book) => book.createdBy == currentUserId,
        orElse: () => books.first,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> setSelectedBook(AccountBook book) async {
    _selectedBook = book;
    await UserService.setCurrentAccountBookId(book.id);
    notifyListeners();
    await loadCategories();
    await loadAccountItems(isRefresh: true);
  }

  void setFilterExpanded(bool expanded) {
    _isFilterExpanded = expanded;
    notifyListeners();
  }

  void setFilterState(FilterState newState) {
    _filterState = newState;
    notifyListeners();
  }

  Future<void> loadCategories() async {
    if (_selectedBook == null) return;
    try {
      final categories = await ApiService.getCategories(_selectedBook!.id);
      _categories = categories.map((c) => c.name).toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadShops() async {
    if (_selectedBook == null) return;
    try {
      final shops = await ApiService.getShops(_selectedBook!.id);
      _shops = shops
          .map((s) => ShopOption(
                code: s.code ?? '',
                name: s.name,
              ))
          .toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void enterBatchMode(String initialItemId) {
    _isBatchMode = true;
    _selectedItems.add(initialItemId);
    notifyListeners();
  }

  void exitBatchMode() {
    _isBatchMode = false;
    _selectedItems.clear();
    _selectedDates.clear();
    notifyListeners();
  }

  void toggleItemSelection(String itemId) {
    if (_selectedItems.contains(itemId)) {
      _selectedItems.remove(itemId);
    } else {
      _selectedItems.add(itemId);
    }
    _updateDateSelectionState();
    notifyListeners();
  }

  void _updateDateSelectionState() {
    _selectedDates.clear();
    for (final date in _groupedItems.keys) {
      final itemsInDate = _groupedItems[date] ?? [];
      if (itemsInDate.every((item) => _selectedItems.contains(item.id))) {
        _selectedDates.add(date);
      }
    }
  }

  Future<void> batchDelete() async {
    try {
      final result = await ApiService.batchDeleteAccountItems(
        _selectedItems.toList(),
      );
      await loadAccountItems(isRefresh: true);
      exitBatchMode();
      if (result.errors?.isNotEmpty == true) {
        throw Exception(result.errors!.join('\n'));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteItem(String itemId) async {
    try {
      await ApiService.deleteAccountItem(itemId);
      await loadAccountItems(isRefresh: true);
    } catch (e) {
      rethrow;
    }
  }
} 