import 'package:flutter/material.dart';
import '../../../l10n/l10n.dart';

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
        label: l10n.importData.replaceAll('数据', ''),
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
        Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          child: GridView.count(
            padding: EdgeInsets.all(16),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.1,
            children: menuItems.map((item) {
              return InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: item.color?.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item.icon,
                          color: item.color,
                          size: 24,
                        ),
                      ),
                      SizedBox(height: 4),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: Text(
                          item.label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
