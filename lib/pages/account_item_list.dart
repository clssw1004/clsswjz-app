import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../pages/account_item_info.dart';
import '../services/data_service.dart';
import '../theme/theme_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AccountItemList extends StatefulWidget {
  @override
  _AccountItemListState createState() => _AccountItemListState();
}

class _AccountItemListState extends State<AccountItemList> {
  final _dataService = DataService();
  List<Map<String, dynamic>> _accountItems = [];
  List<Map<String, dynamic>> _accountBooks = [];
  List<String> _categories = [];
  Map<String, dynamic>? _selectedBook;
  String? _selectedCategory;
  String? _selectedType;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = true;
  bool _isFilterExpanded = false;
  bool _isCategoryLoading = false;
  Key _dropdownKey = GlobalKey();
  List<String> _selectedCategories = [];
  double? _minAmount;
  double? _maxAmount;

  @override
  void initState() {
    super.initState();
    _loadAccountBooks();
  }

  Future<void> _loadAccountBooks() async {
    if (!mounted) return;
    try {
      final books = await _dataService.fetchAccountBooks(forceRefresh: true);
      if (!mounted) return;
      setState(() {
        _accountBooks = books;
        if (books.isNotEmpty && _selectedBook == null) {
          _selectedBook = books.first;
        }
      });
      if (books.isNotEmpty) {
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

  Future<void> _loadCategories() async {
    if (_selectedBook == null || !mounted) return;

    setState(() => _isCategoryLoading = true);

    try {
      final categories = await _dataService.fetchCategories(
        _selectedBook!['id'],
        forceRefresh: true,
      );
      if (!mounted) return;
      setState(() {
        _isCategoryLoading = false;
        _categories = categories;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isCategoryLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('获取分类失败: $e')),
      );
    }
  }

  Future<void> _loadAccountItems() async {
    if (_selectedBook == null || !mounted) return;

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载账目失败: $e')),
      );
    }
  }

  Widget _buildFilterSection() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final themeColor = themeProvider.themeColor;
        
        // 定义统一的样式常量
        const double componentHeight = 40.0;
        const double borderRadius = 8.0;
        const double fontSize = 13.0;
        const double iconSize = 18.0;
        const EdgeInsets contentPadding = EdgeInsets.symmetric(horizontal: 12);
        final borderSide = BorderSide(color: Colors.grey[300]!);
        final defaultTextStyle = TextStyle(
          fontSize: fontSize,
          color: Colors.grey[700],
        );
        final selectedTextStyle = TextStyle(
          fontSize: fontSize,
          color: themeColor,
          fontWeight: FontWeight.w500,
        );

        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: _isFilterExpanded ? 280 : 0,
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 类型选择按钮组
                  SizedBox(
                    height: componentHeight,
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: '', 
                          label: Text(
                            '全部',
                            textAlign: TextAlign.center,
                            style: TextStyle(height: 1.1),  // 调整文字行高以实现垂直居中
                          ),
                        ),
                        ButtonSegment(
                          value: 'EXPENSE',
                          label: Text(
                            '支出',
                            textAlign: TextAlign.center,
                            style: TextStyle(height: 1.1),
                          ),
                        ),
                        ButtonSegment(
                          value: 'INCOME',
                          label: Text(
                            '收入',
                            textAlign: TextAlign.center,
                            style: TextStyle(height: 1.1),
                          ),
                        ),
                      ],
                      selected: {_selectedType ?? ''},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          _selectedType = newSelection.first.isEmpty ? null : newSelection.first;
                        });
                        _loadAccountItems();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (states) => states.contains(MaterialState.selected)
                              ? themeColor
                              : Colors.transparent,
                        ),
                        side: MaterialStateProperty.all(borderSide),
                        padding: MaterialStateProperty.all(contentPadding),
                        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                          (states) => states.contains(MaterialState.selected)
                              ? selectedTextStyle.copyWith(color: Colors.white)
                              : defaultTextStyle,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,  // 减小点击区域以改善居中效果
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // 分类选择按钮
                  SizedBox(
                    height: componentHeight,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: contentPadding,
                        foregroundColor: _selectedCategories.isEmpty ? Colors.grey[700] : themeColor,
                        side: BorderSide(
                          color: _selectedCategories.isEmpty ? Colors.grey[300]! : themeColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        textStyle: defaultTextStyle,
                      ),
                      icon: Icon(Icons.category_outlined, size: iconSize),
                      label: Text(
                        _selectedCategories.isEmpty 
                            ? '选择分类' 
                            : '已选${_selectedCategories.length}个分类',
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Consumer<ThemeProvider>(
                              builder: (context, themeProvider, _) {
                                final themeColor = themeProvider.themeColor;
                                return AlertDialog(
                                  titlePadding: EdgeInsets.fromLTRB(24, 20, 16, 0),
                                  contentPadding: EdgeInsets.fromLTRB(20, 12, 20, 0),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '选择分类',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.close, color: Colors.black54),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        onPressed: () => Navigator.of(context).pop(),
                                      ),
                                    ],
                                  ),
                                  content: Container(
                                    width: double.maxFinite,
                                    constraints: BoxConstraints(
                                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: _categories.map((category) =>
                                          StatefulBuilder(
                                            builder: (context, setStateDialog) {
                                              final isSelected = _selectedCategories.contains(category);
                                              return Material(
                                                color: isSelected ? themeColor : Colors.grey[200],
                                                borderRadius: BorderRadius.circular(16),
                                                child: InkWell(
                                                  borderRadius: BorderRadius.circular(16),
                                                  onTap: () {
                                                    setStateDialog(() {
                                                      if (isSelected) {
                                                        _selectedCategories.remove(category);
                                                      } else {
                                                        _selectedCategories.add(category);
                                                      }
                                                    });
                                                    setState(() {});
                                                    _loadAccountItems();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6,
                                                    ),
                                                    child: Text(
                                                      category,
                                                      style: TextStyle(
                                                        color: isSelected ? Colors.white : Colors.black87,
                                                        fontSize: 13,
                                                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ).toList(),
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectedCategories.clear();
                                        });
                                        _loadAccountItems();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        '清除选择',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text(
                                        '关闭',
                                        style: TextStyle(
                                          color: themeColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // 金额范围
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: componentHeight,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: '最小金额',
                              labelStyle: defaultTextStyle,
                              prefixIcon: Icon(
                                Icons.currency_yen,  // 添加人民币符号图标
                                size: iconSize,
                                color: Colors.grey[600],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(borderRadius),
                                borderSide: borderSide,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(borderRadius),
                                borderSide: borderSide,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(borderRadius),
                                borderSide: BorderSide(color: themeColor),
                              ),
                              contentPadding: contentPadding,
                              suffixIcon: _minAmount != null
                                  ? IconButton(
                                      icon: Icon(Icons.clear, size: iconSize),
                                      onPressed: () {
                                        setState(() => _minAmount = null);
                                        _loadAccountItems();
                                      },
                                    )
                                  : null,
                            ),
                            style: defaultTextStyle,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: componentHeight,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: '最大金额',
                              labelStyle: defaultTextStyle,
                              prefixIcon: Icon(
                                Icons.currency_yen,  // 添加人民币符号图标
                                size: iconSize,
                                color: Colors.grey[600],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(borderRadius),
                                borderSide: borderSide,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(borderRadius),
                                borderSide: borderSide,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(borderRadius),
                                borderSide: BorderSide(color: themeColor),
                              ),
                              contentPadding: contentPadding,
                              suffixIcon: _maxAmount != null
                                  ? IconButton(
                                      icon: Icon(Icons.clear, size: iconSize),
                                      onPressed: () {
                                        setState(() => _maxAmount = null);
                                        _loadAccountItems();
                                      },
                                    )
                                  : null,
                            ),
                            style: defaultTextStyle,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  
                  // 日期范围
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: componentHeight,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: contentPadding,
                              foregroundColor: Colors.grey[700],
                              side: borderSide,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(borderRadius),
                              ),
                              textStyle: defaultTextStyle,
                            ),
                            icon: Icon(Icons.calendar_today, size: iconSize),
                            label: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _startDate == null ? '开始日期' : DateFormat('MM-dd').format(_startDate!),
                                  ),
                                ),
                                if (_startDate != null)
                                  Icon(Icons.clear, size: iconSize),
                              ],
                            ),
                            onPressed: () async {
                              final date = await _selectDate(context);
                              if (date != null) {
                                setState(() => _startDate = date);
                                _loadAccountItems();
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: componentHeight,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: contentPadding,
                              foregroundColor: Colors.grey[700],
                              side: borderSide,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(borderRadius),
                              ),
                              textStyle: defaultTextStyle,
                            ),
                            icon: Icon(Icons.calendar_today, size: iconSize),
                            label: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _endDate == null ? '结束日期' : DateFormat('MM-dd').format(_endDate!),
                                  ),
                                ),
                                if (_endDate != null)
                                  Icon(Icons.clear, size: iconSize),
                              ],
                            ),
                            onPressed: () async {
                              final date = await _selectDate(context);
                              if (date != null) {
                                setState(() => _endDate = date);
                                _loadAccountItems();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final themeColor = themeProvider.themeColor;
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Expanded(
                  child: DropdownButton<Map<String, dynamic>>(
                    value: _selectedBook,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    items: _accountBooks.map((book) {
                      return DropdownMenuItem(
                        value: book,
                        child: Row(
                          children: [
                            Icon(Icons.book, size: 20),
                            SizedBox(width: 8),
                            Text(book['name']),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: _onBookChanged,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                    _isFilterExpanded ? Icons.filter_list_off : Icons.filter_list),
                onPressed: () {
                  setState(() {
                    _isFilterExpanded = !_isFilterExpanded;
                  });
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
              _buildFilterSection(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadAccountItems,
                  child: Builder(
                    builder: (context) {
                      final groupedItems = _groupItemsByDate();
                      final dates = groupedItems.keys.toList()..sort((a, b) => b.compareTo(a));
                      
                      if (dates.isEmpty) {
                        return Center(
                          child: Text('暂无数据'),
                        );
                      }

                      return ListView.builder(
                        itemCount: dates.length,
                        itemBuilder: (context, dateIndex) {
                          final date = dates[dateIndex];
                          final items = groupedItems[date]!;
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 日期头部
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
                              // 当天的账目列表
                              ...items.map((item) {
                                final isExpense = item['type'] == 'EXPENSE';
                                final currencySymbol = _selectedBook?['currencySymbol'] ?? '¥';
                                
                                return Dismissible(
                                  key: Key(item['id'].toString()),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(right: 20.0),
                                    color: Colors.red,
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: Colors.white,
                                    ),
                                  ),
                                  confirmDismiss: (direction) async {
                                    return await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('确认删除'),
                                          content: Text('确定要删除这条账目记录吗？'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: Text('取消'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(true),
                                              child: Text(
                                                '删除',
                                                style: TextStyle(color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  onDismissed: (direction) async {
                                    try {
                                      await ApiService.deleteAccountItem(item['id']);
                                      
                                      setState(() {
                                        _accountItems.removeWhere((element) => element['id'] == item['id']);
                                      });
                                      
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('删除成功'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                      
                                      _loadAccountItems();
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('删除失败: $e'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                      _loadAccountItems();
                                    }
                                  },
                                  child: Card(
                                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    elevation: 0,
                                    child: InkWell(
                                      onTap: () => _navigateToEdit(item),
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
                                                color: themeColor.withOpacity(0.08),
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
                                                            color: isExpense ? Colors.red[700] : Colors.green[700],
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
                                                          color: themeColor.withOpacity(0.08),
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        child: Text(
                                                          item['category'],
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: themeColor,
                                                            fontWeight: FontWeight.w500,
                                                          ),
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
                                                        DateFormat('HH:mm').format(
                                                          DateTime.parse(item['accountDate'])
                                                        ),
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
                                  ),
                                );
                              }).toList(),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: _accountBooks.isNotEmpty && !_isLoading
              ? FloatingActionButton(
                  onPressed: _navigateToCreate,
                  child: Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }

  String _formatDateTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  void _navigateToEdit(Map<String, dynamic> item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountItemForm(initialData: item),
      ),
    );

    if (result == true) {
      await _loadCategories();
      _loadAccountItems();
    }
  }

  void _navigateToCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountItemForm(
          initialBook: _selectedBook,
        ),
      ),
    );

    if (result == true) {
      await _loadCategories();
      _loadAccountItems();
    }
  }

  void _onBookChanged(Map<String, dynamic>? newBook) {
    setState(() {
      _selectedBook = newBook;
      _selectedCategory = null;
      _categories = [];
      _dropdownKey = GlobalKey();
    });
    _loadCategories();
    _loadAccountItems();
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

  Future<DateTime?> _selectDate(BuildContext context) async {
    if (!mounted) return null;

    try {
      final DateTime? picked = await showDialog<DateTime>(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: Theme.of(context),
            child: Builder(
              builder: (BuildContext context) {
                return Localizations(
                  locale: const Locale('zh', 'CN'),
                  delegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  child: DatePickerDialog(
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  ),
                );
              },
            ),
          );
        },
      );

      return picked;
    } catch (e) {
      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('择日期时出错，请重试')),
      );
      return null;
    }
  }
}
