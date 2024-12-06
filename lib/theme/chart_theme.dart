import 'package:flutter/material.dart';

class ChartTheme {
  static ChartStyle fromTheme(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return ChartStyle(
      backgroundColor: theme.cardTheme.color ?? colorScheme.surface,
      gridLineColor: colorScheme.outline.withOpacity(0.2),
      labelStyle: theme.textTheme.bodySmall!,
      tooltipStyle: TooltipStyle(
        backgroundColor: colorScheme.surfaceContainerHighest,
        textColor: colorScheme.onSurface,
      ),
      incomeColor: colorScheme.primary,
      expenseColor: colorScheme.error,
      tertiaryColor: colorScheme.tertiary,
      surfaceColor: colorScheme.surface,
    );
  }
}

class ChartStyle {
  final Color backgroundColor;
  final Color gridLineColor;
  final TextStyle labelStyle;
  final TooltipStyle tooltipStyle;
  final Color incomeColor;
  final Color expenseColor;
  final Color tertiaryColor;
  final Color surfaceColor;

  const ChartStyle({
    required this.backgroundColor,
    required this.gridLineColor,
    required this.labelStyle,
    required this.tooltipStyle,
    required this.incomeColor,
    required this.expenseColor,
    required this.tertiaryColor,
    required this.surfaceColor,
  });
}

class TooltipStyle {
  final Color backgroundColor;
  final Color textColor;

  const TooltipStyle({
    required this.backgroundColor,
    required this.textColor,
  });
} 