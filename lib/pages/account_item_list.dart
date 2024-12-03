import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../pages/account_item_info.dart';
import '../services/data_service.dart';
import 'account_item/providers/account_item_provider.dart';
import 'account_item/widgets/book_selector_header.dart';
import 'account_item/widgets/filter_section.dart';
import '../services/user_service.dart';

class AccountItemList extends StatefulWidget {
  @override
  AccountItemListState createState() => AccountItemListState();
}

class AccountItemListState extends State<AccountItemList> {
  final _dataService = DataService();
  List<Map<String, dynamic>> _accountItems = [];
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

  @override
  void initState() {
    super.initState();
    _initializeAccountBooks();
  }

  Future<void> _initializeAccountBooks() async {
    if (!mounted) return;
    try {
      // 先获取保存的账本ID
      final savedBookId = await UserService.getCurrentAccountBookId();

      // 加载所有账本
      final books = await _dataService.fetchAccountBooks(forceRefresh: true);
      if (!mounted) return;

      Map<String, dynamic>? defaultBook;
      if (savedBookId != null) {
        // 尝试找到保存的账本
        defaultBook = books.firstWhere(
          (book) => book['id'] == savedBookId,
          orElse: () => _getFirstOwnedBook(books) ?? books.first,
        );
      } else {
        // 如果没有保存的账本ID，使用第一个本人的账本或第一个可用账本
        defaultBook = _getFirstOwnedBook(books) ?? books.first;
      }

      setState(() {
        _accountBooks = books;
        _selectedBook = defaultBook;
      });

      if (_selectedBook != null) {
        // 保存选中的账本ID
        await UserService.setCurrentAccountBookId(_selectedBook!['id']);
        await _loadCategories();
        _loadAccountItems();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载账本失败: $e')),
      );
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
    // 保存选中的账本ID
    await UserService.setCurrentAccountBookId(book['id']);
    await _loadCategories();
    _loadAccountItems();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 根据屏幕宽度调整布局
        final isWideScreen = constraints.maxWidth > 600;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: Text(
              '账目列表',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.surface,
            actions: [
              IconButton(
                icon: Icon(
                  _isFilterExpanded ? Icons.filter_list_off : Icons.filter_list,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                tooltip: _isFilterExpanded ? '收起筛选' : '展开筛选',
                onPressed: () {
                  setState(() => _isFilterExpanded = !_isFilterExpanded);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                tooltip: '刷新',
                onPressed: _loadAccountItems,
              ),
            ],
            systemOverlayStyle: Theme.of(context).brightness == Brightness.dark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
          ),
          body: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    BookSelectorHeader(
                      selectedBook: _selectedBook,
                      books: _accountBooks,
                      onBookSelected: _onBookSelected,
                    ),
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
                    Expanded(
                      child: _accountItems.isEmpty
                          ? _buildEmptyView(Theme.of(context).colorScheme)
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: EdgeInsets.only(
                                bottom: 80,
                                left: isWideScreen ? 32 : 16,
                                right: isWideScreen ? 32 : 16,
                              ),
                              itemCount: _accountItems.length +
                                  _getDateHeaders().length,
                              itemBuilder: (context, index) {
                                final dateHeaders = _getDateHeaders();
                                final headerIndex =
                                    _getHeaderIndexForPosition(index);

                                if (headerIndex != -1) {
                                  // 渲染日期头部
                                  return _buildDateHeader(
                                      context, dateHeaders[headerIndex]);
                                }

                                // 渲染账目项
                                final itemIndex =
                                    _getItemIndexForPosition(index);
                                return _buildAccountItem(
                                  context,
                                  _accountItems[itemIndex],
                                );
                              },
                            ),
                    ),
                  ],
                ),
          floatingActionButton: _accountBooks.isNotEmpty && !_isLoading
              ? FloatingActionButton(
                  onPressed: _addNewRecord,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  elevation: 2,
                  tooltip: '新增记录',
                  child: Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }

  Future<void> _loadAccountItems() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final items = await ApiService.fetchAccountItems(
        accountBookId: _selectedBook!['id'],
        categories: _selectedCategories,
        type: _selectedType,
        startDate: _startDate,
        endDate: _endDate,
      );

      if (!mounted) return;
      setState(() {
        _accountItems = items;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _addNewRecord() async {
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

  void _editRecord(Map<String, dynamic> record) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => AccountItemProvider(),
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

  Map<String, List<Map<String, dynamic>>> _groupItemsByDate() {
    final groupedItems = <String, List<Map<String, dynamic>>>{};

    for (var item in _accountItems) {
      final date = DateTime.parse(item['accountDate']);
      final dateStr = DateFormat('yyyy-MM-dd').format(date);

      if (!groupedItems.containsKey(dateStr)) {
        groupedItems[dateStr] = [];
      }
      groupedItems[dateStr]!.add(item);
    }

    return groupedItems;
  }

  Future<void> _loadCategories() async {
    if (_selectedBook == null || !mounted) return;

    try {
      final categories = await _dataService.fetchCategories(
        context,
        _selectedBook!['id'],
        forceRefresh: true,
      );
      if (!mounted) return;
      setState(() {
        _categories = categories;
        _selectedCategories
            .removeWhere((category) => !categories.contains(category));
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载分类失败: $e')),
      );
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
            '暂无账目记录',
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
    final headers = <String>{};
    for (var item in _accountItems) {
      try {
        final dateStr = item['accountDate'];
        if (dateStr != null) {
          // 统一处理时区问题
          final date = DateTime.parse(dateStr).toLocal();
          headers.add(DateFormat('yyyy-MM-dd').format(date));
        }
      } catch (e) {
        print('日期解析错误: ${item['accountDate']} - $e');
        continue;
      }
    }
    return headers.toList()..sort((a, b) => b.compareTo(a));
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

  List<Map<String, dynamic>> _getItemsForDate(String date) {
    return _accountItems.where((item) {
      final itemDate =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(item['accountDate']));
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
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final yesterday =
        DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 1)));

    if (date == today) {
      return '今天';
    } else if (date == yesterday) {
      return '昨天';
    }
    return DateFormat('MM月dd日').format(DateTime.parse(date));
  }

  Widget _buildAccountItem(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isExpense = item['type'] == 'EXPENSE';
    final currencySymbol = item['currencySymbol'] ?? '¥';

    // 定义收支颜色
    final typeColor = isExpense
        ? Color(0xFFE53935) // Material Red 600
        : Color(0xFF43A047); // Material Green 600

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: InkWell(
        onTap: () => _editRecord(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: typeColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$currencySymbol${item['amount'].toString()}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: typeColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item['category'].toString(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        if (item['fundName'] != null) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  colorScheme.primaryContainer.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item['fundName'],
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                        if (item['shop'] != null) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.tertiaryContainer
                                  .withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item['shop'],
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onTertiaryContainer,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                        Expanded(
                          child: Text(
                            item['description']?.isNotEmpty == true
                                ? item['description']
                                : '无备注',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: item['description']?.isNotEmpty == true
                                  ? colorScheme.onSurfaceVariant
                                  : colorScheme.outline,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          DateFormat('HH:mm')
                              .format(DateTime.parse(item['accountDate'])),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
