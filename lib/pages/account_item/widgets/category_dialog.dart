import 'package:flutter/material.dart';

class CategoryDialog extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String> onSelected;

  const CategoryDialog({
    Key? key,
    required this.categories,
    this.selectedCategory,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final TextEditingController controller = TextEditingController();

    return AlertDialog(
      title: Text(
        '选择分类',
        style:
            theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: '输入新分类',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add, color: colorScheme.primary),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      onSelected(controller.text.trim());
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colorScheme.primary),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  onSelected(value.trim());
                }
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  scrollbarTheme: ScrollbarThemeData(
                    thumbColor: WidgetStateProperty.all(colorScheme.primary),
                  ),
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categories.map((category) {
                        final isSelected = selectedCategory == category;
                        return ChoiceChip(
                          label: Text(
                            category,
                            style: TextStyle(
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurface,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: colorScheme.primary,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          onSelected: (_) => onSelected(category),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
