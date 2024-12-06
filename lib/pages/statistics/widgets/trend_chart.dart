import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';
import '../../../models/models.dart';
import '../../../providers/statistics_provider.dart';
import '../../../l10n/l10n.dart';
import 'chart_type_selector.dart';

class TrendChart extends StatelessWidget {
  final ChartType chartType;

  const TrendChart({
    super.key,
    required this.chartType,
  });

  CartesianSeries<TrendData, String> _createSeries(
    BuildContext context,
    String name,
    Color color,
    ChartValueMapper<TrendData, num> yValueMapper,
  ) {
    final data = Provider.of<StatisticsProvider>(context, listen: false).data!;

    switch (chartType) {
      case ChartType.line:
        return LineSeries<TrendData, String>(
          name: name,
          dataSource: data.trends,
          xValueMapper: (TrendData data, _) => data.date,
          yValueMapper: yValueMapper,
          color: color,
          markerSettings: MarkerSettings(
            isVisible: true,
            color: color,
            borderWidth: 2,
          ),
        );
      case ChartType.bar:
        return ColumnSeries<TrendData, String>(
          name: name,
          dataSource: data.trends,
          xValueMapper: (TrendData data, _) => data.date,
          yValueMapper: yValueMapper,
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(4),
          spacing: 0.2,
        );
      case ChartType.area:
        return AreaSeries<TrendData, String>(
          name: name,
          dataSource: data.trends,
          xValueMapper: (TrendData data, _) => data.date,
          yValueMapper: yValueMapper,
          color: color.withOpacity(0.2),
          borderColor: color,
          borderWidth: 2,
        );
      case ChartType.stacked:
        return StackedAreaSeries<TrendData, String>(
          name: name,
          dataSource: data.trends,
          xValueMapper: (TrendData data, _) => data.date,
          yValueMapper: yValueMapper,
          color: color.withOpacity(0.6),
          borderColor: color,
          borderWidth: 1,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return Consumer<StatisticsProvider>(
      builder: (context, provider, child) {
        if (provider.data?.trends.isEmpty ?? true) {
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
                Row(
                  children: [
                    Text(
                      l10n.statisticsTrend,
                      style: theme.textTheme.titleMedium,
                    ),
                    const Spacer(),
                    ChartTypeSelector(
                      selectedType: chartType,
                      onTypeChanged: (type) {
                        context.read<StatisticsProvider>().setChartType(type);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 240,
                  child: SfCartesianChart(
                    margin: const EdgeInsets.only(right: 16),
                    plotAreaBorderWidth: 0,
                    legend: Legend(
                      isVisible: true,
                      position: LegendPosition.top,
                      overflowMode: LegendItemOverflowMode.wrap,
                      textStyle: theme.textTheme.bodySmall,
                    ),
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      labelStyle: theme.textTheme.bodySmall,
                      labelRotation: -45,
                      axisLine: AxisLine(
                        width: 1,
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                      majorGridLines: MajorGridLines(
                        width: 1,
                        color: colorScheme.outlineVariant.withOpacity(0.5),
                        dashArray: [4, 4],
                      ),
                      labelStyle: theme.textTheme.bodySmall,
                      axisLine: AxisLine(
                        width: 1,
                        color: colorScheme.outlineVariant,
                      ),
                      numberFormat: NumberFormat.compact(),
                    ),
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      color: colorScheme.surfaceContainerHighest,
                      textStyle: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    series: <CartesianSeries<TrendData, String>>[
                      _createSeries(
                        context,
                        l10n.income,
                        colorScheme.primary,
                        (TrendData data, _) => data.income,
                      ),
                      _createSeries(
                        context,
                        l10n.expense,
                        colorScheme.error,
                        (TrendData data, _) => data.expense,
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
