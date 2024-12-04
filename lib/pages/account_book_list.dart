import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/message_helper.dart';
import '../constants/book_icons.dart';
import 'account_book_info.dart';
import '../services/user_service.dart';
import '../widgets/app_bar_factory.dart';

class AccountBookList extends StatefulWidget {
  @override
  State<AccountBookList> createState() => AccountBookListState();
}

class AccountBookListState extends State<AccountBookList> {
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
      final books = await ApiService.getAccountBooks();
      setState(() {
        _accountBooks = books.map((book) => book.toJson()).toList();
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
        builder: (context) => AccountBookInfo(accountBook: accountBook),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBarFactory.buildAppBar(
        context: context,
        title: AppBarFactory.buildTitle(context, '账本管理'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: '新建账本',
            onPressed: () {
              Navigator.pushNamed(context, '/create-account-book')
                  .then((_) => _fetchAccountBooks());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchAccountBooks,
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: colorScheme.primary,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 16),
            FilledButton.tonal(
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
                color: colorScheme.onSurfaceVariant,
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
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: _getHorizontalPadding(context),
      ),
      itemCount: _accountBooks.length,
      itemBuilder: (context, index) {
        final book = _accountBooks[index];
        return _buildAccountItem(book);
      },
    );
  }

  double _getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return width * 0.2;
    if (width > 600) return 32;
    return 16;
  }

  Widget _buildAccountItem(Map<String, dynamic> book) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUserId = UserService.getUserInfo()?['userId'];
    final isShared = book['fromId'] != currentUserId;
    final permissions = book['permissions'] as Map<String, dynamic>;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: InkWell(
        onTap: () => _openAccountBookInfo(book),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Icon(
                      _getBookIcon(book),
                      color: colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book['name'] ?? '未命名账本',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (book['description'] != null) ...[
                          SizedBox(height: 4),
                          Text(
                            book['description'],
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (isShared) ...[
                    SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '共享自${book['fromName'] ?? '未知用户'}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 权限图标
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildPermissionIcon(
                        icon: Icons.visibility,
                        enabled: permissions['canViewBook'] == true,
                        colorScheme: colorScheme,
                      ),
                      SizedBox(width: 8),
                      _buildPermissionIcon(
                        icon: Icons.edit_outlined,
                        enabled: permissions['canEditBook'] == true,
                        colorScheme: colorScheme,
                      ),
                      SizedBox(width: 8),
                      _buildPermissionIcon(
                        icon: Icons.delete_outline,
                        enabled: permissions['canDeleteBook'] == true,
                        colorScheme: colorScheme,
                        useErrorColor: true,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionIcon({
    required IconData icon,
    required bool enabled,
    required ColorScheme colorScheme,
    bool useErrorColor = false,
  }) {
    return Icon(
      icon,
      size: 16,
      color: enabled
          ? useErrorColor
              ? colorScheme.error
              : colorScheme.primary
          : colorScheme.onSurfaceVariant.withOpacity(0.5),
    );
  }
}
