import 'package:flutter/material.dart';

class BookHeader extends StatelessWidget {
  final Map<String, dynamic>? book;

  const BookHeader({Key? key, this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          Icons.book_outlined,
          size: 18,
          color: colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            book?['name'] ?? '选择账本',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: book != null
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
