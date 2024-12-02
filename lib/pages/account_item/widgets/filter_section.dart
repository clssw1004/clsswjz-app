import 'package:flutter/material.dart';
import 'dialogs/type_selector_dialog.dart';
import 'dialogs/category_selector_dialog.dart';
import 'dialogs/amount_range_dialog.dart';
import 'dialogs/date_range_dialog.dart';

class FilterSection extends StatelessWidget {
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

  bool get _hasAnyFilter =>
      selectedType != null ||
      selectedCategories.isNotEmpty ||
      minAmount != null ||
      maxAmount != null ||
      startDate != null ||
      endDate != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isExpanded ? 220 : 0,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                SizedBox(height: 8),
                _buildFilterButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '筛选条件',
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: _hasAnyFilter ? onClearFilter : null,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size(0, 28),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            '清空筛选',
            style: theme.textTheme.labelSmall?.copyWith(
              color: _hasAnyFilter ? colorScheme.primary : colorScheme.outline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildTypeButton(context)),
        SizedBox(width: 6),
        Expanded(child: _buildCategoryButton(context)),
        SizedBox(width: 6),
        Expanded(child: _buildAmountButton(context)),
        SizedBox(width: 6),
        Expanded(child: _buildDateButton(context)),
      ],
    );
  }

  Widget _buildTypeButton(BuildContext context) {
    return _FilterButton(
      label: selectedType == null
          ? '类型'
          : selectedType == 'EXPENSE'
              ? '支出'
              : '收入',
      isSelected: selectedType != null,
      onPressed: () => _showTypeSelector(context),
    );
  }

  Widget _buildCategoryButton(BuildContext context) {
    return _FilterButton(
      label:
          selectedCategories.isEmpty ? '分类' : '已选${selectedCategories.length}',
      isSelected: selectedCategories.isNotEmpty,
      onPressed: () => _showCategorySelector(context),
    );
  }

  Widget _buildAmountButton(BuildContext context) {
    final hasAmountFilter = minAmount != null || maxAmount != null;
    return _FilterButton(
      label: hasAmountFilter ? '已筛选' : '金额',
      isSelected: hasAmountFilter,
      onPressed: () => _showAmountRangeDialog(context),
    );
  }

  Widget _buildDateButton(BuildContext context) {
    final hasDateFilter = startDate != null || endDate != null;
    return _FilterButton(
      label: hasDateFilter ? '已筛选' : '日期',
      isSelected: hasDateFilter,
      onPressed: () => _showDateRangeDialog(context),
    );
  }

  void _showTypeSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TypeSelectorDialog(
        selectedType: selectedType,
        onTypeSelected: (type) {
          onTypeChanged(type);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showCategorySelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CategorySelectorDialog(
        categories: categories,
        selectedCategories: selectedCategories,
        onCategoriesChanged: onCategoriesChanged,
      ),
    );
  }

  void _showAmountRangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AmountRangeDialog(
        minAmount: minAmount,
        maxAmount: maxAmount,
        onMinAmountChanged: onMinAmountChanged,
        onMaxAmountChanged: onMaxAmountChanged,
      ),
    );
  }

  void _showDateRangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DateRangeDialog(
        startDate: startDate,
        endDate: endDate,
        onStartDateChanged: onStartDateChanged,
        onEndDateChanged: onEndDateChanged,
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _FilterButton({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        minimumSize: Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outline,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color:
              isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
