import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../l10n/l10n.dart';

class SummaryCard extends StatelessWidget {
  final double allIn;
  final double allOut;
  final double allBalance;

  const SummaryCard({
    Key? key,
    required this.allIn,
    required this.allOut,
    required this.allBalance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _buildSummaryItem(
                context,
                label: '收入',
                amount: allIn,
                color: AppColors.income,
              ),
            ),
            Container(
              width: 1,
              height: 24,
              color: colorScheme.outlineVariant.withOpacity(0.5),
            ),
            Expanded(
              child: _buildSummaryItem(
                context,
                label: '支出',
                amount: allOut,
                color: AppColors.expense,
              ),
            ),
            Container(
              width: 1,
              height: 24,
              color: colorScheme.outlineVariant.withOpacity(0.5),
            ),
            Expanded(
              child: _buildSummaryItem(
                context,
                label: '结余',
                amount: allBalance,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context, {
    required String label,
    required double amount,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Column(
      children: [
        Text(
          label == '收入'
              ? l10n.totalIncome
              : label == '支出'
                  ? l10n.totalExpense
                  : l10n.balance,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '¥${amount.toStringAsFixed(2)}',
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
