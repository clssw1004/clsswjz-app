import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/storage_keys.dart';
import '../../../data/data_source_factory.dart';
import '../../../l10n/l10n.dart';
import '../../../pages/account_book_list.dart';
import '../../../pages/import/import_page.dart';
import '../../../services/storage_service.dart';
import '../../common/symbol_list_page.dart';
import '../category_management_page.dart';
import '../fund_management_page.dart';
import '../providers/category_management_provider.dart';
import '../shop_management_page.dart';

class BookManagementSection extends StatelessWidget {
  const BookManagementSection({super.key});

  Future<void> _handleCategoryManagement(BuildContext context, String l10nNoDefaultBook) async {
    final currentBookId = StorageService.getString(StorageKeys.currentBookId);

    if (currentBookId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10nNoDefaultBook)),
      );
      return;
    }

    final dataSource = await DataSourceFactory.create(DataSourceType.http);
    
    // 使用 Navigator.pushReplacement 避免重复压栈
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => CategoryManagementProvider(dataSource),
          child: CategoryManagementPage(bookId: currentBookId),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final menuItems = [
      _MenuItem(
        icon: Icons.book_outlined,
        label: l10n.accountManagement,
        color: colorScheme.primary,
        onTap: () => _navigateTo(context, AccountBookList()),
      ),
      _MenuItem(
        icon: Icons.category_outlined,
        label: l10n.categoryManagement,
        color: Colors.blue,
        onTap: () => _handleCategoryManagement(context, l10n.noDefaultBook),
      ),
      _MenuItem(
        icon: Icons.account_balance_wallet_outlined,
        label: l10n.fundManagement,
        color: Colors.green,
        onTap: () => _navigateTo(context, FundManagementPage()),
      ),
      _MenuItem(
        icon: Icons.store_outlined,
        label: l10n.shopManagement,
        color: Colors.orange,
        onTap: () => _navigateTo(context, ShopManagementPage()),
      ),
      _MenuItem(
        icon: Icons.tag_outlined,
        label: l10n.bookTag,
        color: Colors.amber,
        onTap: () => _navigateTo(
          context,
          SymbolListPage(
            title: l10n.bookTag,
            symbolType: 'TAG',
          ),
        ),
      ),
      _MenuItem(
        icon: Icons.propane_outlined,
        label: l10n.bookProject,
        color: Colors.brown,
        onTap: () => _navigateTo(
          context,
          SymbolListPage(
            title: l10n.bookProject,
            symbolType: 'PROJECT',
          ),
        ),
      ),
      _MenuItem(
        icon: Icons.folder_outlined,
        label: l10n.importData,
        color: Colors.purple,
        onTap: () => _navigateTo(context, ImportPage()),
      ),
    ];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 1,
          childAspectRatio: 1.3,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) => _buildMenuItem(
          context,
          menuItems[index],
          theme,
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item, ThemeData theme) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: item.color,
                size: 24,
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Text(
                item.label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontSize: 11,
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
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
