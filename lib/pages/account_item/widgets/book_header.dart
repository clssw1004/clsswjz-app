import 'package:clsswjz/models/account_book.dart';
import 'package:flutter/material.dart';
import '../../../l10n/l10n.dart';

class BookHeader extends StatelessWidget {
  final AccountBook? book;

  const BookHeader({Key? key, this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return GestureDetector(
      onTap: () {
        // 在这里添加点击事件的逻辑
      },
      child: Row(
        children: [
          Icon(
            Icons.book_outlined,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              book?.name ?? l10n.selectBookHint,
              style: theme.textTheme.titleMedium?.copyWith(
                color: book != null
                    ? colorScheme.onSurface
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
