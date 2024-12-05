import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/statistics_provider.dart';
import '../../../l10n/l10n.dart';

class TimeRangeSelector extends StatelessWidget {
  const TimeRangeSelector({super.key});

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
              l10n.statisticsTimeRange,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Consumer<StatisticsProvider>(
              builder: (context, provider, _) {
                return SegmentedButton<TimeRange>(
                  segments: [
                    ButtonSegment<TimeRange>(
                      value: TimeRange.week,
                      label: Text(l10n.statisticsWeek),
                    ),
                    ButtonSegment<TimeRange>(
                      value: TimeRange.month,
                      label: Text(l10n.statisticsMonth),
                    ),
                    ButtonSegment<TimeRange>(
                      value: TimeRange.year,
                      label: Text(l10n.statisticsYear),
                    ),
                    ButtonSegment<TimeRange>(
                      value: TimeRange.custom,
                      label: Text(l10n.statisticsCustom),
                    ),
                  ],
                  selected: {provider.timeRange},
                  onSelectionChanged: (Set<TimeRange> selected) {
                    if (selected.isEmpty) return;
                    final range = selected.first;
                    if (range == TimeRange.custom) {
                      _showDateRangePicker(context, provider);
                    } else {
                      provider.setTimeRange(range);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDateRangePicker(
    BuildContext context,
    StatisticsProvider provider,
  ) async {
    final initialDateRange = DateTimeRange(
      start: provider.startDate ?? DateTime.now(),
      end: provider.endDate ?? DateTime.now(),
    );

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: initialDateRange,
    );

    if (picked != null) {
      provider.setCustomRange(picked.start, picked.end);
    }
  }
}
