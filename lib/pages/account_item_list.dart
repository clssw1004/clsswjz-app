import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../pages/account_item_info.dart';

class AccountItemList extends StatefulWidget {
  @override
  _AccountItemListState createState() => _AccountItemListState();
}

class _AccountItemListState extends State<AccountItemList> {
  List<Map<String, dynamic>> _accountItems = [];
  List<Map<String, dynamic>> _accountBooks = [];
  Map<String, dynamic>? _selectedBook;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccountBooks();
  }

  Future<void> _loadAccountBooks() async {
    try {
      final books = await ApiService.fetchAccountBooks();
      setState(() {
        _accountBooks = books;
        _selectedBook = books.isNotEmpty ? books.first : null;
      });
      _loadAccountItems();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载账本失败: $e')),
      );
    }
  }

  Future<void> _loadAccountItems() async {
    try {
      final items = await ApiService.fetchAccountItems();
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

  String _formatDateTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  void _navigateToEdit(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountItemForm(initialData: item),
      ),
    ).then((_) {
      _loadAccountItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
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
                onChanged: (newValue) {
                  setState(() {
                    _selectedBook = newValue;
                  });
                  _loadAccountItems();
                },
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadAccountItems,
          ),
        ],
      ),
      body: RefreshIndicator(
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
    );
  }
} 