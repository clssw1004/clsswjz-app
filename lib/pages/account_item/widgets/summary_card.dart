import 'package:flutter/material.dart';
import '../../../l10n/l10n.dart';
import '../../../utils/amount_formatter.dart';
import '../../../theme/app_theme.dart';

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
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.padding,
        vertical: AppDimens.paddingSmall,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.cardRadius),
        side: BorderSide(
          color:
              colorScheme.outlineVariant.withOpacity(AppDimens.opacityOverlay),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildSummaryItem(
                      context,
                      label: l10n.summaryIncome,
                      amount: allIn,
                      color: colorScheme.primary,
                    ),
                  ),
                  Container(
                    height: 32,
                    width: 1,
                    color: colorScheme.outlineVariant,
                  ),
                  Expanded(
                    child: _buildSummaryItem(
                      context,
                      label: l10n.summaryExpense,
                      amount: allOut,
                      color: colorScheme.error,
                    ),
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
    final locale = Localizations.localeOf(context).toString();

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
        FittedBox(
          child: Text(
            AmountFormatter.formatFullWithSymbol(
                amount, l10n.currencySymbol, locale),
            style: theme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
