import 'package:sqflite/sqflite.dart';
import 'package:kakeibo/database/app_database.dart';
import 'package:kakeibo/features/statistics/domain/entities/monthly_stats.dart';
import 'package:kakeibo/features/statistics/domain/entities/yearly_stats.dart';
import 'package:kakeibo/features/statistics/domain/repositories/statistics_repository.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  Future<Database> get _db => AppDatabase.database;

  @override
  Future<MonthlyStats> getMonthlyStats(int year, int month) async {
    final db = await _db;
    final startDate = DateTime(year, month, 1).toIso8601String();
    final endDate = DateTime(year, month + 1, 1).toIso8601String();

    final results = await db.rawQuery('''
      SELECT date, category_id as categoryId, amount
      FROM expenses
      WHERE date >= ? AND date < ?
    ''', [startDate, endDate]);

    double totalSpent = 0;
    int totalTransactions = results.length;
    Map<int, double> categoryTotals = {};
    Map<int, double> dailyTotals = {};
    Set<int> daysWithSpendingSet = {};

    for (var row in results) {
      final dateStr = row['date'] as String;
      final dt = DateTime.parse(dateStr);
      final day = dt.day;
      
      final categoryId = row['categoryId'] as int;
      // SQLite might return int or double for numeric columns depending on value
      final amount = (row['amount'] as num).toDouble();

      totalSpent += amount;

      categoryTotals[categoryId] = (categoryTotals[categoryId] ?? 0) + amount;
      dailyTotals[day] = (dailyTotals[day] ?? 0) + amount;
      daysWithSpendingSet.add(day);
    }

    final daysInMonth = DateTime(year, month + 1, 0).day;
    final daysWithSpending = daysWithSpendingSet.length;
    final noSpendDays = daysInMonth - daysWithSpending;
    final dailyAverage = daysInMonth > 0 ? totalSpent / daysInMonth : 0.0;

    int? topCategoryId;
    double topCategoryAmount = 0;
    categoryTotals.forEach((catId, amt) {
      if (amt > topCategoryAmount) {
        topCategoryAmount = amt;
        topCategoryId = catId;
      }
    });

    return MonthlyStats(
      year: year,
      month: month,
      totalSpent: totalSpent,
      dailyAverage: dailyAverage,
      totalTransactions: totalTransactions,
      daysWithSpending: daysWithSpending,
      noSpendDays: noSpendDays,
      categoryTotals: categoryTotals,
      dailyTotals: dailyTotals,
      topCategoryId: topCategoryId,
      topCategoryAmount: topCategoryAmount > 0 ? topCategoryAmount : null,
    );
  }

  @override
  Future<YearlyStats> getYearlyStats(int year) async {
    final db = await _db;
    final startDate = DateTime(year, 1, 1).toIso8601String();
    final endDate = DateTime(year + 1, 1, 1).toIso8601String();

    final results = await db.rawQuery('''
      SELECT date, category_id as categoryId, amount
      FROM expenses
      WHERE date >= ? AND date < ?
    ''', [startDate, endDate]);

    double totalSpent = 0;
    int totalTransactions = results.length;
    Map<int, double> monthlyTotals = {};
    Map<int, double> categoryTotals = {};

    for (var row in results) {
      final dateStr = row['date'] as String;
      final dt = DateTime.parse(dateStr);
      final month = dt.month;
      
      final categoryId = row['categoryId'] as int;
      final amount = (row['amount'] as num).toDouble();

      totalSpent += amount;

      monthlyTotals[month] = (monthlyTotals[month] ?? 0) + amount;
      categoryTotals[categoryId] = (categoryTotals[categoryId] ?? 0) + amount;
    }

    final monthlyAverage = totalSpent / 12;

    int? topCategoryId;
    double maxCatAmt = 0;
    categoryTotals.forEach((catId, amt) {
      if (amt > maxCatAmt) {
        maxCatAmt = amt;
        topCategoryId = catId;
      }
    });

    int? highestMonth;
    int? lowestMonth;
    double maxMonthAmt = -1;
    double minMonthAmt = double.infinity;

    for (int m = 1; m <= 12; m++) {
      final amt = monthlyTotals[m] ?? 0;
      if (amt > maxMonthAmt) {
        maxMonthAmt = amt;
        highestMonth = m;
      }
      if (amt < minMonthAmt) {
        minMonthAmt = amt;
        lowestMonth = m;
      }
    }

    return YearlyStats(
      year: year,
      totalSpent: totalSpent,
      monthlyAverage: monthlyAverage,
      totalTransactions: totalTransactions,
      monthlyTotals: monthlyTotals,
      categoryTotals: categoryTotals,
      topCategoryId: topCategoryId,
      highestMonth: highestMonth,
      lowestMonth: lowestMonth,
    );
  }
}
