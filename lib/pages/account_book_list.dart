import 'package:flutter/material.dart';
import '../generated/app_localizations.dart';
import '../services/api_service.dart';
import '../utils/message_helper.dart';
import '../constants/book_icons.dart';
import 'account_book_info.dart';
import '../services/user_service.dart';
import '../widgets/app_bar_factory.dart';
import '../l10n/l10n.dart';
import '../models/account_book.dart';

class AccountBookList extends StatefulWidget {
  static const IconData addIcon = Icons.add;
  static const IconData bookIcon = Icons.book;
  static const IconData sharedIcon = Icons.people_outline;
  static const IconData visibilityIcon = Icons.visibility;
  static const IconData editIcon = Icons.edit_outlined;
  static const IconData deleteIcon = Icons.delete_outline;

  @override
  State<AccountBookList> createState() => _AccountBookListState();
}

class _AccountBookListState extends State<AccountBookList> {
  late Future<List<AccountBook>> _accountBooksFuture;

  @override
  void initState() {
    super.initState();
    _accountBooksFuture = _fetchAccountBooks();
  }

  Future<List<AccountBook>> _fetchAccountBooks() async {
    try {
      return await ApiService.getAccountBooks();
    } catch (e) {
      // 显示错误消息
      Future.microtask(() => _showErrorMessage(e.toString()));
      throw e;
    }
  }

  void _showErrorMessage(String error) {
    MessageHelper.showError(
      context,
      message: '获取账本列表失败',
      actionLabel: '重试',
      onAction: () {
        setState(() {
          _accountBooksFuture = _fetchAccountBooks();
        });
      },
    );
  }

  Future<void> _refreshAccountBooks() async {
    setState(() {
      _accountBooksFuture = _fetchAccountBooks();
    });
  }

  Future<void> _openAccountBookInfo(AccountBook accountBook) async {
    final updatedAccountBook = await Navigator.push<AccountBook>(
      context,
      MaterialPageRoute(
        builder: (context) => AccountBookInfo(accountBook: accountBook),
      ),
    );

    if (updatedAccountBook != null) {
      _refreshAccountBooks();
    }
  }

  IconData _getBookIcon(AccountBook book) {
    if (book.icon == null) {
      return BookIcons.defaultIcon;
    }
    try {
      return IconData(
        int.parse(book.icon!),
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
    final l10n = L10n.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBarFactory.buildAppBar(
        context: context,
        title: AppBarFactory.buildTitle(context, l10n.accountBookList),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            tooltip: l10n.actionWithTarget(l10n.actionNew, l10n.targetBook),
            onPressed: () async {
              await Navigator.pushNamed(context, '/create-account-book');
              _refreshAccountBooks();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshAccountBooks,
          child: FutureBuilder<List<AccountBook>>(
            future: _accountBooksFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingWidget(colorScheme);
              }

              if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error.toString(), theme, colorScheme, l10n);
              }

              final books = snapshot.data ?? [];
              if (books.isEmpty) {
                return _buildEmptyWidget(colorScheme, l10n);
              }

              return _buildBookList(books);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(ColorScheme colorScheme) {
    return Center(
      child: CircularProgressIndicator(
        color: colorScheme.primary,
      ),
    );
  }

  Widget _buildErrorWidget(String error, ThemeData theme, ColorScheme colorScheme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: _refreshAccountBooks,
            child: Text(l10n.retryLoading),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(ColorScheme colorScheme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.noAccountBooks,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await Navigator.pushNamed(context, '/create-account-book');
              _refreshAccountBooks();
            },
            child: Text(l10n.actionWithTarget(l10n.actionNew, l10n.targetBook)),
          ),
        ],
      ),
    );
  }

  Widget _buildBookList(List<AccountBook> books) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: _getHorizontalPadding(context),
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
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

  Widget _buildAccountItem(AccountBook book) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);
    final currentUserId = UserService.getUserInfo()?.id;
    final isShared = book.fromId != currentUserId;
    final permissions = book.permissions;

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
                          book.name ?? l10n.unnamedBook,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (book.description != null) ...[
                          SizedBox(height: 4),
                          Text(
                            book.description ?? '',
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
                          l10n.sharedFrom(book.fromName ?? l10n.unknownUser),
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildPermissionIcon(
                        icon: Icons.visibility,
                        enabled: permissions.canViewBook,
                        colorScheme: colorScheme,
                      ),
                      SizedBox(width: 8),
                      _buildPermissionIcon(
                        icon: Icons.edit_outlined,
                        enabled: permissions.canEditBook,
                        colorScheme: colorScheme,
                      ),
                      SizedBox(width: 8),
                      _buildPermissionIcon(
                        icon: Icons.delete_outline,
                        enabled: permissions.canDeleteBook,
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
