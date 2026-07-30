import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo/features/calendar/domain/entities/day_summary.dart';
import 'package:kakeibo/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:kakeibo/features/calendar/data/calendar_repository_impl.dart';

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  return CalendarRepositoryImpl();
});

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final focusedMonthProvider = StateProvider<DateTime>((ref) => DateTime.now());

final monthlySummaryProvider = FutureProvider.family<Map<DateTime, DaySummary>, DateTime>((ref, date) async {
  final repository = ref.read(calendarRepositoryProvider);
  return repository.getMonthlySummary(date.year, date.month);
});

final selectedDaySummaryProvider = FutureProvider<DaySummary?>((ref) async {
  final selectedDate = ref.watch(selectedDateProvider);
  final repository = ref.read(calendarRepositoryProvider);
  return repository.getDaySummary(selectedDate);
});
