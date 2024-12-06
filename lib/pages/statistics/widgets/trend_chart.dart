import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';
import '../../../models/models.dart';
import '../../../providers/statistics_provider.dart';
import '../../../l10n/l10n.dart';
import 'chart_type_selector.dart';
import '../../../theme/chart_theme.dart';
import 'metric_selector.dart';

class TrendChart extends StatelessWidget {
  final ChartType chartType;

  const TrendChart({
    super.key,
    required this.chartType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final chartStyle = ChartTheme.fromTheme(theme);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        
        return Consumer<StatisticsProvider>(
          builder: (context, provider, child) {
            final data = provider.data!;
            if (data.trends.isEmpty) {
              return _buildEmptyState(context);
            }

            CartesianSeries<TrendData, String> _createSeries(
              String name,
              Color color,
              ChartValueMapper<TrendData, num> yValueMapper,
            ) {
              switch (chartType) {
                case ChartType.line:
                  return LineSeries<TrendData, String>(
                    name: name,
                    dataSource: data.trends,
                    xValueMapper: (TrendData data, _) => data.date,
                    yValueMapper: (TrendData data, _) => yValueMapper(data, 0),
                    color: color,
                    markerSettings: MarkerSettings(
                      isVisible: true,
                      color: color,
                      borderColor: chartStyle.surfaceColor,
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

            return Card(
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isSmallScreen) ...[
                      Text(
                        l10n.statisticsTrend,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            MetricSelector(
                              selectedMetric: provider.yMetric,
                              metrics: StatisticsProvider.metrics,
                              onMetricChanged: (metric) {
                                provider.setYMetric(metric);
                              },
                            ),
                            const SizedBox(width: 8),
                            ChartTypeSelector(
                              selectedType: chartType,
                              onTypeChanged: (type) {
                                context.read<StatisticsProvider>().setChartType(type);
                              },
                            ),
                          ],
                        ),
                      ),
                    ] else
                      Row(
                        children: [
                          Text(
                            l10n.statisticsTrend,
                            style: theme.textTheme.titleMedium,
                          ),
                          const Spacer(),
                          MetricSelector(
                            selectedMetric: provider.yMetric,
                            metrics: StatisticsProvider.metrics,
                            onMetricChanged: (metric) {
                              provider.setYMetric(metric);
                            },
                          ),
                          const SizedBox(width: 8),
                          ChartTypeSelector(
                            selectedType: chartType,
                            onTypeChanged: (type) {
                              context.read<StatisticsProvider>().setChartType(type);
                            },
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: isSmallScreen ? 200 : 240,
                      child: SfCartesianChart(
                        margin: const EdgeInsets.only(right: 16),
                        plotAreaBorderWidth: 0,
                        legend: Legend(
                          isVisible: true,
                          position: LegendPosition.top,
                          overflowMode: LegendItemOverflowMode.wrap,
                        ),
                        primaryXAxis: CategoryAxis(
                          majorGridLines: const MajorGridLines(width: 0),
                          labelStyle: chartStyle.labelStyle,
                          labelRotation: -45,
                        ),
                        primaryYAxis: NumericAxis(
                          majorGridLines: MajorGridLines(
                            width: 1,
                            color: chartStyle.gridLineColor,
                          ),
                          labelStyle: chartStyle.labelStyle,
                          numberFormat: NumberFormat.currency(
                            symbol: l10n.currencySymbol,
                            decimalDigits: 0,
                          ),
                        ),
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          color: chartStyle.tooltipStyle.backgroundColor,
                          textStyle: TextStyle(color: chartStyle.tooltipStyle.textColor),
                        ),
                        series: <CartesianSeries<TrendData, String>>[
                          _createSeries(
                            l10n.income,
                            chartStyle.incomeColor,
                            (TrendData data, _) => data.income,
                          ),
                          _createSeries(
                            l10n.expense,
                            chartStyle.expenseColor,
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
