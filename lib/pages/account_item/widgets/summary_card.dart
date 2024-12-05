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
    final l10n = L10n.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          if (allIn == 0 && allOut == 0)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  l10n.noTransactions,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(
                    context,
                    label: l10n.summaryIncome,
                    amount: allIn,
                    color: Color(0xFF43A047), // Material Green 600
                  ),
                  Container(
                    height: 32,
                    width: 1,
                    color: colorScheme.outlineVariant,
                  ),
                  _buildSummaryItem(
                    context,
                    label: l10n.summaryExpense,
                    amount: allOut,
                    color: Color(0xFFE53935), // Material Red 600
                  ),
                  Container(
                    height: 32,
                    width: 1,
                    color: colorScheme.outlineVariant,
                  ),
                  _buildSummaryItem(
                    context,
                    label: l10n.summaryBalance,
                    amount: allBalance,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),
        ],
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
    final l10n = L10n.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              l10n.currencySymbol,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 2),
            Text(
              amount.toStringAsFixed(2),
              style: theme.textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
