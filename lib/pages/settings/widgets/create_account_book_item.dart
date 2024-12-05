import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../l10n/l10n.dart';

class CreateAccountBookItem extends StatelessWidget {
  const CreateAccountBookItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return ListTile(
      leading: Icon(
        Icons.book,
        color: colorScheme.primary,
      ),
      title: Text(
        l10n.accountManagement,
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
          ApiService.getAccountBooks();
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
