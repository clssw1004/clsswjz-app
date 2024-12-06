enum MetricType {
  amount,    // 金额
  count,     // 笔数
  average,   // 平均值
}

class StatisticsMetric {
  final String id;
  final MetricType type;
  final String label;
  final String? unit;

  const StatisticsMetric({
    required this.id,
    required this.type,
    required this.label,
    this.unit,
  });
} 