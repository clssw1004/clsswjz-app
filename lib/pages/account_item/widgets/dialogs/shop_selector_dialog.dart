import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';
import '../../../../models/shop.dart';

class ShopSelectorDialog extends StatefulWidget {
  final List<String> selectedShopCodes;
  final List<ShopOption> shops;
  final Function(List<String>) onShopCodesChanged;

  const ShopSelectorDialog({
    Key? key,
    required this.selectedShopCodes,
    required this.shops,
    required this.onShopCodesChanged,
  }) : super(key: key);

  @override
  State<ShopSelectorDialog> createState() => _ShopSelectorDialogState();
}

class _ShopSelectorDialogState extends State<ShopSelectorDialog> {
  late List<String> _selectedShopCodes;

  @override
  void initState() {
    super.initState();
    _selectedShopCodes = List.from(widget.selectedShopCodes);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return AlertDialog(
      title: Text(l10n.selectShopTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.shops.length,
          itemBuilder: (context, index) {
            final shop = widget.shops[index];
            final isSelected = _selectedShopCodes.contains(shop.code);
            return CheckboxListTile(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedShopCodes.add(shop.code);
                  } else {
                    _selectedShopCodes.remove(shop.code);
                  }
                });
              },
              title: Text(shop.name),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            widget.onShopCodesChanged(_selectedShopCodes);
            Navigator.pop(context);
          },
          child: Text(l10n.confirm),
        ),
      ],
    );
  }
} 