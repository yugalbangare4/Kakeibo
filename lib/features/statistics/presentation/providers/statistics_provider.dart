import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo/features/statistics/data/statistics_repository_impl.dart';
import 'package:kakeibo/features/statistics/domain/entities/monthly_stats.dart';
import 'package:kakeibo/features/statistics/domain/entities/yearly_stats.dart';

final statisticsRepositoryProvider = Provider<StatisticsRepositoryImpl>((ref) {
  return StatisticsRepositoryImpl();
});

final selectedStatsMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

final selectedStatsYearProvider = StateProvider<int>((ref) {
  return DateTime.now().year;
});

final monthlyStatsProvider = FutureProvider<MonthlyStats>((ref) async {
  final repository = ref.watch(statisticsRepositoryProvider);
  final selectedMonth = ref.watch(selectedStatsMonthProvider);
  return await repository.getMonthlyStats(selectedMonth.year, selectedMonth.month);
});

final yearlyStatsProvider = FutureProvider<YearlyStats>((ref) async {
  final repository = ref.watch(statisticsRepositoryProvider);
  final selectedYear = ref.watch(selectedStatsYearProvider);
  return await repository.getYearlyStats(selectedYear);
});
