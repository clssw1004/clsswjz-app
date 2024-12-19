import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../l10n/l10n.dart';

class AccountBookManager extends StatelessWidget {
  const AccountBookManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    return ListTile(
      leading: Icon(
        Icons.book_outlined,
      ),
      title: Text(
        l10n.accountManagement,
        style: theme.textTheme.bodyLarge,
      ),
      trailing: Icon(
        Icons.chevron_right,
      ),
      onTap: () {
        Navigator.pushNamed(context, '/account-books').then((_) {
          ApiService.getAccountBooks();
        });
      },
    );
  }
}
