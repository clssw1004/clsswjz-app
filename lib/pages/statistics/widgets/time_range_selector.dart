import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/statistics_provider.dart';
import '../../../l10n/l10n.dart';

class TimeRangeSelector extends StatelessWidget {
  const TimeRangeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                      icon: const SizedBox.shrink(),
                    ),
                    ButtonSegment<TimeRange>(
                      value: TimeRange.month,
                      label: Text(l10n.statisticsMonth),
                      icon: const SizedBox.shrink(),
                    ),
                    ButtonSegment<TimeRange>(
                      value: TimeRange.year,
                      label: Text(l10n.statisticsYear),
                      icon: const SizedBox.shrink(),
                    ),
                    ButtonSegment<TimeRange>(
                      value: TimeRange.custom,
                      label: Text(l10n.statisticsCustom),
                      icon: const SizedBox.shrink(),
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
                  style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  showSelectedIcon: false,
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
    final now = DateTime.now();
    final lastDate = DateTime(now.year, now.month, now.day); // 设置为今天的开始时间

    // 确保初始日期范围不超过今天
    final initialStart = provider.startDate ?? now;
    final initialEnd = provider.endDate ?? now;

    final initialDateRange = DateTimeRange(
      start: initialStart.isAfter(lastDate) ? lastDate : initialStart,
      end: initialEnd.isAfter(lastDate) ? lastDate : initialEnd,
    );

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: lastDate, // 使用今天作为最后日期
      initialDateRange: initialDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // 设置时间为当天的开始和结束
      final start = DateTime(
        picked.start.year,
        picked.start.month,
        picked.start.day,
      );
      final end = DateTime(
        picked.end.year,
        picked.end.month,
        picked.end.day,
        23, 59, 59, // 设置为当天的最后一秒
      );

      provider.setCustomRange(start, end);
    }
  }
}
