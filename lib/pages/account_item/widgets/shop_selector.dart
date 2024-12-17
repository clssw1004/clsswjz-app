import 'package:flutter/material.dart';
import '../../../models/models.dart';
import '../providers/account_item_provider.dart';
import 'package:provider/provider.dart';
import '../../../l10n/l10n.dart';

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
      builder: (context) => ShopDialog(
        shops: [
          Shop(
            id: NO_SHOP,
            name: L10n.of(context).noShop,
            accountBookId: accountBookId,
          ),
          ...provider.shops,
        ],
        selectedShop: selectedShop ?? NO_SHOP,
        accountBookId: accountBookId,
        onSelected: (shopId) {
          onChanged(shopId);
        },
        onShopAdded: (shopName) {
          // 暂时不处理商家更新
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    final displayName = _getDisplayName(context, selectedShop);
    final isNoShop = selectedShop == null || selectedShop == NO_SHOP;

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
                displayName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isNoShop
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurface,
                  fontWeight: isNoShop ? FontWeight.normal : FontWeight.w400,
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

class ShopDialog extends StatefulWidget {
  final List<Shop> shops;
  final String? selectedShop;
  final String accountBookId;
  final ValueChanged<String> onSelected;
  final ValueChanged<String>? onShopAdded;

  const ShopDialog({
    Key? key,
    required this.shops,
    this.selectedShop,
    required this.accountBookId,
    required this.onSelected,
    this.onShopAdded,
  }) : super(key: key);

  @override
  State<ShopDialog> createState() => _ShopDialogState();
}

class _ShopDialogState extends State<ShopDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Shop> _filteredShops = [];
  bool _showAddButton = false;

  @override
  void initState() {
    super.initState();
    _filteredShops = List.from(widget.shops);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterShops(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredShops = List.from(widget.shops);
        _showAddButton = false;
      } else {
        _filteredShops = widget.shops
            .where(
                (shop) => shop.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        _showAddButton = _filteredShops.isEmpty;
      }
    });
  }

  void _addNewShop(String name) {
    final newShop = Shop(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      shopCode: name,
      accountBookId: widget.accountBookId,
      createdBy: '',
      updatedBy: '',
    );

    setState(() {
      widget.shops.add(newShop);
      _filteredShops = List.from(widget.shops);
      _searchController.clear();
      _showAddButton = false;
    });
    widget.onShopAdded?.call(name);
    widget.onSelected(name);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  l10n.selectShopTitle,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.searchShopHint,
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterShops('');
                            },
                          ),
                        if (_showAddButton)
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              if (_searchController.text.isNotEmpty) {
                                _addNewShop(_searchController.text);
                              }
                            },
                          ),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withOpacity(0.5),
                      ),
                    ),
                  ),
                  onChanged: _filterShops,
                ),
              ),
              SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredShops.length,
                  itemBuilder: (context, index) {
                    final shop = _filteredShops[index];
                    final isSelected = shop.name == widget.selectedShop;

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 24),
                      title: Text(
                        shop.name,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isSelected ? colorScheme.primary : null,
                        ),
                      ),
                      leading: Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected ? colorScheme.primary : null,
                        size: 20,
                      ),
                      onTap: () {
                        widget.onSelected(shop.name);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: Text(l10n.cancelButton),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
