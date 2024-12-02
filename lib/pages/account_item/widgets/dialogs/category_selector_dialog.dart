import 'package:flutter/material.dart';

class CategorySelectorDialog extends StatefulWidget {
  final List<String> categories;
  final List<String> selectedCategories;
  final Function(List<String>) onCategoriesChanged;

  const CategorySelectorDialog({
    Key? key,
    required this.categories,
    required this.selectedCategories,
    required this.onCategoriesChanged,
  }) : super(key: key);

  @override
  State<CategorySelectorDialog> createState() => _CategorySelectorDialogState();
}

class _CategorySelectorDialogState extends State<CategorySelectorDialog> {
  late List<String> _selectedCategories;

  @override
  void initState() {
    super.initState();
    _selectedCategories = List.from(widget.selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(24, 20, 16, 0),
      contentPadding: EdgeInsets.fromLTRB(20, 12, 20, 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '选择分类',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          if (_selectedCategories.isNotEmpty)
            Text(
              '已选${_selectedCategories.length}个',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
        ],
      ),
      content: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.start,
            children: widget.categories.map((category) {
              final isSelected = _selectedCategories.contains(category);
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedCategories.add(category);
                    } else {
                      _selectedCategories.remove(category);
                    }
                  });
                },
                selectedColor: colorScheme.primaryContainer,
                checkmarkColor: colorScheme.onPrimaryContainer,
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurface,
                ),
                padding: EdgeInsets.symmetric(horizontal: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        if (_selectedCategories.isNotEmpty)
          TextButton(
            onPressed: () {
              setState(() => _selectedCategories.clear());
            },
            child: Text(
              '清除选择',
              style: TextStyle(
                color: colorScheme.error,
              ),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            widget.onCategoriesChanged(_selectedCategories);
            Navigator.pop(context);
          },
          child: Text('确定'),
        ),
      ],
      actionsPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
    );
  }
}
