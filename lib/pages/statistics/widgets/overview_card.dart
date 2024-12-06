import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/statistics_provider.dart';
import '../../../l10n/l10n.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    return Consumer<StatisticsProvider>(
      builder: (context, provider, child) {
        final data = provider.data!;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.statisticsOverview,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                _buildSummaryItem(
                  context,
                  l10n.totalIncome,
                  data.totalIncome,
                  theme.colorScheme.primary,
                ),
                const SizedBox(height: 8),
                _buildSummaryItem(
                  context,
                  l10n.totalExpense,
                  data.totalExpense,
                  theme.colorScheme.error,
                ),
                const SizedBox(height: 8),
                _buildSummaryItem(
                  context,
                  l10n.balance,
                  data.balance,
                  theme.colorScheme.tertiary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    double amount,
    Color color,
  ) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyLarge),
        Text(
          '${l10n.currencySymbol}${amount.toStringAsFixed(2)}',
          style: theme.textTheme.titleMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}
