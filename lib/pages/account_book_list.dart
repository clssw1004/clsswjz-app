import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/message_helper.dart';
import '../constants/book_icons.dart';
import 'account_book/widgets/book_info.dart';

class AccountBookList extends StatefulWidget {
  @override
  _AccountBookListState createState() => _AccountBookListState();
}

class _AccountBookListState extends State<AccountBookList> {
  List<dynamic> _accountBooks = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAccountBooks();
  }

  Future<void> _fetchAccountBooks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final books = await ApiService.fetchAccountBooks();
      setState(() {
        _accountBooks = books;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = '获取账本列表失败：$e';
        _isLoading = false;
      });

      if (mounted) {
        MessageHelper.showError(
          context,
          message: '获取账本列表失败',
          actionLabel: '重试',
          onAction: _fetchAccountBooks,
        );
      }
    }
  }

  Future<void> _openAccountBookInfo(Map<String, dynamic> accountBook) async {
    final updatedAccountBook = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => BookInfo(accountBook: accountBook),
      ),
    );

    if (updatedAccountBook != null) {
      setState(() {
        final index = _accountBooks
            .indexWhere((book) => book['id'] == updatedAccountBook['id']);
        if (index != -1) {
          _accountBooks[index] = updatedAccountBook;
        }
      });
    }
  }

  IconData _getBookIcon(Map<String, dynamic> book) {
    if (book['icon'] == null || book['icon'].isEmpty) {
      return BookIcons.defaultIcon;
    }
    try {
      return IconData(
        int.parse(book['icon']),
        fontFamily: 'MaterialIcons',
      );
    } catch (e) {
      return BookIcons.defaultIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('账本管理'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/create-account-book').then((_) {
                _fetchAccountBooks();
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchAccountBooks,
        child: _buildContent(isDark, colorScheme),
      ),
    );
  }

  Widget _buildContent(bool isDark, ColorScheme colorScheme) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: _fetchAccountBooks,
              child: Text('重试'),
            ),
          ],
        ),
      );
    }

    if (_accountBooks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '暂无账本',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create-account-book').then((_) {
                  _fetchAccountBooks();
                });
              },
              child: Text('新建账本'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: _accountBooks.length,
      itemBuilder: (context, index) {
        final book = _accountBooks[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(
              _getBookIcon(book),
              color: colorScheme.onPrimaryContainer,
              size: 20,
            ),
          ),
          title: Text(
            book['name'] ?? '未命名账本',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.grey[800],
            ),
          ),
          subtitle:
              book['description'] != null && book['description'].isNotEmpty
                  ? Text(
                      book['description'],
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
          trailing: Icon(
            Icons.chevron_right,
            color: isDark ? Colors.white54 : Colors.grey[400],
          ),
          onTap: () {
            _openAccountBookInfo(book);
          },
        );
      },
    );
  }
}
