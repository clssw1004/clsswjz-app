import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/statistics_provider.dart';
import '../../../l10n/l10n.dart';
import '../../../constants/app_colors.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

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
            Consumer<StatisticsProvider>(
              builder: (context, provider, _) {
                final data = provider.data;
                if (data == null) return const SizedBox();

                return Column(
                  children: [
                    _buildOverviewItem(
                      context,
                      label: l10n.income,
                      amount: data.summary.allIn,
                      color: AppColors.income,
                    ),
                    const Divider(height: 24),
                    _buildOverviewItem(
                      context,
                      label: l10n.expense,
                      amount: data.summary.allOut,
                      color: AppColors.expense,
                    ),
                    const Divider(height: 24),
                    _buildOverviewItem(
                      context,
                      label: l10n.balance,
                      amount: data.summary.allBalance,
                      color: colorScheme.primary,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewItem(
    BuildContext context, {
    required String label,
    required double amount,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          amount.toStringAsFixed(2),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
