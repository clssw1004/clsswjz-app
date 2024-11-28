import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../pages/account_item_info.dart';
import '../services/data_service.dart';

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

  @override
  void initState() {
    super.initState();
    _loadAccountBooks();
    _loadCategories();
  }

  Future<void> _loadAccountBooks() async {
    try {
      final books = await _dataService.fetchAccountBooks(forceRefresh: true);
      setState(() {
        _accountBooks = books;
        _selectedBook = _selectedBook ?? books.first;
      });
      _loadAccountItems();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载账本失败: $e')),
      );
    }
  }

  Future<void> _loadCategories() async {
    if (_selectedBook == null) return;
    
    try {
      final categories = await _dataService.fetchCategories(
        _selectedBook!['id'],
        forceRefresh: true,
      );
      setState(() {
        _categories = categories;
      });
    } catch (e) {
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
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: '分类',
                  isDense: true,
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
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                  _loadAccountItems();
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
            icon: Icon(_isFilterExpanded ? Icons.filter_list_off : Icons.filter_list),
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
                  
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      onTap: () => _navigateToEdit(item),
                      leading: CircleAvatar(
                        backgroundColor: isExpense ? Colors.red[100] : Colors.green[100],
                        child: Icon(
                          isExpense ? Icons.remove : Icons.add,
                          color: isExpense ? Colors.red : Colors.green,
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            '$currencySymbol${item['amount'].toString()}',
                            style: TextStyle(
                              color: isExpense ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item['category'],
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_formatDateTime(item['accountDate'])),
                          if (item['description']?.isNotEmpty)
                            Text(
                              item['description'],
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                        ],
                      ),
                      isThreeLine: item['description']?.isNotEmpty ?? false,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
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
      _loadAccountItems();
    }
  }

  void _onBookChanged(Map<String, dynamic>? newBook) {
    setState(() {
      _selectedBook = newBook;
      _selectedCategory = null; // 清空已选分类
      _categories = []; // 清空分类列表
    });
    _loadCategories(); // 重新加载分类
    _loadAccountItems(); // 重新加载账目
  }
} 