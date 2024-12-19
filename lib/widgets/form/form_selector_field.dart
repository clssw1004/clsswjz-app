import 'package:flutter/material.dart';
import '../../models/form_selector.dart';
import '../../l10n/l10n.dart';
import 'form_selector_dialog.dart';

class FormSelectorField<T> extends StatefulWidget {
  final List<T> items;
  final FormSelectorConfig<T> config;
  final FormSelectorCallbacks<T> callbacks;
  final String? value;
  final bool required;
  final IconData icon;
  final String placeholder;

  const FormSelectorField({
    Key? key,
    required this.items,
    required this.config,
    required this.callbacks,
    this.value,
    this.required = false,
    required this.icon,
    required this.placeholder,
  }) : super(key: key);

  @override
  State<FormSelectorField<T>> createState() => _FormSelectorFieldState<T>();
}

class _FormSelectorFieldState<T> extends State<FormSelectorField<T>> {
  String? _getDisplayText() {
    if (widget.value == null) return null;

    try {
      final item = widget.items.firstWhere(
        (item) => _getValue(item) == widget.value,
      );
      return _getLabel(item);
    } catch (e) {
      return null;
    }
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

    return FormField<String>(
      initialValue: widget.value,
      validator: widget.required
          ? (value) =>
              value?.isEmpty ?? true ? L10n.of(context).fieldRequired : null
          : null,
      builder: (field) {
        Widget selector;

        switch (widget.config.mode) {
          case FormSelectorMode.standard:
            selector = Container(
              height: 48,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: field.hasError
                        ? colorScheme.error
                        : colorScheme.outlineVariant.withOpacity(0.5),
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        widget.callbacks.onTap?.call();
                        _showSelectorDialog(context);
                      },
                      child: Text(
                        _getDisplayText() ?? widget.placeholder,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: _getDisplayText() != null
                              ? colorScheme.onSurface
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 18),
                    onPressed: () => _showSelectorDialog(context),
                    color: colorScheme.onSurfaceVariant,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
            );
            break;
          case FormSelectorMode.grid:
            selector = _buildGridSelector();
            break;
          case FormSelectorMode.badge:
            selector = Align(
              alignment: Alignment.centerLeft,
              child: _buildBadgeSelector(),
            );
            break;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            selector,
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 12),
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

  Widget _buildGridSelector() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final displayItems = _getDisplayItems();

    if (displayItems.isEmpty) {
      return Container();
    }

    final itemGroups = displayItems.fold<List<List<T>>>(
      [],
      (list, item) {
        if (list.isEmpty || list.last.length >= widget.config.gridRowCount) {
          list.add([]);
        }
        list.last.add(item);
        return list;
      },
    );

    if (itemGroups.isEmpty) {
      return Container();
    }

    final lastRowSpace = widget.config.gridRowCount - itemGroups.last.length;
    final showMoreInLastRow =
        widget.items.length > widget.config.gridMaxCount && lastRowSpace > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...itemGroups.map((rowItems) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                ...rowItems.map((item) {
                  final isSelected = _getValue(item) == widget.value;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: InkWell(
                        onTap: () =>
                            widget.callbacks.onChanged(_getValue(item)),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.outlineVariant,
                            ),
                          ),
                          child: Text(
                            _getLabel(item),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurface,
                              fontWeight: isSelected ? FontWeight.w500 : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                if (showMoreInLastRow && itemGroups.last == rowItems)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: InkWell(
                        onTap: () => _showSelectorDialog(context),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                          child: Text(
                            '${L10n.of(context).more}>>',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (!showMoreInLastRow)
                  ...List.generate(
                    widget.config.gridRowCount - rowItems.length,
                    (index) => Expanded(child: Container()),
                  ),
              ],
            ),
          );
        }),
        if (widget.items.length > widget.config.gridMaxCount &&
            !showMoreInLastRow)
          InkWell(
            onTap: () => _showSelectorDialog(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                ),
              ),
              child: Text(
                L10n.of(context).more,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  List<T> _getDisplayItems() {
    if (widget.items.length <= widget.config.gridMaxCount) {
      return widget.items;
    }

    // 如果选中项不在前N个中,则替换最后一个
    final displayItems =
        widget.items.take(widget.config.gridMaxCount - 1).toList();

    if (widget.value != null) {
      // 修改为安全的查找方式
      T? selectedItem;
      try {
        selectedItem = widget.items.firstWhere(
          (item) => _getValue(item) == widget.value,
        );
      } catch (_) {
        selectedItem = null;
      }

      if (selectedItem != null && !displayItems.contains(selectedItem)) {
        displayItems[widget.config.gridMaxCount - 2] = selectedItem;
      }
    }

    return displayItems;
  }

  void _showSelectorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FormSelectorDialog<T>(
        items: widget.items,
        selectedValue: widget.value,
        config: widget.config,
        onSelected: (value) {
          widget.callbacks.onChanged(value);
          setState(() {});
        },
        onItemAdded: (value) {
          widget.callbacks.onItemAdded?.call(value);
          setState(() {});
        },
      ),
    );
  }

  Widget _buildBadgeSelector() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasValue = widget.value != null;

    return InkWell(
      onTap: () {
        widget.callbacks.onTap?.call();
        _showSelectorDialog(context);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: hasValue ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasValue ? colorScheme.primary : colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              size: 16,
              color: hasValue
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 4),
            Text(
              hasValue ? (_getDisplayText() ?? '') : widget.config.dialogTitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: hasValue
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
                fontWeight: hasValue ? FontWeight.w500 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
