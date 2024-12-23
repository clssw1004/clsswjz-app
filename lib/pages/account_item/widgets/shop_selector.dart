import 'package:flutter/material.dart';
import '../../../models/models.dart';
import '../providers/account_item_info_provider.dart';
import 'package:provider/provider.dart';
import '../../../l10n/l10n.dart';
import '../../../models/form_selector.dart';
import '../../../widgets/form/form_selector_field.dart';

class ShopSelector extends StatelessWidget {
  static const String NO_SHOP = 'NO_SHOP';

  final String accountBookId;
  final ValueChanged<String?> onChanged;
  final VoidCallback? onTap;
  final String? selectedShopName;

  const ShopSelector({
    Key? key,
    required this.accountBookId,
    required this.onChanged,
    this.onTap,
    this.selectedShopName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Consumer<AccountItemInfoProvider>(
      builder: (context, provider, _) {
        return FormSelectorField<Shop>(
          items: [
            Shop(
              id: NO_SHOP,
              name: l10n.noShop,
              code: NO_SHOP,
              accountBookId: accountBookId,
            ),
            ...provider.shops,
          ],
          value: selectedShopName,
          icon: Icons.store_outlined,
          placeholder: l10n.shopHint,
          config: FormSelectorConfig<Shop>(
            idField: 'code',
            labelField: 'name',
            valueField: 'name',
            dialogTitle: l10n.selectShopTitle,
            searchHint: l10n.searchShopHint,
            noDataText: l10n.noAvailableShops,
            addItemTemplate: l10n.addButtonWith('商户'),
            showSearch: true,
            showAddButton: true,
            mode: FormSelectorMode.standard,
            gridMaxCount: 9,
            gridRowCount: 3,
            alignGrid: true,
          ),
          callbacks: FormSelectorCallbacks(
            onChanged: onChanged,
            onItemAdded: (name) async {
              final newShop = Shop(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                accountBookId: accountBookId,
              );
              await provider.addShop(newShop);
              onChanged(newShop.name);
            },
            onTap: onTap,
          ),
        );
      },
    );
  }
}
