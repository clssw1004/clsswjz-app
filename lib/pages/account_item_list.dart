import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('账目列表'),
        actions: [
          IconButton(
            icon: Icon(
                _isFilterExpanded ? Icons.filter_list_off : Icons.filter_list),
            onPressed: () {
              setState(() => _isFilterExpanded = !_isFilterExpanded);
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadAccountItems,
          ),
        ],
      ),
      body: Column(
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
            child: _buildAccountItemList(),
          ),
        ],
      ),
      floatingActionButton: _accountBooks.isNotEmpty && !_isLoading
          ? FloatingActionButton(
              onPressed: _addNewRecord,
              child: Icon(Icons.add),
            )
          : null,
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

  Widget _buildAccountItemList() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final groupedItems = _groupItemsByDate();
    final dates = groupedItems.keys.toList()..sort((a, b) => b.compareTo(a));

    if (dates.isEmpty) {
      return Center(
        child: Text('暂无数据'),
      );
    }

    return ListView.builder(
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final items = groupedItems[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                date,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),
            ...items.map((item) => _buildAccountItem(item)).toList(),
          ],
        );
      },
    );
  }

  Widget _buildAccountItem(Map<String, dynamic> item) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isExpense = item['type'] == 'EXPENSE';
    final currencySymbol = _selectedBook?['currencySymbol'] ?? '¥';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 0,
      child: InkWell(
        onTap: () => _editRecord(item),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          height: 88,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    isExpense ? '支' : '收',
                    style: TextStyle(
                      color: isExpense ? Colors.red[700] : Colors.green[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$currencySymbol${item['amount'].toString()}',
                            style: TextStyle(
                              color: isExpense
                                  ? Colors.red[700]
                                  : Colors.green[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item['category'].toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['description']?.isNotEmpty == true
                                ? item['description']
                                : '无备注',
                            style: TextStyle(
                              color: item['description']?.isNotEmpty == true
                                  ? Colors.grey[600]
                                  : Colors.grey[400],
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          DateFormat('HH:mm')
                              .format(DateTime.parse(item['accountDate'])),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
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
