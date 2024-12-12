import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_item_provider.dart';
import './category_dialog.dart';
import '../../../l10n/l10n.dart';
import '../../../models/category.dart';

class CategoryGridSelector extends StatelessWidget {
  static const int _maxDisplayCount = 9;
  static const int _firstRowCount = 3;
  static const int _secondRowCount = 3;
  static const int _thirdRowCount = 3;
  static const double _horizontalSpacing = 8.0;

  final String? selectedCategory;
  final ValueChanged<String> onChanged;
  final bool isRequired;

  const CategoryGridSelector({
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outlineVariant.withOpacity(0.5),
                  ),
                ),
              ),
              child: Consumer<AccountItemProvider>(
                builder: (context, provider, _) {
                  final categories = provider.filteredCategories;
                  final displayCategories = _getDisplayCategories(categories);
                  final showMoreButton =
                      categories.length > _maxDisplayCount - 1;

                  return Column(
                    children: [
                      // 第一行
                      _buildCategoryRow(
                        context,
                        displayCategories.take(_firstRowCount).toList(),
                        _firstRowCount,
                      ),
                      SizedBox(height: 8),
                      // 第二行
                      _buildCategoryRow(
                        context,
                        displayCategories
                            .skip(_firstRowCount)
                            .take(_secondRowCount)
                            .toList(),
                        _secondRowCount,
                      ),
                      SizedBox(height: 8),
                      // 第三行
                      _buildCategoryRow(
                        context,
                        [
                          ...displayCategories
                              .skip(_firstRowCount + _secondRowCount)
                              .take(_thirdRowCount)
                              .toList(),
                          if (showMoreButton)
                            Category(
                              id: '',
                              name: l10n.more,
                              accountBookId: '',
                              categoryType: '',
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                            ),
                        ],
                        _thirdRowCount,
                      ),
                    ],
                  );
                },
              ),
            ),
            if (field.hasError)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  field.errorText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryRow(
    BuildContext context,
    List<Category> categories,
    int maxCount,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(maxCount, (index) {
          if (index < categories.length) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index < maxCount - 1 ? _horizontalSpacing : 0,
                ),
                child: _buildCategoryItem(context, categories[index]),
              ),
            );
          }
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index < maxCount - 1 ? _horizontalSpacing : 0,
              ),
              child: SizedBox(),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, Category category) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = category.name == selectedCategory;
    final isMoreButton = category.id.isEmpty;

    return GestureDetector(
      onTap: () {
        if (isMoreButton) {
          _showCategoryDialog(context);
        } else {
          onChanged(category.name);
        }
      },
      child: Container(
        height: 36,
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.light
              ? Colors.white
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isSelected ? colorScheme.primary : colorScheme.outlineVariant,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isMoreButton)
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 16,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            if (!isMoreButton) SizedBox(width: 4),
            Flexible(
              child: Text(
                category.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      isSelected ? colorScheme.primary : colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Category> _getDisplayCategories(List<Category> allCategories) {
    if (selectedCategory == null) {
      return allCategories.take(_maxDisplayCount - 1).toList();
    }

    // 如果选中的分类不在前8个中，则替换最后一个
    final selectedCategoryObj = allCategories.firstWhere(
      (c) => c.name == selectedCategory,
      orElse: () => allCategories.first,
    );

    final displayCategories = allCategories.take(_maxDisplayCount - 1).toList();
    if (!displayCategories.contains(selectedCategoryObj)) {
      if (displayCategories.length >= _maxDisplayCount - 1) {
        displayCategories[_maxDisplayCount - 2] = selectedCategoryObj;
      } else {
        displayCategories.add(selectedCategoryObj);
      }
    }

    return displayCategories;
  }

  void _showCategoryDialog(BuildContext context) {
    if (!context.mounted) return;

    final provider = context.read<AccountItemProvider>();
    final categories = provider.filteredCategories.map((c) => c.name).toList();

    showDialog(
      context: context,
      builder: (dialogContext) => CategoryDialog(
        categories: categories,
        selectedCategory: selectedCategory,
        onSelected: (category) {
          if (context.mounted) {
            onChanged(category);
          }
        },
        onCategoryAdded: (newCategory) {
          if (context.mounted) {
            provider.addCategory(newCategory);
          }
        },
      ),
    );
  }
}
