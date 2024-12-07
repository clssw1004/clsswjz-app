import 'package:flutter/material.dart';
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
      itemBuilder: (context) => metrics.map((metric) {
        return PopupMenuItem<StatisticsMetric>(
          value: metric,
          child: Text(
            metric.label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        );
      }).toList(),
      onSelected: onMetricChanged,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedMetric.label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down_rounded,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
} 