import 'package:flutter/material.dart';
import 'dialogs/type_selector_dialog.dart';
import 'dialogs/category_selector_dialog.dart';
import 'dialogs/amount_range_dialog.dart';
import 'dialogs/date_range_dialog.dart';
import 'dialogs/shop_selector_dialog.dart';
import '../../../l10n/l10n.dart';
import '../../../models/shop.dart';

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
  final List<String> selectedShopCodes;
  final List<ShopOption> shops;
  final Function(List<String>) onShopCodesChanged;

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
    required this.selectedShopCodes,
    required this.shops,
    required this.onShopCodesChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: isExpanded ? null : 0,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth > 600 ? 32 : 12,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outlineVariant.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.03),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              const SizedBox(height: 6),
              _buildFilterGrid(context),
            ],
          ),
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
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: _hasAnyFilter ? onClearFilter : null,
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            minimumSize: const Size(0, 24),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            l10n.clearFilter,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 11,
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
        ? (screenWidth - 52) / 3
        : 100.0;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      alignment: WrapAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isSmallScreen ? buttonWidth : 100,
          ),
          child: _buildTypeButton(context),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isSmallScreen ? buttonWidth : 120,
          ),
          child: _buildCategoryButton(context),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isSmallScreen ? buttonWidth : 120,
          ),
          child: _buildShopButton(context),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isSmallScreen ? buttonWidth : 100,
          ),
          child: _buildAmountButton(context),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isSmallScreen ? buttonWidth : 100,
          ),
          child: _buildDateButton(context),
        ),
      ],
    );
  }

  Widget _buildTypeButton(BuildContext context) {
    final l10n = L10n.of(context);
    return _FilterButton(
      label: selectedType == null
          ? l10n.type
          : selectedType == 'EXPENSE'
              ? l10n.expense
              : l10n.income,
      isSelected: selectedType != null,
      onPressed: () => _showTypeSelector(context),
    );
  }

  Widget _buildCategoryButton(BuildContext context) {
    final l10n = L10n.of(context);
    return _FilterButton(
      label: selectedCategories.isEmpty
          ? l10n.category
          : l10n.selectedCount(selectedCategories.length),
      isSelected: selectedCategories.isNotEmpty,
      onPressed: () => _showCategorySelector(context),
    );
  }

  Widget _buildAmountButton(BuildContext context) {
    final l10n = L10n.of(context);
    final hasAmountFilter = minAmount != null || maxAmount != null;
    return _FilterButton(
      label: hasAmountFilter ? l10n.filtered : l10n.amount,
      isSelected: hasAmountFilter,
      onPressed: () => _showAmountRangeDialog(context),
    );
  }

  Widget _buildDateButton(BuildContext context) {
    final l10n = L10n.of(context);
    final hasDateFilter = startDate != null || endDate != null;
    return _FilterButton(
      label: hasDateFilter ? l10n.filtered : l10n.date,
      isSelected: hasDateFilter,
      onPressed: () => _showDateRangeDialog(context),
    );
  }

  Widget _buildShopButton(BuildContext context) {
    final l10n = L10n.of(context);
    return _FilterButton(
      label: selectedShopCodes.isEmpty
          ? l10n.shop
          : l10n.selectedCount(selectedShopCodes.length),
      isSelected: selectedShopCodes.isNotEmpty,
      onPressed: () => _showShopSelector(context),
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

  void _showShopSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ShopSelectorDialog(
        shops: shops,
        selectedShopCodes: selectedShopCodes,
        onShopCodesChanged: onShopCodesChanged,
      ),
    );
  }

  bool get _hasAnyFilter =>
      selectedType != null ||
      selectedCategories.isNotEmpty ||
      minAmount != null ||
      maxAmount != null ||
      startDate != null ||
      endDate != null ||
      selectedShopCodes.isNotEmpty;
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
          fontSize: 12,
          color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w500 : null,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
