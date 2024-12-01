import 'package:flutter/material.dart';
import '../../../services/data_service.dart';

class CreateAccountBookItem extends StatelessWidget {
  final DataService _dataService;

  const CreateAccountBookItem({
    Key? key,
    required DataService dataService,
  }) : _dataService = dataService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Icon(
        Icons.book,
        color: colorScheme.primary,
      ),
      title: Text(
        '账本管理',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: colorScheme.onSurfaceVariant,
      ),
      onTap: () {
        Navigator.pushNamed(context, '/account-books').then((_) {
          _dataService.fetchAccountBooks(forceRefresh: true);
        });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      tileColor: colorScheme.surface,
      selectedTileColor: colorScheme.primaryContainer,
      hoverColor: colorScheme.primaryContainer.withOpacity(0.08),
      splashColor: colorScheme.primaryContainer.withOpacity(0.12),
    );
  }
} 