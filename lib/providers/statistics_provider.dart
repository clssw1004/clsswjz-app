import 'package:flutter/material.dart';
import '../data/data_source.dart';
import '../models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TimeRange { week, month, year, custom }

class StatisticsProvider extends ChangeNotifier {
  final DataSource _dataSource;
  TimeRange _timeRange = TimeRange.month;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _loading = false;
  AccountItemResponse? _data;
  String? _error;

  StatisticsProvider(this._dataSource) {
    // 初始化为本月数据
    _initMonthRange();
    loadData();
  }

  TimeRange get timeRange => _timeRange;
  bool get loading => _loading;
  AccountItemResponse? get data => _data;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  String? get error => _error;

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
        // 本周第一天到最后一天
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
        // 自定义时间范围保持不变
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

    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final currentBookId = prefs.getString('currentBookId');

      if (currentBookId == null) {
        throw Exception('请先选择账本');
      }

      _data = await _dataSource.getAccountItems(
        currentBookId,
        startDate: _startDate,
        endDate: _endDate,
      );
    } catch (e) {
      _error = e.toString();
      print('加载统计数据失败: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // 获取分类统计数据
  Map<String, double> getCategoryStatistics(String type) {
    if (_data == null || _data!.items.isEmpty) return {};

    final map = <String, double>{};
    for (final item in _data!.items) {
      if (item.type == type) {
        map[item.category] = (map[item.category] ?? 0) + item.amount;
      }
    }
    return map;
  }

  // 获取每日统计数据
  List<DailyStatistics> getDailyStatistics() {
    if (_data == null || _data!.items.isEmpty) return [];

    final map = <String, DailyStatistics>{};

    for (final item in _data!.items) {
      final dateStr = item.accountDate.toString().split(' ')[0];
      final daily = map[dateStr] ??
          DailyStatistics(
            date: item.accountDate,
            income: 0,
            expense: 0,
          );

      if (item.type == 'INCOME') {
        daily.income += item.amount;
      } else {
        daily.expense += item.amount;
      }

      map[dateStr] = daily;
    }

    return map.values.toList()..sort((a, b) => a.date.compareTo(b.date));
  }
}

class DailyStatistics {
  final DateTime date;
  double income;
  double expense;

  DailyStatistics({
    required this.date,
    required this.income,
    required this.expense,
  });
}
