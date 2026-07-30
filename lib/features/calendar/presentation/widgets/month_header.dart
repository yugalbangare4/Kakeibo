import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthHeader extends StatelessWidget {
  final DateTime focusedMonth;
  final ValueChanged<DateTime> onMonthChanged;

  const MonthHeader({
    Key? key,
    required this.focusedMonth,
    required this.onMonthChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final monthYearStr = DateFormat('MMMM yyyy').format(focusedMonth);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.chevron_left, color: Theme.of(context).colorScheme.onSurface),
              onPressed: () {
                onMonthChanged(DateTime(focusedMonth.year, focusedMonth.month - 1, 1));
              },
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Text(
              monthYearStr,
              key: ValueKey<String>(monthYearStr),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                fontFamily: 'Inter',
                letterSpacing: -0.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurface),
              onPressed: () {
                onMonthChanged(DateTime(focusedMonth.year, focusedMonth.month + 1, 1));
              },
            ),
          ),
        ],
      ),
    );
  }
}
