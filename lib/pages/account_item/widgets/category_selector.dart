import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_item_provider.dart';
import './category_dialog.dart';

class CategorySelector extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String> onChanged;

  const CategorySelector({
    Key? key,
    this.selectedCategory,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final provider = Provider.of<AccountItemProvider>(context);
    final displayCategories = provider.displayCategories.take(11).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...displayCategories.map((category) {
              final isSelected = selectedCategory == category;
              return SizedBox(
                width: 85,
                child: Material(
                  color: isSelected ? themeColor.withOpacity(0.12) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () => onChanged(category),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? themeColor : Colors.grey[400]!,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? themeColor : Colors.grey[700],
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            // 更多按钮
            SizedBox(
              width: 85,
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () => _showCategoryDialog(context, provider),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: themeColor.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.more_horiz,
                          size: 16,
                          color: themeColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '全部',
                          style: TextStyle(
                            fontSize: 14,
                            color: themeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showCategoryDialog(BuildContext context, AccountItemProvider provider) {
    showDialog(
      context: context,
      builder: (context) => CategoryDialog(
        categories: provider.categories,
        selectedCategory: selectedCategory,
        onSelected: (category) {
          if (!provider.displayCategories.take(11).contains(category)) {
            provider.updateDisplayCategories(category);
          }
          onChanged(category);
          Navigator.pop(context);
        },
      ),
    );
  }
} 