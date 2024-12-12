import 'package:flutter/material.dart';
import '../../../l10n/l10n.dart';

class CategoryDialog extends StatefulWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String> onSelected;
  final ValueChanged<String>? onCategoryAdded;

  const CategoryDialog({
    Key? key,
    required this.categories,
    this.selectedCategory,
    required this.onSelected,
    this.onCategoryAdded,
  }) : super(key: key);

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredCategories = [];
  bool _showAddButton = false;

  @override
  void initState() {
    super.initState();
    _filteredCategories = List.from(widget.categories);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = List.from(widget.categories);
        _showAddButton = false;
      } else {
        _filteredCategories = widget.categories
            .where((category) =>
                category.toLowerCase().contains(query.toLowerCase()))
            .toList();
        _showAddButton = _filteredCategories.isEmpty;
      }
    });
  }

  void _addNewCategory(String name) {
    setState(() {
      if (!widget.categories.contains(name)) {
        widget.categories.add(name);
        widget.onCategoryAdded?.call(name);
      }
      _filteredCategories = List.from(widget.categories);
      _searchController.clear();
      _showAddButton = false;
    });
    widget.onSelected(name);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  l10n.selectCategoryTitle,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.searchCategoryHint,
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterCategories('');
                            },
                          ),
                        if (_showAddButton)
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              if (_searchController.text.isNotEmpty) {
                                _addNewCategory(_searchController.text);
                              }
                            },
                          ),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withOpacity(0.5),
                      ),
                    ),
                  ),
                  onChanged: _filterCategories,
                ),
              ),
              SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = _filteredCategories[index];
                    final isSelected = category == widget.selectedCategory;

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 24),
                      title: Text(
                        category,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isSelected ? colorScheme.primary : null,
                        ),
                      ),
                      leading: Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected ? colorScheme.primary : null,
                        size: 20,
                      ),
                      onTap: () {
                        widget.onSelected(category);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: Text(l10n.cancelButton),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
