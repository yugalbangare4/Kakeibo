import 'package:kakeibo/features/calendar/domain/entities/day_summary.dart';

abstract class CalendarRepository {
  Future<Map<DateTime, DaySummary>> getMonthlySummary(int year, int month);
  Future<DaySummary?> getDaySummary(DateTime date);
}
