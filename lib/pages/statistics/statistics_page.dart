import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/data_source.dart';
import '../../providers/statistics_provider.dart';
import '../../l10n/l10n.dart';
import '../../widgets/app_bar_factory.dart';
import './widgets/time_range_selector.dart';
import './widgets/overview_card.dart';
import './widgets/trend_chart.dart';
import './widgets/category_pie_chart.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late final StatisticsProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = StatisticsProvider(
      Provider.of<DataSource>(context, listen: false),
    );
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = L10n.of(context);

    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        extendBodyBehindAppBar: true,
        appBar: AppBarFactory.buildAppBar(
          context: context,
          title: AppBarFactory.buildTitle(context, l10n.statistics),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: Consumer<StatisticsProvider>(
            builder: (context, provider, child) {
              if (provider.loading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: colorScheme.primary,
                  ),
                );
              }

              if (provider.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        provider.error!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (provider.data == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noAvailableBooks,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => provider.loadData(),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const TimeRangeSelector(),
                    const SizedBox(height: 16),
                    const OverviewCard(),
                    const SizedBox(height: 16),
                    TrendChart(chartType: provider.chartType),
                    const SizedBox(height: 16),
                    const CategoryPieChart(type: 'EXPENSE'),
                    const SizedBox(height: 16),
                    const CategoryPieChart(type: 'INCOME'),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
