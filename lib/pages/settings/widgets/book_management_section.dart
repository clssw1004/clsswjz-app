import 'package:clsswjz/pages/account_book_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/l10n.dart';
import '../../../pages/import/import_page.dart';
import '../category_management_page.dart';
import '../fund_management_page.dart';
import '../shop_management_page.dart';
import '../../../services/storage_service.dart';
import '../../../constants/storage_keys.dart';
import '../providers/category_management_provider.dart';
import '../../../data/data_source_factory.dart';

class BookManagementSection extends StatelessWidget {
  const BookManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<
        ({
          IconData icon,
          String label,
          Color? color,
          VoidCallback onTap,
        })> menuItems = [
      (
        icon: Icons.book_outlined,
        label: l10n.accountManagement,
        color: colorScheme.primary,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccountBookList(),
            ),
          );
        },
      ),
      (
        icon: Icons.category_outlined,
        label: l10n.categoryManagement,
        color: Colors.blue,
        onTap: () async {
          final currentBookId = StorageService.getString(
            StorageKeys.currentBookId,
          );

          if (currentBookId.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.noDefaultBook)),
            );
            return;
          }

          final dataSource =
              await DataSourceFactory.create(DataSourceType.http);

          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (_) => CategoryManagementProvider(dataSource),
                  child: CategoryManagementPage(bookId: currentBookId),
                ),
              ),
            );
          }
        },
      ),
      (
        icon: Icons.account_balance_wallet_outlined,
        label: l10n.fundManagement,
        color: Colors.green,
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FundManagementPage(),
              ),
            ),
      ),
      (
        icon: Icons.store_outlined,
        label: l10n.shopManagement,
        color: Colors.orange,
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShopManagementPage(),
              ),
            ),
      ),
      (
        icon: Icons.upload_file_outlined,
        label: l10n.importData,
        color: Colors.purple,
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImportPage(),
              ),
            ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            l10n.accountManagement,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ),
        GridView.count(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: menuItems.map((item) {
            return InkWell(
              onTap: item.onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: item.color?.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon,
                        color: item.color,
                        size: 28,
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        item.label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}