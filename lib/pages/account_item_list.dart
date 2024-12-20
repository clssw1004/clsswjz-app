import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../pages/account_item_info.dart';
import 'account_item/widgets/filter_section.dart';
import '../services/user_service.dart';
import '../widgets/app_bar_factory.dart';
import '../widgets/global_book_selector.dart';
import '../utils/message_helper.dart';
import 'account_item/widgets/summary_card.dart';
import '../l10n/l10n.dart';
import '../widgets/account_item_tile.dart';
import '../constants/storage_keys.dart';
import '../services/storage_service.dart';
import '../models/account_item_request.dart';
import '../models/filter_state.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AccountItemList extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onBookSelected;

  const AccountItemList({
    super.key,
    this.onBookSelected,
  });

  @override
  State<AccountItemList> createState() => _AccountItemListState();
}

class _AccountItemListState extends State<AccountItemList>
    with AutomaticKeepAliveClientMixin {
  int _currentPage = 1;
  static const int _pageSize = 100;
  static const double _loadMoreThreshold = 1;
  bool _hasMoreData = true;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
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
  final _listKey = GlobalKey<State>();
  FilterState _filterState = const FilterState();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadFilterState();
    _loadAccountItems(isRefresh: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeAccountBooks();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.maxScrollExtent > 0) {
      final threshold =
          _scrollController.position.maxScrollExtent * _loadMoreThreshold;
      if (_scrollController.position.pixels >= threshold) {
        if (!_isLoading && _hasMoreData) {
          _loadMoreData();
        }
      }
    }
  }

  Future<void> _loadMoreData() async {
    if (!_hasMoreData || _isLoading) return;
    _currentPage++;
    await _loadAccountItems();
  }

  Future<void> _loadAccountItems({bool isRefresh = false}) async {
    if (_selectedBook == null) return;
    if (_isLoading && !isRefresh) return;

    if (isRefresh) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      if (isRefresh) {
        _currentPage = 1;
        _hasMoreData = true;
        _items.clear();
        _groupedItems.clear();
        _scrollController.jumpTo(0);
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

      if (!mounted) return;

      setState(() {
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
      });
    } catch (e) {
      if (!mounted) return;
      if (isRefresh) {
        setState(() {
          _isLoading = false;
        });
      }
      MessageHelper.showError(context, message: e.toString());
    }
  }

  void _updateGroupedItems() {
    _groupedItems = <String, List<AccountItem>>{};
    for (var item in _items) {
      final date = item.accountDate.split(' ')[0];
      _groupedItems.putIfAbsent(date, () => []).add(item);
    }
  }

  Future<void> _initializeAccountBooks() async {
    if (!mounted) return;

    try {
      // 先获取保存的账本ID
      final savedBookId = UserService.getCurrentAccountBookId();

      // 加载所有账本
      final books = await ApiService.getAccountBooks();
      if (!mounted) return;

      AccountBook? defaultBook;

      // 尝试找保存的账本
      defaultBook = books.firstWhere(
        (book) => book.id == savedBookId,
        orElse: () => _getFirstOwnedBook(books) ?? books.first,
      );

      await StorageService.setString(StorageKeys.currentBookId, defaultBook.id);
      await StorageService.setString(
          StorageKeys.currentBookName, defaultBook.id);

      if (!mounted) return;
      setState(() {
        _accountBooks = books;
        _selectedBook = defaultBook;
      });

      if (_selectedBook != null) {
        // 保存选中的账本ID
        await UserService.setCurrentAccountBookId(_selectedBook!.id);
        await _loadCategories();
        await _loadShops();
        await _loadAccountItems();
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('初始化账本失败: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
      MessageHelper.showError(context, message: e.toString());
    }
  }

  // 获取第一个本人的账本
  AccountBook? _getFirstOwnedBook(List<AccountBook> books) {
    final currentUserId = UserService.getUserInfo()?['userId'];
    try {
      return books.firstWhere(
        (book) => book.createdBy == currentUserId,
        orElse: () => books.first,
      );
    } catch (e) {
      return null;
    }
  }

  // 修改选择账本的回调方法
  void _onBookSelected(AccountBook book) async {
    _selectedBook = book;

    // 保存选中的账本ID和名称
    await StorageService.setString(StorageKeys.currentBookId, book.id);
    await StorageService.setString(StorageKeys.currentBookName, book.name);
    await UserService.setCurrentAccountBookId(book.id);

    // 重新加载数据
    await _loadCategories();
    await _loadAccountItems();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBarFactory.buildAppBar(
        context: context,
        title: GlobalBookSelector(
          selectedBook: _selectedBook,
          books: _accountBooks,
          onBookSelected: _onBookSelected,
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFilterExpanded ? Icons.filter_list : Icons.filter_alt_outlined,
              color: _filterState.hasFilter ? colorScheme.primary : null,
            ),
            tooltip: l10n.filter,
            onPressed: _toggleFilter,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            FilterSection(
              isExpanded: _isFilterExpanded,
              filterState: _filterState,
              categories: _categories,
              shops: _shops,
              onFilterChanged: (newState) {
                setState(() {
                  _filterState = newState;
                });
                _loadAccountItems(isRefresh: true);
              },
            ),
            if (_summary != null)
              SummaryCard(
                key: ValueKey('summary_card'),
                allIn: _summary!.allIn,
                allOut: _summary!.allOut,
                allBalance: _summary!.allBalance,
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _loadAccountItems(isRefresh: true),
                child: _items.isEmpty && !_isLoading
                    ? _buildEmptyView(colorScheme)
                    : _buildList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isBatchMode ||
              _selectedBook == null ||
              _selectedBook!.canEditItem == false
          ? null
          : FloatingActionButton(
              onPressed: _addNewRecord,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              elevation: 2,
              tooltip: l10n.newRecord,
              child: Icon(Icons.add),
            ),
      bottomNavigationBar: _isBatchMode
          ? SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: null, // 暂时禁用
                      child: Text(
                        l10n.edit,
                        style: TextStyle(
                          color: colorScheme.primary.withOpacity(0.5),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _batchDelete,
                      child: Text(
                        l10n.delete,
                        style: TextStyle(
                          color: colorScheme.error,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _exitBatchMode,
                      child: Text(
                        l10n.cancel,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Future<void> _loadFilterState() async {
    final isExpanded = StorageService.getBool(StorageKeys.filterPanelPinned,
        defaultValue: false);
    if (mounted) {
      setState(() => _isFilterExpanded = isExpanded);
    }
  }

  Future<void> _toggleFilter() async {
    final newState = !_isFilterExpanded;
    await StorageService.setBool(StorageKeys.filterPanelPinned, newState);
    if (mounted) {
      setState(() => _isFilterExpanded = newState);
    }
  }

  Future<void> _loadShops() async {
    try {
      final shops = await ApiService.getShops(_selectedBook!.id);
      if (!mounted) return;
      setState(() {
        _shops = shops
            .map((s) => ShopOption(
                  code: s.code ?? '',
                  name: s.name,
                ))
            .toList();
      });
    } catch (e) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          MessageHelper.showError(context, message: e.toString());
        }
      });
    }
  }

  void _enterBatchMode(String initialItemId) {
    setState(() {
      _isBatchMode = true;
      _selectedItems.add(initialItemId);
    });
  }

  void _exitBatchMode() {
    setState(() {
      _isBatchMode = false;
      _selectedItems.clear();
      _selectedDates.clear();
    });
  }

  void _toggleItemSelection(String itemId) {
    setState(() {
      if (_selectedItems.contains(itemId)) {
        _selectedItems.remove(itemId);
      } else {
        _selectedItems.add(itemId);
      }
      _updateDateSelectionState();
    });
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

  Future<void> _batchDelete() async {
    final l10n = L10n.of(context);

    if (_selectedItems.isEmpty) {
      MessageHelper.showError(
        context,
        message: l10n.pleaseSelectItems,
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.confirmBatchDeleteMessage(_selectedItems.length)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final result = await ApiService.batchDeleteAccountItems(
          _selectedItems.toList(),
        );

        if (result.errors?.isNotEmpty == true) {
          if (mounted) {
            MessageHelper.showError(
              context,
              message: result.errors!.join('\n'),
            );
          }
        } else {
          if (mounted) {
            MessageHelper.showSuccess(
              context,
              message: l10n.batchDeleteSuccess(result.successCount),
            );
          }
        }

        await _loadAccountItems();
        _exitBatchMode();
      } catch (e) {
        if (mounted) {
          MessageHelper.showError(context, message: e.toString());
        }
      }
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await ApiService.getCategories(_selectedBook!.id);
      if (!mounted) return;
      setState(() {
        _categories = categories.map((c) => c.name).toList();
      });
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: e.toString());
    }
  }

  Widget _buildEmptyView(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            L10n.of(context).noAccountItems,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (_isLoading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_items.isEmpty) {
      return Center(
        child: Text(L10n.of(context).noAccountItems),
      );
    }

    // 使用 ValueKey 而不是 GlobalKey
    return ListView(
      key: ValueKey('account_items_${_currentPage}_${_items.length}'),
      controller: _scrollController,
      padding: EdgeInsets.only(bottom: 80),
      children: [
        // 分组列表项
        for (final date in _groupedItems.keys) ...[
          _buildDateHeader(date, _groupedItems[date]!),
          ..._groupedItems[date]!.map((item) => _buildListItem(item)),
        ],
        // 加载更多指示器
        if (_isLoading || !_hasMoreData) _buildLoadingIndicator(),
      ],
    );
  }

  void _addNewRecord() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountItemForm(
          initialBook: _selectedBook,
        ),
      ),
    );

    if (result == true) {
      _loadAccountItems(isRefresh: true);
    }
  }

  void _editAccountItem(AccountItem item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountItemForm(
          initialData: item,
          initialBook: _selectedBook,
        ),
      ),
    );

    if (result == true) {
      await _loadAccountItems(isRefresh: true);
    }
  }

  Widget _buildDateHeader(String date, List<AccountItem> items) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    double dailyIncome = 0;
    double dailyExpense = 0;
    for (var item in items) {
      if (item.type == 'INCOME') {
        dailyIncome += item.amount;
      } else {
        dailyExpense += item.amount;
      }
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            _formatDateHeader(date),
            style: theme.textTheme.titleSmall,
          ),
          Spacer(),
          if (dailyExpense > 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_downward,
                  size: 14,
                  color: theme.colorScheme.error,
                ),
                SizedBox(width: 2),
                Text(
                  dailyExpense.toStringAsFixed(2),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          if (dailyExpense > 0 && dailyIncome > 0) SizedBox(width: 12),
          if (dailyIncome > 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_upward,
                  size: 14,
                  color: Colors.green,
                ),
                SizedBox(width: 2),
                Text(
                  dailyIncome.toStringAsFixed(2),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatDateHeader(String date) {
    final l10n = L10n.of(context);
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final yesterday =
        DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 1)));

    if (date == today) {
      return l10n.today;
    } else if (date == yesterday) {
      return l10n.yesterday;
    }

    final dateTime = DateTime.parse(date);
    return l10n.monthDayFormat(
      dateTime.month.toString(),
      dateTime.day.toString(),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Text(
        _hasMoreData
            ? L10n.of(context).loadingMore
            : L10n.of(context).noMoreData,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }

  Widget _buildListItem(AccountItem item) {
    return Slidable(
      key: ValueKey(item.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.15,
        children: [
          CustomSlidableAction(
            onPressed: (context) async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(L10n.of(context).delete),
                  content: Text(L10n.of(context).confirmDeleteMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(L10n.of(context).cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                      child: Text(L10n.of(context).delete),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                try {
                  await ApiService.deleteAccountItem(item.id);
                  if (context.mounted) {
                    MessageHelper.showSuccess(
                      context,
                      message: L10n.of(context).deleteSuccess,
                    );
                  }
                  await _loadAccountItems(isRefresh: true);
                } catch (e) {
                  if (context.mounted) {
                    MessageHelper.showError(context, message: e.toString());
                  }
                }
              }
            },
            foregroundColor: Theme.of(context).colorScheme.error,
            child: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      child: AccountItemTile(
        key: ValueKey(item.id),
        item: item,
        onTap: () => _editAccountItem(item),
        onLongPress: () => _enterBatchMode(item.id),
        showCheckbox: _isBatchMode,
        isChecked: _selectedItems.contains(item.id),
        onCheckChanged: (checked) => _toggleItemSelection(item.id),
      ),
    );
  }
}
