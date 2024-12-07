import 'package:flutter/material.dart';
import 'dialogs/type_selector_dialog.dart';
import 'dialogs/category_selector_dialog.dart';
import 'dialogs/amount_range_dialog.dart';
import 'dialogs/date_range_dialog.dart';
import '../../../l10n/l10n.dart';
import '../../../services/storage_service.dart';
import '../../../constants/storage_keys.dart';

class FilterSection extends StatefulWidget {
  final bool isExpanded;
  final String? selectedType;
  final List<String> selectedCategories;
  final double? minAmount;
  final double? maxAmount;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> categories;
  final Function(String?) onTypeChanged;
  final Function(List<String>) onCategoriesChanged;
  final Function(double?) onMinAmountChanged;
  final Function(double?) onMaxAmountChanged;
  final Function(DateTime?) onStartDateChanged;
  final Function(DateTime?) onEndDateChanged;
  final VoidCallback onClearFilter;

  const FilterSection({
    Key? key,
    required this.isExpanded,
    this.selectedType,
    required this.selectedCategories,
    this.minAmount,
    this.maxAmount,
    this.startDate,
    this.endDate,
    required this.categories,
    required this.onTypeChanged,
    required this.onCategoriesChanged,
    required this.onMinAmountChanged,
    required this.onMaxAmountChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onClearFilter,
  }) : super(key: key);

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  bool _isPinned = false;

  @override
  void initState() {
    super.initState();
    _loadPinnedState();
  }

  Future<void> _loadPinnedState() async {
    final isPinned = StorageService.getBool(StorageKeys.filterPanelPinned, defaultValue: false);
    if (mounted) {
      setState(() => _isPinned = isPinned);
    }
  }

  Future<void> _togglePinned() async {
    final newState = !_isPinned;
    await StorageService.setBool(StorageKeys.filterPanelPinned, newState);
    if (mounted) {
      setState(() => _isPinned = newState);
    }
  }

  bool get _hasAnyFilter =>
      widget.selectedType != null ||
      widget.selectedCategories.isNotEmpty ||
      widget.minAmount != null ||
      widget.maxAmount != null ||
      widget.startDate != null ||
      widget.endDate != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: (_isPinned || widget.isExpanded) ? null : 0,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth > 600 ? 32 : 12,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 8),
                  _buildFilterGrid(context),
                ],
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: IconButton(
                onPressed: _togglePinned,
                icon: Icon(
                  _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  size: 16,
                ),
                tooltip: _isPinned ? l10n.unpin : l10n.pin,
                style: IconButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(8),
                  minimumSize: const Size(32, 32),
                  foregroundColor: _isPinned ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.filterConditions,
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: _hasAnyFilter ? widget.onClearFilter : null,
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: const Size(0, 28),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            l10n.clearFilter,
            style: theme.textTheme.labelSmall?.copyWith(
              color: _hasAnyFilter ? colorScheme.primary : colorScheme.outline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterGrid(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final buttonWidth = isSmallScreen 
        ? (screenWidth - 44) / 2
        : 120.0;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        SizedBox(
          width: buttonWidth.toDouble(),
          child: _buildTypeButton(context),
        ),
        SizedBox(
          width: buttonWidth.toDouble(),
          child: _buildCategoryButton(context),
        ),
        SizedBox(
          width: buttonWidth.toDouble(),
          child: _buildAmountButton(context),
        ),
        SizedBox(
          width: buttonWidth.toDouble(),
          child: _buildDateButton(context),
        ),
      ],
    );
  }

  Widget _buildTypeButton(BuildContext context) {
    final l10n = L10n.of(context);
    return _FilterButton(
      label: widget.selectedType == null
          ? l10n.type
          : widget.selectedType == 'EXPENSE'
              ? l10n.expense
              : l10n.income,
      isSelected: widget.selectedType != null,
      onPressed: () => _showTypeSelector(context),
    );
  }

  Widget _buildCategoryButton(BuildContext context) {
    final l10n = L10n.of(context);
    return _FilterButton(
      label: widget.selectedCategories.isEmpty
          ? l10n.category
          : l10n.selectedCount(widget.selectedCategories.length),
      isSelected: widget.selectedCategories.isNotEmpty,
      onPressed: () => _showCategorySelector(context),
    );
  }

  Widget _buildAmountButton(BuildContext context) {
    final l10n = L10n.of(context);
    final hasAmountFilter = widget.minAmount != null || widget.maxAmount != null;
    return _FilterButton(
      label: hasAmountFilter ? l10n.filtered : l10n.amount,
      isSelected: hasAmountFilter,
      onPressed: () => _showAmountRangeDialog(context),
    );
  }

  Widget _buildDateButton(BuildContext context) {
    final l10n = L10n.of(context);
    final hasDateFilter = widget.startDate != null || widget.endDate != null;
    return _FilterButton(
      label: hasDateFilter ? l10n.filtered : l10n.date,
      isSelected: hasDateFilter,
      onPressed: () => _showDateRangeDialog(context),
    );
  }

  void _showTypeSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TypeSelectorDialog(
        selectedType: widget.selectedType,
        onTypeSelected: (type) {
          widget.onTypeChanged(type);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showCategorySelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CategorySelectorDialog(
        categories: widget.categories,
        selectedCategories: widget.selectedCategories,
        onCategoriesChanged: widget.onCategoriesChanged,
      ),
    );
  }

  void _showAmountRangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AmountRangeDialog(
        minAmount: widget.minAmount,
        maxAmount: widget.maxAmount,
        onMinAmountChanged: widget.onMinAmountChanged,
        onMaxAmountChanged: widget.onMaxAmountChanged,
      ),
    );
  }

  void _showDateRangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DateRangeDialog(
        startDate: widget.startDate,
        endDate: widget.endDate,
        onStartDateChanged: widget.onStartDateChanged,
        onEndDateChanged: widget.onEndDateChanged,
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(0, 28),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outline,
          width: isSelected ? 1.5 : 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        backgroundColor: isSelected 
            ? colorScheme.primary.withOpacity(0.08)
            : Colors.transparent,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w500 : null,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
