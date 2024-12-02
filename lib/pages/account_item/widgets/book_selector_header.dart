import 'package:flutter/material.dart';
import '../../../services/user_service.dart';
import '../../../constants/book_icons.dart';

class BookSelectorHeader extends StatelessWidget {
  final Map<String, dynamic>? selectedBook;
  final List<Map<String, dynamic>> books;
  final ValueChanged<Map<String, dynamic>> onBookSelected;

  const BookSelectorHeader({
    Key? key,
    required this.selectedBook,
    required this.books,
    required this.onBookSelected,
  }) : super(key: key);

  IconData _getBookIcon(Map<String, dynamic>? book) {
    if (book == null) return BookIcons.defaultIcon;

    final String? iconString = book['icon']?.toString();
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

  Future<void> _showBookSelector(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUserId = UserService.getUserInfo()?['userId'];

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
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
              final isSelected = selectedBook?['id'] == book['id'];
              final isShared = book['createdBy'] != currentUserId;

              return ListTile(
                selected: isSelected,
                leading: CircleAvatar(
                  backgroundColor: isSelected
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceVariant,
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
                        book['name'] ?? '未命名账本',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (isShared) ...[
                      Icon(
                        Icons.people_outline,
                        size: 16,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '共享',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
                subtitle: book['description'] != null &&
                        book['description'].isNotEmpty
                    ? Text(
                        book['description'],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                onTap: () {
                  Navigator.pop(context, book);
                },
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
      onBookSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUserId = UserService.getUserInfo()?['userId'];
    final isShared =
        selectedBook != null && selectedBook!['createdBy'] != currentUserId;

    return Card(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: () => _showBookSelector(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(
                  _getBookIcon(selectedBook),
                  color: colorScheme.onPrimaryContainer,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          selectedBook?['name'] ?? '请选择账本',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (isShared) ...[
                          SizedBox(width: 8),
                          Icon(
                            Icons.people_outline,
                            size: 16,
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
                      ],
                    ),
                    if (selectedBook?['description'] != null &&
                        selectedBook!['description'].isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          selectedBook!['description'],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
