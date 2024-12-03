import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../utils/message_helper.dart';

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
  List<Map<String, dynamic>> _shops = [];
  bool _isLoading = false;
  String? _selectedShopName;

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
    setState(() => _isLoading = true);
    try {
      _shops = await ApiService.fetchShops(context, widget.accountBookId);

      if (widget.selectedShop != null) {
        final selectedShop = _shops.firstWhere(
          (shop) => shop['shopCode'] == widget.selectedShop,
          orElse: () => {'name': '', 'shopCode': widget.selectedShop},
        );
        _selectedShopName = selectedShop['name'];

        if (_selectedShopName?.isEmpty ?? true) {
          try {
            final shopInfo = await ApiService.fetchShopByCode(
              context,
              widget.accountBookId,
              widget.selectedShop!,
            );
            if (shopInfo != null) {
              _selectedShopName = shopInfo['name'];
              if (!_shops.any((s) => s['shopCode'] == shopInfo['shopCode'])) {
                _shops = [shopInfo, ..._shops];
              }
            }
          } catch (e) {
            print('Failed to fetch shop info: $e');
          }
        }
      }

      setState(() {});
    } catch (e) {
      if (mounted) {
        MessageHelper.showError(context, message: e.toString());
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showShopDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _ShopDialog(
        shops: _shops,
        selectedShopCode: widget.selectedShop,
        accountBookId: widget.accountBookId,
        onShopsUpdated: (shops) {
          setState(() => _shops = shops);
        },
      ),
    );

    if (result != null) {
      widget.onChanged(result['name']);
      setState(() {
        _selectedShopName = result['name'];
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
                _selectedShopName ?? '选择商家',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _selectedShopName != null
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
  final List<Map<String, dynamic>> shops;
  final String? selectedShopCode;
  final String accountBookId;
  final ValueChanged<List<Map<String, dynamic>>> onShopsUpdated;

  const _ShopDialog({
    Key? key,
    required this.shops,
    this.selectedShopCode,
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

  List<Map<String, dynamic>> get _filteredShops {
    if (_searchText.isEmpty) return widget.shops;
    return widget.shops
        .where((shop) => shop['name']
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
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredShops.length,
                itemBuilder: (context, index) {
                  final shop = _filteredShops[index];
                  final isSelected =
                      shop['shopCode'] == widget.selectedShopCode;

                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    title: Text(
                      shop['name'] ?? '',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
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
              ),
            ),
            if (_searchText.isNotEmpty &&
                !_filteredShops.any((s) => s['name'] == _searchText))
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pop(context, {'name': _searchText}),
                  icon: Icon(Icons.add, size: 18),
                  label: Text('添加"$_searchText"'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
