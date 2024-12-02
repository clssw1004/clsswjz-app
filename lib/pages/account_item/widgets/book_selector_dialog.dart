import 'package:flutter/material.dart';
import '../../../services/user_service.dart';

class BookSelectorDialog extends StatelessWidget {
  final List<Map<String, dynamic>> books;
  final Map<String, dynamic>? selectedBook;

  const BookSelectorDialog({
    Key? key,
    required this.books,
    this.selectedBook,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUserId = UserService.getUserInfo()?['userId'];

    return AlertDialog(
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
              title: Row(
                children: [
                  Text(
                    book['name'] ?? '未命名账本',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                  if (isShared) ...[
                    SizedBox(width: 8),
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
              subtitle:
                  book['description'] != null && book['description'].isNotEmpty
                      ? Text(
                          book['description'],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        )
                      : null,
              onTap: () => Navigator.pop(context, book),
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
    );
  }
}
