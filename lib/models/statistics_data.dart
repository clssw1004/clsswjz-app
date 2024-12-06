class StatisticsData {
  final List<TrendData> trends;
  final List<CategoryData> expenseByCategory;
  final List<CategoryData> incomeByCategory;
  final double totalIncome;
  final double totalExpense;

  StatisticsData({
    required this.trends,
    required this.expenseByCategory,
    required this.incomeByCategory,
    required this.totalIncome,
    required this.totalExpense,
  });

  double get balance => totalIncome - totalExpense;
}

class TrendData {
  final String date;
  double income;
  double expense;

  TrendData({
    required this.date,
    this.income = 0,
    this.expense = 0,
  });
}

class CategoryData {
  final String name;
  final double amount;
  final int color;

  CategoryData({
    required this.name,
    required this.amount,
    required this.color,
  });
} 