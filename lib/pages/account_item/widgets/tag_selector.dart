import 'package:flutter/material.dart';
import '../../../models/models.dart';
import '../providers/account_item_provider.dart';
import 'package:provider/provider.dart';
import '../../../l10n/l10n.dart';
import '../../../models/form_selector.dart';
import '../../../widgets/form/form_selector_field.dart';

class TagSelector extends StatelessWidget {
  final String? selectedTag;
  final ValueChanged<String?> onChanged;
  final VoidCallback? onTap;

  const TagSelector({
    Key? key,
    this.selectedTag,
    required this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Consumer<AccountItemProvider>(
      builder: (context, provider, _) {
        return FormSelectorField<AccountSymbol>(
          items: provider.tags,
          value: selectedTag,
          icon: Icons.local_offer_outlined,
          placeholder: l10n.selectTagHint,
          config: FormSelectorConfig<AccountSymbol>(
            idField: 'code',
            labelField: 'name',
            valueField: 'name',
            dialogTitle: l10n.bookTag,
            searchHint: l10n.searchTagHint,
            noDataText: l10n.bookTag,
            addItemTemplate: '',
            showSearch: true,
            showAddButton: true,
            mode: FormSelectorMode.badge,
            gridMaxCount: 9,
            alignGrid: true,
          ),
          callbacks: FormSelectorCallbacks(
            onChanged: onChanged,
            onTap: onTap,
            onItemAdded: (name) async {
              final symbol = AccountSymbol(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                code: name,
                symbolType: 'TAG',
                accountBookId: provider.selectedBook?.id ?? '',
              );
              provider.addTag(symbol);
              onChanged(symbol.name);
            },
          ),
        );
      },
    );
  }
}
