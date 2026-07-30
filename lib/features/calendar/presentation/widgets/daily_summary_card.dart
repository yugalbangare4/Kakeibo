import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/calendar_provider.dart';
import 'package:kakeibo/features/calendar/domain/entities/day_summary.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kakeibo/core/theme/app_colors.dart';
import 'package:kakeibo/features/categories/presentation/providers/category_provider.dart';
import 'package:kakeibo/core/utils/category_utils.dart';

class DailySummaryCard extends ConsumerWidget {
  const DailySummaryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final summaryAsync = ref.watch(selectedDaySummaryProvider);
    final categoriesAsync = ref.watch(allCategoriesProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEEE, MMM d').format(selectedDate),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to DayExpensesScreen
                  context.push('/day/${selectedDate.toIso8601String()}');
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          summaryAsync.when(
            data: (summary) {
              if (summary == null || summary.totalSpent == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: Text(
                      'No spending recorded',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                );
              }

              final formatCurrency = NumberFormat.simpleCurrency(name: 'INR');

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatCurrency.format(summary.totalSpent),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 24),
                  Column(
                    children: summary.topCategoryIds.take(3).map((id) {
                      final amount = summary.categoryBreakdown[id] ?? 0;
                      final percentage = summary.totalSpent > 0 ? (amount / summary.totalSpent) : 0.0;
                      String catName = 'Category';
                      IconData catIcon = Icons.circle_outlined;
                      Color color = AppColors.categoryColors[0];
                      
                      categoriesAsync.whenData((cats) {
                        final cat = cats.firstWhere((c) => c.id == id, orElse: () => cats.first);
                        catName = cat.name;
                        catIcon = CategoryUtils.getIcon(cat.iconName);
                        color = AppColors.categoryColors[cat.colorIndex % AppColors.categoryColors.length];
                      });

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(catIcon, size: 16, color: color),
                                    const SizedBox(width: 8),
                                    Text(
                                      catName,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  formatCurrency.format(amount),
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Stack(
                              children: [
                                Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: percentage,
                                  child: Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ).animate().scaleX(begin: 0, alignment: Alignment.centerLeft, duration: 600.ms, curve: Curves.easeOutQuart),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1);
                    }).toList(),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => const Text('Failed to load summary'),
          ),
        ],
      ),
    );
  }
}
