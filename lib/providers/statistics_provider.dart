import 'package:flutter/material.dart';
import '../data/data_source.dart';
import '../models/models.dart';
import 'dart:math' as math;
import '../models/statistics_metric.dart';
import '../services/storage_service.dart';
import '../constants/storage_keys.dart';

enum TimeRange { week, month, year, custom }
enum ChartType {
  line,    // 折线图
  bar,     // 柱状图
  area,    // 面积图
  stacked, // 堆叠图
}

class StatisticsProvider extends ChangeNotifier {
  final DataSource _dataSource;
  TimeRange _timeRange = TimeRange.month;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _loading = false;
  String? _error;
  StatisticsData? _data;
  ChartType _chartType = ChartType.area;
  StatisticsMetric _xMetric = StatisticsProvider.metrics[0];
  StatisticsMetric _yMetric = StatisticsProvider.metrics[0];

  static final List<StatisticsMetric> metrics = [
    const StatisticsMetric(
      id: 'amount',
      type: MetricType.amount,
      label: '金额',
      unit: '¥',
    ),
    const StatisticsMetric(
      id: 'count',
      type: MetricType.count,
      label: '笔数',
      unit: '笔',
    ),
    const StatisticsMetric(
      type: MetricType.average,
      id: 'average',
      label: '平均值',
      unit: '¥',
    ),
  ];

  // 预定义的颜色列表
  static const List<int> _categoryColors = [
    0xFF4CAF50, // 绿色
    0xFFF44336, // 红色
    0xFF2196F3, // 蓝色
    0xFFFF9800, // 橙色
    0xFF9C27B0, // 紫色
    0xFF795548, // 棕色
    0xFF607D8B, // 蓝灰色
    0xFFE91E63, // 粉红色
    0xFF673AB7, // 深紫色
    0xFF009688, // 青色
    0xFFFFEB3B, // 黄色
    0xFF3F51B5, // 靛蓝色
  ];

  StatisticsProvider(this._dataSource) {
    _initMonthRange();
    loadData();
  }

  TimeRange get timeRange => _timeRange;
  bool get loading => _loading;
  String? get error => _error;
  StatisticsData? get data => _data;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  ChartType get chartType => _chartType;
  StatisticsMetric get xMetric => _xMetric;
  StatisticsMetric get yMetric => _yMetric;

  void _initMonthRange() {
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month + 1, 0);
  }

  Future<void> setTimeRange(TimeRange range) async {
    _timeRange = range;
    final now = DateTime.now();

    switch (range) {
      case TimeRange.week:
        _startDate = now.subtract(Duration(days: now.weekday - 1));
        _endDate = _startDate!.add(const Duration(days: 6));
        break;
      case TimeRange.month:
        _initMonthRange();
        break;
      case TimeRange.year:
        _startDate = DateTime(now.year, 1, 1);
        _endDate = DateTime(now.year, 12, 31);
        break;
      case TimeRange.custom:
        return;
    }

    notifyListeners();
    await loadData();
  }

  Future<void> setCustomRange(DateTime start, DateTime end) async {
    _timeRange = TimeRange.custom;
    _startDate = start;
    _endDate = end;
    notifyListeners();
    await loadData();
  }

  Future<void> loadData() async {
    if (_startDate == null || _endDate == null) return;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final currentBookId = StorageService.getString(StorageKeys.currentBookId);

      if (currentBookId.isEmpty) {
        throw Exception('请先选择账本');
      }

      final response = await _dataSource.getAccountItems(
        currentBookId,
        startDate: _startDate,
        endDate: _endDate,
      );

      _data = _processData(response);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _data = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  StatisticsData _processData(AccountItemResponse response) {
    // 处理趋势数据
    final dailyStats = <String, TrendData>{};
    for (final item in response.items) {
      final dateStr = item.accountDate.toString().split(' ')[0];
      final data = dailyStats[dateStr] ?? TrendData(date: dateStr);

      if (item.type == 'INCOME') {
        data.income += item.amount;
      } else {
        data.expense += item.amount;
      }
      dailyStats[dateStr] = data;
    }

    // 据选定的指标处理数据
    final trends = dailyStats.values.map((data) {
      final incomeItems = response.items.where((item) => 
        item.type == 'INCOME' && 
        item.accountDate.toString().split(' ')[0] == data.date
      ).toList();

      final expenseItems = response.items.where((item) => 
        item.type == 'EXPENSE' && 
        item.accountDate.toString().split(' ')[0] == data.date
      ).toList();

      return TrendData(
        date: data.date,
        income: calculateMetricValue(incomeItems, _yMetric),
        expense: calculateMetricValue(expenseItems, _yMetric),
      );
    }).toList()..sort((a, b) => a.date.compareTo(b.date));

    // 处理分类数据
    final expenseMap = <String, double>{};
    final incomeMap = <String, double>{};
    final categoryColors = <String, int>{};
    final random = math.Random(0); // 使用固定种子以保持颜色一致

    // 为每个分类分配颜色
    void assignColor(String category) {
      if (!categoryColors.containsKey(category)) {
        // 如果分类数量超过预定义颜色，则随机生成颜色
        if (categoryColors.length < _categoryColors.length) {
          categoryColors[category] = _categoryColors[categoryColors.length];
        } else {
          // 生成随机颜色，但保持较高的饱度和亮度
          final hue = random.nextDouble() * 360;
          final saturation = 0.7 + random.nextDouble() * 0.3; // 70-100% 饱和度
          final lightness = 0.4 + random.nextDouble() * 0.2;  // 40-60% 亮度
          
          final hslColor = HSLColor.fromAHSL(1.0, hue, saturation, lightness);
          final color = hslColor.toColor();
          categoryColors[category] = color.value;
        }
      }
    }

    // 处理收支数据并分配颜色
    for (final item in response.items) {
      if (item.type == 'EXPENSE') {
        expenseMap[item.category] = (expenseMap[item.category] ?? 0) + item.amount;
        assignColor(item.category);
      } else {
        incomeMap[item.category] = (incomeMap[item.category] ?? 0) + item.amount;
        assignColor(item.category);
      }
    }

    // 按金额排序并创建分类数据
    final expenseByCategory = expenseMap.entries
        .map((e) => CategoryData(
              name: e.key,
              amount: e.value,
              color: categoryColors[e.key]!,
            ))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    final incomeByCategory = incomeMap.entries
        .map((e) => CategoryData(
              name: e.key,
              amount: e.value,
              color: categoryColors[e.key]!,
            ))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    // 计算总收支
    double totalIncome = 0;
    double totalExpense = 0;
    for (final item in response.items) {
      if (item.type == 'INCOME') {
        totalIncome += item.amount;
      } else {
        totalExpense += item.amount;
      }
    }

    return StatisticsData(
      trends: trends,
      expenseByCategory: expenseByCategory,
      incomeByCategory: incomeByCategory,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
    );
  }

  void setChartType(ChartType type) {
    _chartType = type;
    notifyListeners();
  }

  void setXMetric(StatisticsMetric metric) {
    _xMetric = metric;
    notifyListeners();
  }

  void setYMetric(StatisticsMetric metric) {
    if (_yMetric != metric) {
      _yMetric = metric;
      loadData();
    }
  }

  // 根据指标计算值
  double calculateMetricValue(List<AccountItem> items, StatisticsMetric metric) {
    switch (metric.type) {
      case MetricType.amount:
        return items.fold(0.0, (sum, item) => sum + item.amount);
      case MetricType.count:
        return items.length.toDouble();
      case MetricType.average:
        if (items.isEmpty) return 0;
        final total = items.fold(0.0, (sum, item) => sum + item.amount);
        return total / items.length;
    }
  }
}
