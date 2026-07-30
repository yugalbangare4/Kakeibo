import 'package:flutter/material.dart';
import '../../domain/entities/day_summary.dart';
import 'package:kakeibo/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo/features/categories/presentation/providers/category_provider.dart';

class DayCell extends ConsumerWidget {
  final DateTime day;
  final DaySummary? summary;
  final bool isSelected;
  final bool isToday;

  const DayCell({
    Key? key,
    required this.day,
    this.summary,
    this.isSelected = false,
    this.isToday = false,
  }) : super(key: key);

  Color _getHeatmapColor(BuildContext context, WidgetRef ref) {
    if (summary == null || summary!.totalSpent == 0) return Colors.transparent;
    
    final maxCategoryId = summary!.topCategoryIds.first;
    final categoriesAsync = ref.read(allCategoriesProvider);
    
    Color baseColor = AppColors.categoryColors[0];
    categoriesAsync.whenData((cats) {
      final cat = cats.firstWhere((c) => c.id == maxCategoryId, orElse: () => cats.first);
      baseColor = AppColors.categoryColors[cat.colorIndex % AppColors.categoryColors.length];
    });
    
    // Scale opacity based on arbitrary thresholds for visual variance
    double opacity = 0.15;
    if (summary!.totalSpent > 3000) {
      opacity = 0.4;
    } else if (summary!.totalSpent > 1000) {
      opacity = 0.25;
    }
    
    // If in dark mode, we might want slightly different opacity to be visible but not overwhelming
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      opacity = opacity * 1.5; 
      if (opacity > 0.6) opacity = 0.6;
    }

    return baseColor.withOpacity(opacity);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected 
            ? Theme.of(context).colorScheme.primary 
            : _getHeatmapColor(context, ref),
        shape: BoxShape.circle,
        border: isToday && !isSelected
            ? Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5), width: 2)
            : null,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: isSelected ? FontWeight.w700 : (summary != null && summary!.totalSpent > 0 ? FontWeight.w600 : FontWeight.w400),
            color: isSelected 
                ? Theme.of(context).colorScheme.onPrimary 
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
