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

    return Row(
      children: [
        Icon(
          Icons.account_balance_wallet,
          size: 20,
          color: colorScheme.primary,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            book?['name'] ?? '选择账本',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 15,
            ),
          ),
        ),
        Icon(
          Icons.chevron_right,
          size: 20,
          color: colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
}
