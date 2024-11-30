import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AccountBookManagePage extends StatefulWidget {
  @override
  _AccountBookManagePageState createState() => _AccountBookManagePageState();
}

class _AccountBookManagePageState extends State<AccountBookManagePage> {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        child: _buildContent(isDark),
      ),
    );
  }

  Widget _buildContent(bool isDark) {
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
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Text(
              book['name']?[0] ?? '?',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          title: Text(
            book['name'] ?? '未命名账本',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.grey[800],
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: isDark ? Colors.white54 : Colors.grey[400],
          ),
          onTap: () {
            // TODO: 处理账本点击事件
          },
        );
      },
    );
  }
}
