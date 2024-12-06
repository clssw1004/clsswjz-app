import 'package:flutter/material.dart';
import '../../../l10n/l10n.dart';
import '../../../providers/statistics_provider.dart';

class ChartTypeSelector extends StatelessWidget {
  final ChartType selectedType;
  final ValueChanged<ChartType> onTypeChanged;

  const ChartTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(
            context,
            ChartType.line,
            Icons.show_chart,
            l10n.chartTypeLine,
          ),
          const SizedBox(width: 8),
          _buildChip(
            context,
            ChartType.bar,
            Icons.bar_chart,
            l10n.chartTypeBar,
          ),
          const SizedBox(width: 8),
          _buildChip(
            context,
            ChartType.area,
            Icons.area_chart,
            l10n.chartTypeArea,
          ),
          const SizedBox(width: 8),
          _buildChip(
            context,
            ChartType.stacked,
            Icons.stacked_bar_chart,
            l10n.chartTypeStacked,
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    ChartType type,
    IconData icon,
    String label,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = selectedType == type;

    return FilterChip(
      selected: isSelected,
      showCheckmark: false,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      labelPadding: EdgeInsets.zero,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              fontSize: 12,
            ),
          ),
        ],
      ),
      onSelected: (selected) {
        if (selected) {
          onTypeChanged(type);
        }
      },
    );
  }
} 