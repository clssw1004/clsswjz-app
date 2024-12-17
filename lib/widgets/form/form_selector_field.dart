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
  final _gridKey = GlobalKey();

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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!widget.config.showGridSelector)
              Container(
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
              ),
            if (widget.config.showGridSelector) _buildGridSelector(),
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

    return Wrap(
      key: _gridKey,
      spacing: 8,
      runSpacing: 8,
      children: [
        ...displayItems.map((item) {
          final isSelected = _getValue(item) == widget.value;

          return InkWell(
            onTap: () => widget.callbacks.onChanged(_getValue(item)),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _getLabel(item),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w500 : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }),

        // 更多按钮
        if (widget.items.length > widget.config.gridMaxCount)
          InkWell(
            onTap: () => _showSelectorDialog(context),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                L10n.of(context).more,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
          if (widget.config.showGridSelector) {
            setState(() {});
          }
        },
        onItemAdded: (value) {
          widget.callbacks.onItemAdded?.call(value);
          if (widget.config.showGridSelector) {
            setState(() {});
          }
        },
      ),
    );
  }
}
