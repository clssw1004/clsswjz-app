import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../pages/account_item_info.dart';
import 'account_item/providers/account_item_provider.dart';
import 'account_item/widgets/filter_section.dart';
import '../services/user_service.dart';
import '../widgets/app_bar_factory.dart';
import '../widgets/global_book_selector.dart';
import '../utils/message_helper.dart';
import '../constants/app_colors.dart';
import 'account_item/widgets/summary_card.dart';
import '../models/account_item.dart';
import '../l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountItemList extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onBookSelected;

  const AccountItemList({
    super.key,
    this.onBookSelected,
  });

  @override
  State<AccountItemList> createState() => _AccountItemListState();
}

class _AccountItemListState extends State<AccountItemList> {
  List<AccountItem> _accountItems = [];
  List<Map<String, dynamic>> _accountBooks = [];
  List<String> _categories = [];
  Map<String, dynamic>? _selectedBook;
  String? _selectedType;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = true;
  bool _isFilterExpanded = false;
  List<String> _selectedCategories = [];
  double? _minAmount;
  double? _maxAmount;
  AccountSummary? _summary;
  late AccountItemProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = AccountItemProvider();
    _initializeAccountBooks();
  }

  Future<void> _initializeAccountBooks() async {
    if (!mounted) return;
    try {
      // 先获取保存的账本ID
      final savedBookId = await UserService.getCurrentAccountBookId();

      // 加载所有账本
      final books = await ApiService.getAccountBooks();
      if (!mounted) return;

      final booksJson = books.map((book) => book.toJson()).toList();
      Map<String, dynamic>? defaultBook;

      if (savedBookId != null) {
        // 尝试找到保存的账本
        defaultBook = booksJson.firstWhere(
          (book) => book['id'] == savedBookId,
          orElse: () => _getFirstOwnedBook(booksJson) ?? booksJson.first,
        );
      } else {
        // 如果没有保存的账本ID，使用第一个本人的账本或第一个可用账本
        defaultBook = _getFirstOwnedBook(booksJson) ?? booksJson.first;
      }

      setState(() {
        _accountBooks = booksJson;
        _selectedBook = defaultBook;
      });

      if (_selectedBook != null) {
        // 保存选中的账本ID
        await UserService.setCurrentAccountBookId(_selectedBook!['id']);
        await _loadCategories();
        await _loadAccountItems();
      }
    } catch (e) {
      if (!mounted) return;
      MessageHelper.showError(context, message: e.toString());
    }
  }

  // 获取第一个本人的账本
  Map<String, dynamic>? _getFirstOwnedBook(List<Map<String, dynamic>> books) {
    final currentUserId = UserService.getUserInfo()?['userId'];
    try {
      return books.firstWhere(
        (book) => book['createdBy'] == currentUserId,
        orElse: () => books.first,
      );
    } catch (e) {
      return null;
    }
  }

  // 修改选择账本的回调方法
  void _onBookSelected(Map<String, dynamic> book) async {
    setState(() => _selectedBook = book);

    // 保存选中的账本ID和名称
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentBookId', book['id']);
    await prefs.setString('currentBookName', book['name']);
    await UserService.setCurrentAccountBookId(book['id']);

    // 调用回调通知父组件
    widget.onBookSelected?.call(book);

    // 重新加载数据
    await _loadCategories();
    await _loadAccountItems();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

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
            icon: Icon(Icons.filter_list),
            tooltip: l10n.filter,
            onPressed: () {
              setState(() {
                _isFilterExpanded = !_isFilterExpanded;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadAccountItems,
          child: Column(
            children: [
              FilterSection(
                isExpanded: _isFilterExpanded,
                selectedType: _selectedType,
                selectedCategories: _selectedCategories,
                minAmount: _minAmount,
                maxAmount: _maxAmount,
                startDate: _startDate,
                endDate: _endDate,
                categories: _categories,
                onTypeChanged: (type) {
                  setState(() => _selectedType = type);
                  _loadAccountItems();
                },
                onCategoriesChanged: (categories) {
                  setState(() => _selectedCategories = categories);
                  _loadAccountItems();
                },
                onMinAmountChanged: (amount) {
                  setState(() => _minAmount = amount);
                  _loadAccountItems();
                },
                onMaxAmountChanged: (amount) {
                  setState(() => _maxAmount = amount);
                  _loadAccountItems();
                },
                onStartDateChanged: (date) {
                  setState(() => _startDate = date);
                  _loadAccountItems();
                },
                onEndDateChanged: (date) {
                  setState(() => _endDate = date);
                  _loadAccountItems();
                },
                onClearFilter: () {
                  setState(() {
                    _selectedType = null;
                    _selectedCategories = [];
                    _minAmount = null;
                    _maxAmount = null;
                    _startDate = null;
                    _endDate = null;
                  });
                  _loadAccountItems();
                },
              ),
              if (_summary != null)
                SummaryCard(
                  allIn: _summary!.allIn,
                  allOut: _summary!.allOut,
                  allBalance: _summary!.allBalance,
                ),
              Expanded(
                child: _accountItems.isEmpty
                    ? _buildEmptyView(Theme.of(context).colorScheme)
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: EdgeInsets.only(
                          bottom: 80,
                          left: isLargeScreen ? 32 : 16,
                          right: isLargeScreen ? 32 : 16,
                        ),
                        itemCount:
                            _accountItems.length + _getDateHeaders().length,
                        itemBuilder: (context, index) {
                          final dateHeaders = _getDateHeaders();
                          final headerIndex = _getHeaderIndexForPosition(index);

                          if (headerIndex != -1) {
                            // 渲染日期头部
                            return _buildDateHeader(
                                context, dateHeaders[headerIndex]);
                          }

                          // 渲染账目项
                          final itemIndex = _getItemIndexForPosition(index);
                          return _buildAccountItem(
                            context,
                            _accountItems[itemIndex],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _accountBooks.isNotEmpty && !_isLoading
          ? FloatingActionButton(
              onPressed: _addNewRecord,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              elevation: 2,
              tooltip: l10n.newRecord,
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  Future<void> _loadAccountItems() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // 加载账目数据
      final response = await ApiService.getAccountItems(
        _selectedBook!['id'],
        categories: _selectedCategories,
        type: _selectedType,
        startDate: _startDate,
        endDate: _endDate,
      );

      // 加载资金账户数据
      await _provider.setSelectedBook(_selectedBook);
      await _provider.loadData();

      if (!mounted) return;
      setState(() {
        _accountItems = response.items;
        _summary = response.summary;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      MessageHelper.showError(context, message: e.toString());
    }
  }

  void _addNewRecord() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => AccountItemProvider(selectedBook: _selectedBook),
          child: AccountItemForm(
            initialBook: _selectedBook,
          ),
        ),
      ),
    );

    if (result == true) {
      _loadAccountItems();
    }
  }

  void _editRecord(Map<String, dynamic> record) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => AccountItemProvider(selectedBook: _selectedBook),
          child: AccountItemForm(
            initialData: record,
            initialBook: _selectedBook,
          ),
        ),
      ),
    );

    if (result == true) {
      _loadAccountItems();
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await ApiService.getCategories(_selectedBook!['id']);
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
    final l10n = L10n.of(context);
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
            l10n.noAccountItems,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getDateHeaders() {
    final Set<String> dates = {};
    for (var item in _accountItems) {
      final dateStr = DateFormat('yyyy-MM-dd').format(item.accountDate);
      dates.add(dateStr);
    }
    return dates.toList()..sort((a, b) => b.compareTo(a));
  }

  int _getHeaderIndexForPosition(int position) {
    final headers = _getDateHeaders();
    int itemCount = 0;
    for (int i = 0; i < headers.length; i++) {
      if (position == itemCount) {
        return i;
      }
      itemCount += 1 + _getItemsForDate(headers[i]).length;
    }
    return -1;
  }

  int _getItemIndexForPosition(int position) {
    final headers = _getDateHeaders();
    int itemCount = 0;
    int itemIndex = 0;
    for (String header in headers) {
      itemCount++; // 头部
      final items = _getItemsForDate(header);
      if (position < itemCount + items.length) {
        return itemIndex + (position - itemCount);
      }
      itemCount += items.length;
      itemIndex += items.length;
    }
    return itemIndex;
  }

  List<AccountItem> _getItemsForDate(String date) {
    return _accountItems.where((item) {
      final itemDate = DateFormat('yyyy-MM-dd').format(item.accountDate);
      return itemDate == date;
    }).toList();
  }

  Widget _buildDateHeader(BuildContext context, String date) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        _formatDateHeader(date),
        style: theme.textTheme.titleSmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
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

  Widget _buildAccountItem(BuildContext context, AccountItem item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 分类名称
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.category,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                      if (item.description?.isNotEmpty == true) ...[
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.description!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 16),
                // 金额
                Text(
                  '${item.type == 'EXPENSE' ? '-' : '+'}¥${item.amount.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: item.type == 'EXPENSE'
                        ? AppColors.expense
                        : AppColors.income,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            // 底部信息行
            Row(
              children: [
                // 账户标签
                if (item.fundId != null) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 12,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        SizedBox(width: 4),
                        Text(
                          item.fundName!,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                ],
                // 商家标签
                if (item.shop != null) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiaryContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.store_outlined,
                          size: 12,
                          color: colorScheme.onTertiaryContainer,
                        ),
                        SizedBox(width: 4),
                        Text(
                          item.shop!,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onTertiaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Spacer(),
                // 时间
                Text(
                  DateFormat('HH:mm').format(item.accountDate),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _editAccountItem(item),
      ),
    );
  }

  void _editAccountItem(AccountItem item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountItemForm(
          initialData: item.toJson(),
          initialBook: _selectedBook,
        ),
      ),
    );

    if (result == true) {
      _loadAccountItems();
    }
  }

  void _addNewItem() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => AccountItemProvider(),
          child: AccountItemForm(
            initialBook: _selectedBook,
          ),
        ),
      ),
    );

    if (result == true) {
      _loadAccountItems();
    }
  }
}
