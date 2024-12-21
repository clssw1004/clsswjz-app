import 'package:flutter/material.dart';
import 'dialogs/type_selector_dialog.dart';
import 'dialogs/category_selector_dialog.dart';
import 'dialogs/amount_range_dialog.dart';
import 'dialogs/date_range_dialog.dart';
import 'dialogs/shop_selector_dialog.dart';
import '../../../l10n/l10n.dart';
import '../../../models/shop.dart';
import '../../../models/filter_state.dart';

class FilterSection extends StatelessWidget {
  final bool isExpanded;
  final FilterState filterState;
  final List<String> categories;
  final List<ShopOption> shops;
  final Function(FilterState) onFilterChanged;

  const FilterSection({
    Key? key,
    required this.isExpanded,
    required this.filterState,
    required this.categories,
    required this.shops,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: isExpanded ? null : 0,
      child: Container(
        margin: EdgeInsets.only(
          left: isSmallScreen ? 16 : 24,
          right: isSmallScreen ? 16 : 24,
          top: 8,
          bottom: 4,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12 : 16,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              const SizedBox(height: 12),
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
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: filterState.hasFilter ? () => onFilterChanged(FilterState()) : null,
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: const Size(0, 28),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text(
            l10n.clearFilter,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 12,
              color: filterState.hasFilter ? colorScheme.primary : colorScheme.outline,
              fontWeight: filterState.hasFilter ? FontWeight.w500 : null,
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
        ? (screenWidth - 80) / 3
        : (screenWidth - 120) / 5;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.start,
      children: [
        SizedBox(
          width: buttonWidth,
          child: _buildTypeButton(context),
        ),
        SizedBox(
          width: buttonWidth,
          child: _buildCategoryButton(context),
        ),
        SizedBox(
          width: buttonWidth,
          child: _buildShopButton(context),
        ),
        SizedBox(
          width: buttonWidth,
          child: _buildAmountButton(context),
        ),
        SizedBox(
          width: buttonWidth,
          child: _buildDateButton(context),
        ),
      ],
    );
  }

  Widget _buildTypeButton(BuildContext context) {
    final l10n = L10n.of(context);
    return _FilterButton(
      label: filterState.selectedType == null
          ? l10n.type
          : filterState.selectedType == 'EXPENSE'
              ? l10n.expense
              : l10n.income,
      isSelected: filterState.selectedType != null,
      onPressed: () => _showTypeSelector(context),
    );
  }

  Widget _buildCategoryButton(BuildContext context) {
    final l10n = L10n.of(context);
    return _FilterButton(
      label: filterState.selectedCategories.isEmpty
          ? l10n.category
          : l10n.selectedCount(filterState.selectedCategories.length),
      isSelected: filterState.selectedCategories.isNotEmpty,
      onPressed: () => _showCategorySelector(context),
    );
  }

  Widget _buildAmountButton(BuildContext context) {
    final l10n = L10n.of(context);
    final hasAmountFilter = filterState.minAmount != null || filterState.maxAmount != null;
    return _FilterButton(
      label: hasAmountFilter ? l10n.filtered : l10n.amount,
      isSelected: hasAmountFilter,
      onPressed: () => _showAmountRangeDialog(context),
    );
  }

  Widget _buildDateButton(BuildContext context) {
    final l10n = L10n.of(context);
    final hasDateFilter = filterState.startDate != null || filterState.endDate != null;
    return _FilterButton(
      label: hasDateFilter ? l10n.filtered : l10n.date,
      isSelected: hasDateFilter,
      onPressed: () => _showDateRangeDialog(context),
    );
  }

  Widget _buildShopButton(BuildContext context) {
    final l10n = L10n.of(context);
    return _FilterButton(
      label: filterState.selectedShopCodes.isEmpty
          ? l10n.shop
          : l10n.selectedCount(filterState.selectedShopCodes.length),
      isSelected: filterState.selectedShopCodes.isNotEmpty,
      onPressed: () => _showShopSelector(context),
    );
  }

  void _showTypeSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TypeSelectorDialog(
        selectedType: filterState.selectedType,
        onTypeSelected: (type) {
          onFilterChanged(filterState.copyWith(
            selectedType: () => type,
          ));
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
        selectedCategories: filterState.selectedCategories,
        onCategoriesChanged: (categories) {
          onFilterChanged(filterState.copyWith(
            selectedCategories: categories,
          ));
        },
      ),
    );
  }

  void _showAmountRangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AmountRangeDialog(
        minAmount: filterState.minAmount,
        maxAmount: filterState.maxAmount,
        onConfirm: (min, max) {
          onFilterChanged(filterState.copyWith(
            minAmount: () => min,
            maxAmount: () => max,
          ));
        },
      ),
    );
  }

  void _showDateRangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DateRangeDialog(
        startDate: filterState.startDate,
        endDate: filterState.endDate,
        onConfirm: (start, end) {
          onFilterChanged(filterState.copyWith(
            startDate: () => start,
            endDate: () => end,
          ));
        },
      ),
    );
  }

  void _showShopSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ShopSelectorDialog(
        shops: shops,
        selectedShopCodes: filterState.selectedShopCodes,
        onShopCodesChanged: (codes) {
          onFilterChanged(filterState.copyWith(
            selectedShopCodes: codes,
          ));
        },
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outline.withOpacity(0.5),
          width: isSelected ? 1.5 : 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: isSelected 
            ? colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w500 : null,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}
