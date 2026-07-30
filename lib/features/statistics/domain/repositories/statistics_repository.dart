import 'package:kakeibo/features/statistics/domain/entities/monthly_stats.dart';
import 'package:kakeibo/features/statistics/domain/entities/yearly_stats.dart';

abstract class StatisticsRepository {
  Future<MonthlyStats> getMonthlyStats(int year, int month);
  Future<YearlyStats> getYearlyStats(int year);
}
