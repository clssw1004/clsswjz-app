import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../models/models.dart';
import '../../../providers/statistics_provider.dart';
import '../../../l10n/l10n.dart';

class CategoryPieChart extends StatelessWidget {
  final String type;

  const CategoryPieChart({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<StatisticsProvider>(
      builder: (context, provider, child) {
        final data = provider.data!;
        final categories = type == 'EXPENSE'
            ? data.expenseByCategory
            : data.incomeByCategory;

        if (categories.isEmpty) {
          return _buildEmptyState(context);
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: colorScheme.outlineVariant.withOpacity(0.5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type == 'EXPENSE'
                      ? l10n.statisticsExpenseByCategory
                      : l10n.statisticsIncomeByCategory,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 240,
                  child: SfCircularChart(
                    legend: Legend(
                      isVisible: true,
                      position: LegendPosition.right,
                      overflowMode: LegendItemOverflowMode.wrap,
                      textStyle: theme.textTheme.bodySmall,
                    ),
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      color: colorScheme.surfaceContainerHighest,
                      textStyle: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    series: <CircularSeries>[
                      DoughnutSeries<CategoryData, String>(
                        dataSource: categories,
                        xValueMapper: (CategoryData data, _) => data.name,
                        yValueMapper: (CategoryData data, _) => data.amount,
                        pointColorMapper: (CategoryData data, _) => 
                            Color(data.color),
                        dataLabelMapper: (CategoryData data, _) => 
                            '${data.name}\n${NumberFormat.compact().format(data.amount)}',
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.outside,
                          textStyle: theme.textTheme.bodySmall,
                        ),
                        enableTooltip: true,
                        radius: '80%',
                        innerRadius: '60%',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Container(
        height: 240,
        alignment: Alignment.center,
        child: Text(
          l10n.statisticsNoData,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
