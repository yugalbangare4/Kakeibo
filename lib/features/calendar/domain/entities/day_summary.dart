class DaySummary {
  final DateTime date;
  final double totalSpent;
  final int transactionCount;
  final Map<int, double> categoryBreakdown;
  final List<int> topCategoryIds;

  DaySummary({
    required this.date,
    required this.totalSpent,
    required this.transactionCount,
    required this.categoryBreakdown,
    required this.topCategoryIds,
  });
}
