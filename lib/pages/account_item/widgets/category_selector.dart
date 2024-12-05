import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_item_provider.dart';
import './category_dialog.dart';

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
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _showCategoryDialog(context, provider),
                  child: Text(
                    selectedCategory ?? '选择分类',
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
            icon: Icon(
              Icons.chevron_right,
              size: 18,
            ),
            onPressed: () {},
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

  void _showCategoryDialog(BuildContext context, AccountItemProvider provider) {
    showDialog(
      context: context,
      builder: (context) => CategoryDialog(
        categories: provider.categories.map((c) => c.name).toList(),
        selectedCategory: selectedCategory,
        onSelected: (category) {
          if (!provider.categories.any((c) => c.name == category)) {
            provider.updateDisplayCategories(category);
          }
          onChanged(category);
          Navigator.pop(context);
        },
      ),
    );
  }
}
