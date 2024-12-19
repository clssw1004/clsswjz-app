import 'package:clsswjz/models/account_book.dart';
import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../constants/book_icons.dart';

class GlobalBookSelector extends StatelessWidget {
  final AccountBook? selectedBook;
  final List<AccountBook> books;
  final ValueChanged<AccountBook> onBookSelected;

  static const IconData dropdownIcon = Icons.arrow_drop_down;
  static const IconData bookIcon = Icons.book;
  static const IconData editIcon = Icons.edit_outlined;
  static const IconData peopleIcon = Icons.people_outline;

  const GlobalBookSelector({
    Key? key,
    required this.selectedBook,
    required this.books,
    required this.onBookSelected,
  }) : super(key: key);

  IconData _getBookIcon(AccountBook? book) {
    if (book == null) return BookIcons.defaultIcon;

    final String? iconString = book.icon?.toString();
    if (iconString == null || iconString.isEmpty) {
      return BookIcons.defaultIcon;
    }

    try {
      return IconData(
        int.parse(iconString),
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

    return TextButton(
      onPressed: () => _showBookSelector(context),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getBookIcon(selectedBook),
            size: 20,
            color: colorScheme.onSurface,
          ),
          SizedBox(width: 8),
          Text(
            selectedBook != null ? selectedBook!.name : '选择账本',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          Icon(
            dropdownIcon,
            color: colorScheme.onSurface,
          ),
        ],
      ),
    );
  }

  Future<void> _showBookSelector(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUserId = UserService.getUserInfo()?['userId'];

    if (books.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('暂无可用账本')),
      );
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        title: Text(
          '选择账本',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              final isSelected = selectedBook?.id == book.id;
              final isShared = book.createdBy != currentUserId;
              final canEdit = book.canEditBook == true;

              return ListTile(
                selected: isSelected,
                leading: CircleAvatar(
                  backgroundColor: isSelected
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainerHighest,
                  child: Icon(
                    _getBookIcon(book),
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        book.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (canEdit)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              editIcon,
                              size: 14,
                              color: colorScheme.primary,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '可编辑',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (isShared)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              peopleIcon,
                              size: 14,
                              color: colorScheme.primary,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '共享',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                subtitle:
                    book.description != null && book.description!.isNotEmpty
                        ? Text(
                            book.description!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                onTap: () => Navigator.pop(context, book.toJson()),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
        ],
      ),
    );

    if (result != null) {
      onBookSelected(AccountBook.fromJson(result));
    }
  }
}
