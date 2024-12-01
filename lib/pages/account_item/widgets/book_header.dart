import 'package:flutter/material.dart';

class BookHeader extends StatelessWidget {
  final Map<String, dynamic>? book;

  const BookHeader({
    Key? key,
    this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.book_outlined,
            size: 20,
            color: colorScheme.primary,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              book != null ? book!['name'] : '未选择账本',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 