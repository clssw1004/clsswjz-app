import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../providers/statistics_provider.dart';
import '../../../l10n/l10n.dart';
import '../../../constants/app_colors.dart';

class CategoryPieChart extends StatelessWidget {
  final String type;

  const CategoryPieChart({
    super.key,
    required this.type,
  });

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
              type == 'EXPENSE'
                  ? l10n.statisticsExpenseByCategory
                  : l10n.statisticsIncomeByCategory,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Consumer<StatisticsProvider>(
                builder: (context, provider, child) {
                  final data = provider.getCategoryStatistics(type);

                  if (data.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.statisticsNoData,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }

                  // 计算总额
                  final total = data.values.fold<double>(0, (a, b) => a + b);

                  // 生成扇形数据
                  final sections = data.entries.map((entry) {
                    final percent = entry.value / total;
                    return PieChartSectionData(
                      color: _getRandomColor(entry.key.hashCode),
                      value: entry.value,
                      title: '${(percent * 100).toStringAsFixed(1)}%',
                      radius: 80,
                      titleStyle: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.surface,
                      ),
                    );
                  }).toList();

                  return Row(
                    children: [
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            sections: sections,
                            centerSpaceRadius: 0,
                            sectionsSpace: 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 图例
                      SizedBox(
                        width: 100,
                        child: ListView(
                          children: data.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color:
                                          _getRandomColor(entry.key.hashCode),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      entry.key,
                                      style: theme.textTheme.bodySmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRandomColor(int seed) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[seed % colors.length];
  }
}
