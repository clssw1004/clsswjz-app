import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../utils/message_helper.dart';
import '../../../models/models.dart';

class ShopSelector extends StatefulWidget {
  final String? selectedShop;
  final String accountBookId;
  final ValueChanged<String?> onChanged;
  final VoidCallback? onTap;

  const ShopSelector({
    Key? key,
    this.selectedShop,
    required this.accountBookId,
    required this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  State<ShopSelector> createState() => _ShopSelectorState();
}

class _ShopSelectorState extends State<ShopSelector> {
  List<Shop> _shops = [];
  Shop? _selectedShop;

  @override
  void initState() {
    super.initState();
    _loadShops();
  }

  @override
  void didUpdateWidget(ShopSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedShop != widget.selectedShop) {
      _loadShops();
    }
  }

  Future<void> _loadShops() async {
    try {
      _shops = await ApiService.getShops(widget.accountBookId);

      if (widget.selectedShop != null) {
        final selectedShop = _shops.firstWhere(
          (shop) => shop.id == widget.selectedShop,
          orElse: () => throw '未找到商家',
        );
        _selectedShop = selectedShop;
      }

      setState(() {});
    } catch (e) {
      if (mounted) {
        MessageHelper.showError(context, message: e.toString());
      }
    }
  }

  Future<void> _showShopDialog() async {
    final result = await showDialog<Shop>(
      context: context,
      builder: (context) => _ShopDialog(
        shops: _shops,
        selectedShop: widget.selectedShop,
        accountBookId: widget.accountBookId,
        onShopsUpdated: (shops) {
          setState(() => _shops = shops);
        },
      ),
    );

    if (result != null) {
      widget.onChanged(result.id);
      setState(() {
        _selectedShop = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                _showShopDialog();
              },
              child: Text(
                _selectedShop?.name ?? '选择商家',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _selectedShop != null
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              size: 18,
            ),
            onPressed: _showShopDialog,
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
              '选择商家',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索或输入新商家',
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

    return ListView.builder(
      itemCount: _filteredShops.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final shop = _filteredShops[index];
        final isSelected = shop.id == widget.selectedShop;

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
    final colorScheme = Theme.of(context).colorScheme;

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
          label: Text('添加"$_searchText"'),
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
