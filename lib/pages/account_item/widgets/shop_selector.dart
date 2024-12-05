import 'package:flutter/material.dart';
import '../../../models/models.dart';
import '../providers/account_item_provider.dart';
import 'package:provider/provider.dart';
import '../../../l10n/l10n.dart';

class ShopSelector extends StatefulWidget {
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

  @override
  State<ShopSelector> createState() => _ShopSelectorState();
}

class _ShopSelectorState extends State<ShopSelector> {
  Shop? _selectedShop;

  @override
  void initState() {
    super.initState();
    _initializeShop();
  }

  @override
  void didUpdateWidget(ShopSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedShop != widget.selectedShop) {
      _initializeShop();
    }
  }

  Future<void> _initializeShop() async {
    if (!mounted) return;
    final provider = Provider.of<AccountItemProvider>(context, listen: false);

    if (widget.selectedShop != null) {
      try {
        _selectedShop = provider.shops.firstWhere(
          (shop) => shop.name == widget.selectedShop,
          orElse: () => throw '未找到商家',
        );
        print('Found shop: ${_selectedShop?.name}');
        setState(() {});
      } catch (e) {
        print('Error finding shop: $e');
        // 可以选择是否显示错误信息
        // MessageHelper.showError(context, message: e.toString());
      }
    }
  }

  void _showShopDialog(BuildContext context) {
    final provider = Provider.of<AccountItemProvider>(context, listen: false);
    showDialog<Shop>(
      context: context,
      builder: (context) => _ShopDialog(
        shops: provider.shops,
        selectedShop: widget.selectedShop,
        accountBookId: widget.accountBookId,
        onShopsUpdated: provider.updateShops,
      ),
    ).then((shop) {
      if (shop != null) {
        widget.onChanged(shop.name);
        setState(() => _selectedShop = shop);
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
                widget.onTap?.call();
                _showShopDialog(context);
              },
              child: Text(
                _selectedShop?.name ?? widget.selectedShopName ?? l10n.shopHint,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      (_selectedShop != null || widget.selectedShopName != null)
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
            SizedBox(height: 24),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchShopHint,
                prefixIcon: Icon(
                  Icons.search,
                  color: colorScheme.onSurfaceVariant,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.outline,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                  ),
                ),
              ),
              onChanged: (value) => setState(() => _searchText = value),
            ),
            SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: _buildShopList(),
            ),
            _buildCreateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildShopList() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    if (_filteredShops.isEmpty) {
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
      itemCount: _filteredShops.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final shop = _filteredShops[index];
        final isSelected = shop.name == widget.selectedShop;

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
          onTap: () => Navigator.pop(context, shop),
        );
      },
    );
  }

  Widget _buildCreateButton() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    if (_searchText.isNotEmpty &&
        !_filteredShops.any((s) => s.name == _searchText)) {
      return Padding(
        padding: EdgeInsets.only(top: 16),
        child: ElevatedButton.icon(
          onPressed: () => Navigator.pop(
            context,
            Shop(
              id: '',
              name: _searchText,
              accountBookId: widget.accountBookId,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          ),
          icon: Icon(Icons.add, size: 18),
          label: Text(l10n.addShopButton(_searchText)),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }
}
