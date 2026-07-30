import 'package:kakeibo/database/app_database.dart';
import 'package:kakeibo/features/expenses/data/models/expense_model.dart';
import '../domain/entities/day_summary.dart';
import '../domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  @override
  Future<Map<DateTime, DaySummary>> getMonthlySummary(int year, int month) async {
    final db = await AppDatabase.database;
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59, 999);

    final results = await db.query(
      'expenses',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
    );

    final expenses = results.map((map) => ExpenseModel.fromMap(map)).toList();

    final map = <DateTime, List<ExpenseModel>>{};
    for (var e in expenses) {
      final d = DateTime(e.date.year, e.date.month, e.date.day);
      map.putIfAbsent(d, () => []).add(e);
    }

    final result = <DateTime, DaySummary>{};
    for (var entry in map.entries) {
      double total = 0;
      final breakdown = <int, double>{};
      for (var e in entry.value) {
        total += e.amount;
        breakdown[e.categoryId] = (breakdown[e.categoryId] ?? 0) + e.amount;
      }
      
      final sortedCats = breakdown.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final top = sortedCats.take(3).map((e) => e.key).toList();

      result[entry.key] = DaySummary(
        date: entry.key,
        totalSpent: total,
        transactionCount: entry.value.length,
        categoryBreakdown: breakdown,
        topCategoryIds: top,
      );
    }
    return result;
  }

  @override
  Future<DaySummary?> getDaySummary(DateTime date) async {
    final db = await AppDatabase.database;
    final start = DateTime(date.year, date.month, date.day);
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    final results = await db.query(
      'expenses',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );

    final expenses = results.map((map) => ExpenseModel.fromMap(map)).toList();

    if (expenses.isEmpty) return null;

    double total = 0;
    final breakdown = <int, double>{};
    for (var e in expenses) {
      total += e.amount;
      breakdown[e.categoryId] = (breakdown[e.categoryId] ?? 0) + e.amount;
    }
    
    final sortedCats = breakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = sortedCats.take(3).map((e) => e.key).toList();

    return DaySummary(
      date: start,
      totalSpent: total,
      transactionCount: expenses.length,
      categoryBreakdown: breakdown,
      topCategoryIds: top,
    );
  }
}
