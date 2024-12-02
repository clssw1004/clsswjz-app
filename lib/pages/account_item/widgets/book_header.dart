import 'package:flutter/material.dart';
import '../../../services/user_service.dart';

class BookHeader extends StatelessWidget {
  final Map<String, dynamic>? book;

  const BookHeader({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (book == null) {
      return Card(
        margin: EdgeInsets.only(bottom: 16),
        child: ListTile(
          title: Text(
            '请选择账本',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final currentUserId = UserService.getUserInfo()?['userId'];
    final isShared = book!['createdBy'] != currentUserId;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Row(
          children: [
            Text(
              book!['name'] ?? '未命名账本',
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
        subtitle:
            book!['description'] != null && book!['description'].isNotEmpty
                ? Text(
                    book!['description'],
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
