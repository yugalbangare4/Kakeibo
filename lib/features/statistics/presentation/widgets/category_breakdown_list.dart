import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kakeibo/features/categories/domain/entities/category.dart';
import 'package:kakeibo/core/theme/app_colors.dart';

class CategoryBreakdownList extends StatelessWidget {
  final Map<int, double> categoryTotals;
  final List<Category> categories;
  final double total;

  const CategoryBreakdownList({
    super.key,
    required this.categoryTotals,
    required this.categories,
    required this.total,
  });



  IconData _getIcon(String name) {
    switch (name) {
      case 'shoppingBag': return Icons.shopping_bag_outlined;
      case 'coffee': return Icons.coffee_outlined;
      case 'car': return Icons.directions_car_outlined;
      case 'home': return Icons.home_outlined;
      case 'heart': return Icons.favorite_outline;
      case 'smartphone': return Icons.smartphone_outlined;
      case 'film': return Icons.movie_outlined;
      case 'book': return Icons.menu_book_outlined;
      case 'briefcase': return Icons.work_outline;
      case 'gift': return Icons.card_giftcard_outlined;
      case 'activity': return Icons.show_chart;
      case 'plane': return Icons.flight_outlined;
      case 'utensils': return Icons.restaurant_outlined;
      default: return Icons.circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (categoryTotals.isEmpty || total == 0) return const SizedBox.shrink();

    final sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: List.generate(sortedEntries.length, (index) {
        final entry = sortedEntries[index];
        final category = categories.firstWhere(
          (c) => c.id == entry.key,
          orElse: () => Category(name: 'Unknown', iconName: 'circle', colorIndex: 0, sortOrder: 0, createdAt: DateTime.now()),
        );
        
        final color = AppColors.categoryColors[category.colorIndex % AppColors.categoryColors.length];
        final percentage = entry.value / total;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                radius: 20,
                child: Icon(_getIcon(category.iconName), color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(category.name, style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
                        Text('₹${entry.value.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Stack(
                      children: [
                        Container(
                          height: 6,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
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
                          ),
                        ).animate().scaleX(begin: 0, end: 1, duration: 600.ms, curve: Curves.easeOutQuart, alignment: Alignment.centerLeft),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fade(delay: (100 * index).ms).slideX(begin: 0.1),
        );
      }),
    );
  }
}
