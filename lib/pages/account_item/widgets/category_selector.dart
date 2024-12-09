import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_item_provider.dart';
import './category_dialog.dart';
import '../../../l10n/l10n.dart';

class CategorySelector extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String> onChanged;
  final bool isRequired;

  const CategorySelector({
    Key? key,
    this.selectedCategory,
    required this.onChanged,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return FormField<String>(
      initialValue: selectedCategory,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          print(
              'Category validation failed: value=$value, selectedCategory=$selectedCategory');
          return l10n.pleaseSelectCategory;
        }
        return null;
      },
      onSaved: (value) {
        if (value != selectedCategory) {
          onChanged(value ?? '');
        }
      },
      builder: (FormFieldState<String> field) {
        if (field.value != selectedCategory) {
          Future.microtask(() => field.didChange(selectedCategory));
        }

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
                Icons.category_outlined,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Consumer<AccountItemProvider>(
                  builder: (context, provider, _) {
                    final isValidCategory = selectedCategory == null ||
                        provider.filteredCategories
                            .any((c) => c.name == selectedCategory);

                    if (!isValidCategory && selectedCategory != null) {
                      Future.microtask(() => onChanged(''));
                    }

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _showCategoryDialog(context),
                      child: Text(
                        selectedCategory ?? l10n.categoryHint,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: selectedCategory != null
                              ? colorScheme.onSurface
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, size: 18),
                onPressed: () => _showCategoryDialog(context),
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
      },
    );
  }

  void _showCategoryDialog(BuildContext context) {
    final provider = Provider.of<AccountItemProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => CategoryDialog(
        categories: provider.filteredCategories.map((c) => c.name).toList(),
        selectedCategory: selectedCategory,
        onSelected: (category) {
          onChanged(category);
          Navigator.pop(context);
        },
      ),
    );
  }
}
