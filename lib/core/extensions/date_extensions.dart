import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  DateTime toDateOnly() {
    return DateTime(year, month, day);
  }

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  String toFormattedString() {
    return DateFormat('EEE, MMM d').format(this);
  }

  String toMonthYear() {
    return DateFormat('MMMM yyyy').format(this);
  }

  String toShortDate() {
    return DateFormat('d MMM').format(this);
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  DateTime get startOfMonth {
    return DateTime(year, month, 1);
  }

  DateTime get endOfMonth {
    return DateTime(year, month + 1, 0, 23, 59, 59, 999);
  }

  int get daysInMonth {
    return DateTime(year, month + 1, 0).day;
  }
}
