import 'package:flutter/material.dart';
import '../../../models/models.dart';
import '../../../theme/app_theme.dart';
import '../providers/account_item_provider.dart';
import 'package:provider/provider.dart';
import '../../../l10n/l10n.dart';
import '../../../models/form_selector.dart';
import '../../../widgets/form/form_selector_field.dart';

class CategorySelector extends StatelessWidget {
  static const String NO_CATEGORY = 'NO_CATEGORY';

  final String? selectedCategory;
  final ValueChanged<String?> onChanged;
  final VoidCallback? onTap;

  const CategorySelector({
    Key? key,
    this.selectedCategory,
    required this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Consumer<AccountItemProvider>(
      builder: (context, provider, _) {
        return FormSelectorField<Category>(
          items: [
            ...provider.filteredCategories,
          ],
          value: selectedCategory,
          icon: Icons.category_outlined,
          placeholder: l10n.categoryHint,
          config: FormSelectorConfig<Category>(
            idField: 'categoryCode',
            labelField: 'name',
            valueField: 'name',
            dialogTitle: l10n.selectCategoryTitle,
            searchHint: l10n.searchCategoryHint,
            noDataText: l10n.noAvailableCategories,
            addItemTemplate: l10n.addButtonWith('分类'),
            showSearch: true,
            showAddButton: true,
            mode: FormSelectorMode.grid,
            gridMaxCount: 9,
            alignGrid: true,
          ),
          callbacks: FormSelectorCallbacks(
            onChanged: onChanged,
            onItemAdded: (name) async {
              final category = Category(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                accountBookId: provider.selectedBook?.id ?? '',
                categoryType: provider.transactionType,
              );
              provider.addCategory(name);
              onChanged(category.name);
            },
            onTap: onTap,
          ),
        );
      },
    );
  }
}
