import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../providers/calendar_provider.dart';
import 'package:kakeibo/features/calendar/presentation/widgets/month_header.dart';
import 'package:kakeibo/features/calendar/presentation/widgets/day_cell.dart';
import 'package:kakeibo/features/calendar/presentation/widgets/daily_summary_card.dart';
import 'package:kakeibo/features/expenses/presentation/widgets/add_expense_sheet.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final focusedMonth = ref.watch(focusedMonthProvider);
    
    final monthlySummaryAsync = ref.watch(monthlySummaryProvider(focusedMonth));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: MonthHeader(
                  focusedMonth: focusedMonth,
                  onMonthChanged: (newMonth) {
                    ref.read(focusedMonthProvider.notifier).state = newMonth;
                  },
                ),
              ).animate().fadeIn().slideY(begin: -0.1),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: monthlySummaryAsync.when(
                    data: (summaryMap) {
                      return TableCalendar(
                        firstDay: DateTime(2000, 1, 1),
                        lastDay: DateTime(2100, 12, 31),
                        focusedDay: focusedMonth,
                        currentDay: DateTime.now(),
                        selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                        headerVisible: false,
                        calendarFormat: CalendarFormat.month,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        daysOfWeekHeight: 40,
                        onDaySelected: (selectedDay, focusedDay) {
                          ref.read(selectedDateProvider.notifier).state = selectedDay;
                          ref.read(focusedMonthProvider.notifier).state = focusedDay;
                        },
                        onPageChanged: (focusedDay) {
                          ref.read(focusedMonthProvider.notifier).state = focusedDay;
                        },
                        calendarBuilders: CalendarBuilders(
                          dowBuilder: (context, day) {
                            final text = DateFormat.E().format(day).substring(0, 3).toUpperCase();
                            return Center(
                              child: Text(
                                text,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            );
                          },
                          defaultBuilder: (context, day, focusedDay) => DayCell(
                            day: day,
                            summary: summaryMap[DateTime(day.year, day.month, day.day)],
                            isSelected: false,
                            isToday: false,
                          ),
                          selectedBuilder: (context, day, focusedDay) => DayCell(
                            day: day,
                            summary: summaryMap[DateTime(day.year, day.month, day.day)],
                            isSelected: true,
                            isToday: false,
                          ),
                          todayBuilder: (context, day, focusedDay) => DayCell(
                            day: day,
                            summary: summaryMap[DateTime(day.year, day.month, day.day)],
                            isSelected: isSameDay(selectedDate, day),
                            isToday: true,
                          ),
                          outsideBuilder: (context, day, focusedDay) => Opacity(
                            opacity: 0.3,
                            child: DayCell(
                              day: day,
                              summary: summaryMap[DateTime(day.year, day.month, day.day)],
                              isSelected: false,
                              isToday: false,
                            ),
                          ),
                        ),
                      );
                    },
                    loading: () => SizedBox(
                      height: 350,
                      child: Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)),
                    ),
                    error: (err, stack) => const SizedBox(
                      height: 350,
                      child: Center(child: Text('Error loading calendar data')),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 100.ms).scale(begin: const Offset(0.95, 0.95)),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const DailySummaryCard().animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => AddExpenseSheet(date: selectedDate),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ).animate().scale(delay: 300.ms),
    );
  }
}
