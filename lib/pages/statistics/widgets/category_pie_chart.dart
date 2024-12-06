import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';
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

        final total = categories.fold<double>(
          0,
          (sum, item) => sum + item.amount,
        );

        return Card(
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
                const SizedBox(height: 24),
                SizedBox(
                  height: 240,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: SfCircularChart(
                          margin: EdgeInsets.zero,
                          series: <CircularSeries>[
                            DoughnutSeries<CategoryData, String>(
                              dataSource: categories,
                              xValueMapper: (CategoryData data, _) => data.name,
                              yValueMapper: (CategoryData data, _) => data.amount,
                              pointColorMapper: (CategoryData data, _) => 
                                  Color(data.color),
                              dataLabelMapper: (CategoryData data, _) {
                                final percent = data.amount / total * 100;
                                return percent >= 5 
                                    ? '${percent.toStringAsFixed(0)}%'
                                    : '';
                              },
                              dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.outside,
                                textStyle: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                                connectorLineSettings: const ConnectorLineSettings(
                                  type: ConnectorType.curve,
                                  length: '15%',
                                ),
                              ),
                              radius: '80%',
                              innerRadius: '60%',
                              explode: true,
                              explodeOffset: '5%',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              '${l10n.currencySymbol}${total.toStringAsFixed(2)}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: type == 'EXPENSE'
                                    ? colorScheme.error
                                    : colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  final category = categories[index];
                                  final percent = category.amount / total;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: Color(category.color),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            category.name,
                                            style: theme.textTheme.bodySmall,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${(percent * 100).toStringAsFixed(1)}%',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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
