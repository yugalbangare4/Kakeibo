class MonthlyStats {
  final int year;
  final int month;
  final double totalSpent;
  final double dailyAverage;
  final int totalTransactions;
  final int daysWithSpending;
  final int noSpendDays;
  final Map<int, double> categoryTotals;
  final Map<int, double> dailyTotals;
  final int? topCategoryId;
  final double? topCategoryAmount;

  MonthlyStats({
    required this.year,
    required this.month,
    required this.totalSpent,
    required this.dailyAverage,
    required this.totalTransactions,
    required this.daysWithSpending,
    required this.noSpendDays,
    required this.categoryTotals,
    required this.dailyTotals,
    this.topCategoryId,
    this.topCategoryAmount,
  });
}
