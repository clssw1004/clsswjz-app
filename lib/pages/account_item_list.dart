import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../pages/account_item_info.dart';
import '../services/data_service.dart';
import './create_account_book_page.dart';

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

  @override
  void initState() {
    super.initState();
    _loadAccountBooks();
  }

  Future<void> _loadAccountBooks() async {
    try {
      final books = await _dataService.fetchAccountBooks(forceRefresh: true);
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载账本失败: $e')),
      );
    }
  }

  Future<void> _loadCategories() async {
    if (_selectedBook == null) return;

    setState(() {
      _isCategoryLoading = true;
    });

    try {
      final categories = await _dataService.fetchCategories(
        _selectedBook!['id'],
        forceRefresh: true,
      );
      setState(
        () {
          _isCategoryLoading = false;
          _categories = categories;
        },
      );
    } catch (e) {
      setState(() {
        _isCategoryLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('获取分类失败: $e')),
      );
    }
  }

  Future<void> _loadAccountItems() async {
    if (_selectedBook == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final items = await ApiService.fetchAccountItems(
        accountBookId: _selectedBook!['id'],
        category: _selectedCategory,
        type: _selectedType,
        startDate: _startDate,
        endDate: _endDate,
      );
      setState(() {
        _accountItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载账目失败: $e')),
      );
    }
  }

  Widget _buildFilterSection() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _isFilterExpanded ? 200 : 0,
      child: Card(
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                key: _dropdownKey,
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: '分类',
                  isDense: true,
                  suffixIcon: _isCategoryLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.grey,
                          ),
                        )
                      : null,
                ),
                items: [
                  DropdownMenuItem(value: null, child: Text('全部')),
                  ..._categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ],
                onChanged: _isCategoryLoading
                    ? null
                    : (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                        _loadAccountItems();
                      },
                onTap: () {
                  if (_selectedBook != null && !_isCategoryLoading) {
                    _loadCategories();
                  }
                },
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: '类型',
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem(value: null, child: Text('全部')),
                  DropdownMenuItem(value: 'EXPENSE', child: Text('支出')),
                  DropdownMenuItem(value: 'INCOME', child: Text('收入')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                  _loadAccountItems();
                },
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      icon: Icon(Icons.calendar_today),
                      label: Text(_startDate == null
                          ? '开始日期'
                          : DateFormat('yyyy-MM-dd').format(_startDate!)),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _startDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() {
                            _startDate = date;
                          });
                          _loadAccountItems();
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextButton.icon(
                      icon: Icon(Icons.calendar_today),
                      label: Text(_endDate == null
                          ? '结束日期'
                          : DateFormat('yyyy-MM-dd').format(_endDate!)),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _endDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() {
                            _endDate = date;
                          });
                          _loadAccountItems();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_accountBooks.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('账目列表'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.book_outlined,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                '还没有账本',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateAccountBookPage(),
                    ),
                  );
                  if (result == true) {
                    _loadAccountBooks();
                  }
                },
                icon: Icon(Icons.add),
                label: Text('创建账本'),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('账目列表'),
            SizedBox(width: 16),
            Expanded(
              child: DropdownButton<Map<String, dynamic>>(
                value: _selectedBook,
                isExpanded: true,
                items: _accountBooks.map((book) {
                  return DropdownMenuItem(
                    value: book,
                    child: Text(book['name']),
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
              child: ListView.builder(
                itemCount: _accountItems.length,
                itemBuilder: (context, index) {
                  final item = _accountItems[index];
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
                          _accountItems.removeAt(index);
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
                      child: InkWell(
                        onTap: () => _navigateToEdit(item),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isExpense 
                                      ? Colors.red.withOpacity(0.1) 
                                      : Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  isExpense 
                                      ? Icons.arrow_circle_down_outlined 
                                      : Icons.arrow_circle_up_outlined,
                                  color: isExpense ? Colors.red : Colors.green,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 12),
                              
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '$currencySymbol${item['amount'].toString()}',
                                            style: TextStyle(
                                              color: isExpense ? Colors.red : Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.grey[300]!,
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            item['category'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    
                                    if (item['description']?.isNotEmpty)
                                      Container(
                                        margin: EdgeInsets.only(bottom: 4),
                                        child: Text(
                                          item['description'],
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        _formatDateTime(item['accountDate']),
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 12,
                                        ),
                                      ),
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
        builder: (context) => AccountItemForm(),
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
}
