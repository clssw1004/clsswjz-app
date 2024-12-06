import 'package:flutter/material.dart';
import '../../../l10n/l10n.dart';
import '../../../models/statistics_metric.dart';

class MetricSelector extends StatelessWidget {
  final StatisticsMetric selectedMetric;
  final List<StatisticsMetric> metrics;
  final ValueChanged<StatisticsMetric> onMetricChanged;

  const MetricSelector({
    super.key,
    required this.selectedMetric,
    required this.metrics,
    required this.onMetricChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopupMenuButton<StatisticsMetric>(
      initialValue: selectedMetric,
      tooltip: '',
      position: PopupMenuPosition.under,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedMetric.label,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.arrow_drop_down,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => metrics.map((metric) {
        return PopupMenuItem<StatisticsMetric>(
          value: metric,
          child: Text(metric.label),
        );
      }).toList(),
      onSelected: onMetricChanged,
    );
  }
} 