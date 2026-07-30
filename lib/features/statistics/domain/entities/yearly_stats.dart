class YearlyStats {
  final int year;
  final double totalSpent;
  final double monthlyAverage;
  final int totalTransactions;
  final Map<int, double> monthlyTotals;
  final Map<int, double> categoryTotals;
  final int? topCategoryId;
  final int? highestMonth;
  final int? lowestMonth;

  YearlyStats({
    required this.year,
    required this.totalSpent,
    required this.monthlyAverage,
    required this.totalTransactions,
    required this.monthlyTotals,
    required this.categoryTotals,
    this.topCategoryId,
    this.highestMonth,
    this.lowestMonth,
  });
}
