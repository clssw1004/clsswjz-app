import 'package:flutter/material.dart';
import '../../../models/models.dart';
import '../providers/account_item_provider.dart';
import 'package:provider/provider.dart';
import '../../../l10n/l10n.dart';
import '../../../generated/app_localizations.dart';

class ShopSelector extends StatelessWidget {
  static const String NO_SHOP = 'NO_SHOP';

  final String? selectedShop;
  final String accountBookId;
  final ValueChanged<String?> onChanged;
  final VoidCallback? onTap;
  final String? selectedShopName;

  const ShopSelector({
    Key? key,
    this.selectedShop,
    required this.accountBookId,
    required this.onChanged,
    this.onTap,
    this.selectedShopName,
  }) : super(key: key);

  String _getDisplayName(BuildContext context, String? shopId) {
    if (shopId == null || shopId == NO_SHOP) {
      return L10n.of(context).noShop;
    }
    return selectedShopName ?? shopId;
  }

  void _showShopDialog(BuildContext context) {
    final provider = Provider.of<AccountItemProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => _ShopDialog(
        shops: [
          Shop(
            id: NO_SHOP,
            name: L10n.of(context).noShop,
            accountBookId: accountBookId,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          ...provider.shops,
        ],
        selectedShop: selectedShop ?? NO_SHOP,
        accountBookId: accountBookId,
        onShopsUpdated: (shops) {
          // 暂时不处理商家更新
        },
      ),
    ).then((shop) {
      if (shop != null) {
        onChanged(shop == NO_SHOP ? null : shop);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.store_outlined,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                onTap?.call();
                _showShopDialog(context);
              },
              child: Text(
                _getDisplayName(context, selectedShop),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: selectedShop != null && selectedShop != NO_SHOP
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, size: 18),
            onPressed: () => _showShopDialog(context),
            color: colorScheme.onSurfaceVariant,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopDialog extends StatefulWidget {
  final List<Shop> shops;
  final String? selectedShop;
  final String accountBookId;
  final ValueChanged<List<Shop>> onShopsUpdated;

  const _ShopDialog({
    Key? key,
    required this.shops,
    this.selectedShop,
    required this.accountBookId,
    required this.onShopsUpdated,
  }) : super(key: key);

  @override
  State<_ShopDialog> createState() => _ShopDialogState();
}

class _ShopDialogState extends State<_ShopDialog> {
  final _searchController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Shop> get _filteredShops {
    if (_searchText.isEmpty) return widget.shops;
    return widget.shops
        .where((shop) => shop.name
            .toString()
            .toLowerCase()
            .contains(_searchText.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      surfaceTintColor: colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.selectShopTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: _buildShopList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopList(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);
    final shops = _filteredShops;

    if (shops.isEmpty) {
      return Center(
        child: Text(
          l10n.noAvailableShops,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: shops.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final shop = shops[index];
        final isSelected = shop.id == widget.selectedShop;
        final isNoShop = shop.id == ShopSelector.NO_SHOP;

        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          title: Text(
            shop.name,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
            ),
          ),
          leading: Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: isSelected ? colorScheme.primary : null,
            size: 20,
          ),
          onTap: () => Navigator.pop(context, shop.id),
        );
      },
    );
  }
}
