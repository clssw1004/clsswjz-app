import 'package:flutter/material.dart';
import '../../models/form_selector.dart';
import '../../l10n/l10n.dart';

class FormSelectorDialog<T> extends StatefulWidget {
  final List<T> items;
  final String? selectedValue;
  final FormSelectorConfig<T> config;
  final ValueChanged<String?> onSelected;
  final ValueChanged<String>? onItemAdded;

  const FormSelectorDialog({
    Key? key,
    required this.items,
    this.selectedValue,
    required this.config,
    required this.onSelected,
    this.onItemAdded,
  }) : super(key: key);

  @override
  State<FormSelectorDialog<T>> createState() => _FormSelectorDialogState<T>();
}

class _FormSelectorDialogState<T> extends State<FormSelectorDialog<T>> {
  final TextEditingController _searchController = TextEditingController();
  List<T> _filteredItems = [];
  bool _showAddButton = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(widget.items);
        _showAddButton = false;
      } else {
        _filteredItems = widget.items.where((item) {
          final label = _getLabel(item).toLowerCase();
          return label.contains(query.toLowerCase());
        }).toList();
        _showAddButton = _filteredItems.isEmpty;
      }
    });
  }

  String _getValue(T item) {
    if (item is Map) {
      return (item as Map)[widget.config.valueField] as String;
    }
    return (item as dynamic).toJson()[widget.config.valueField] as String;
  }

  String _getLabel(T item) {
    if (item is Map) {
      return (item as Map)[widget.config.labelField] as String;
    }
    return (item as dynamic).toJson()[widget.config.labelField] as String;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                widget.config.dialogTitle,
                style: theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: widget.config.searchHint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterItems('');
                          },
                          tooltip: L10n.of(context).clear,
                        ),
                      if (_showAddButton &&
                          widget.config.showAddButton &&
                          widget.onItemAdded != null)
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            if (_searchController.text.isNotEmpty) {
                              widget.onItemAdded?.call(_searchController.text);
                              Navigator.pop(context);
                            }
                          },
                          tooltip: widget.config.addItemTemplate
                              .replaceAll('{name}', _searchController.text),
                        ),
                    ],
                  ),
                  filled: true,
                  fillColor:
                      colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: _filterItems,
                onSubmitted: (value) {
                  if (_showAddButton &&
                      widget.config.showAddButton &&
                      widget.onItemAdded != null &&
                      value.isNotEmpty) {
                    widget.onItemAdded?.call(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: _filteredItems.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off_outlined,
                                size: 48,
                                color: colorScheme.onSurfaceVariant
                                    .withOpacity(0.38),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                widget.config.noDataText,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          final isSelected =
                              _getValue(item) == widget.selectedValue;

                          return ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 24),
                            title: Text(
                              _getLabel(item),
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
                              widget.onSelected(_getValue(item));
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
