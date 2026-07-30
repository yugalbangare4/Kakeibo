import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kakeibo/features/categories/domain/entities/category.dart';

class CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> appColors = [
      const Color(0xFFC75B39), // Primary
      const Color(0xFF2D3A6E), // Secondary
      const Color(0xFF7B9E6B), // Accent
      const Color(0xFFD4A96A), // Surface
      const Color(0xFF4A90E2),
      const Color(0xFFE24A75),
      const Color(0xFF9B59B6),
      const Color(0xFFF39C12),
      const Color(0xFF16A085),
      const Color(0xFF27AE60),
      const Color(0xFF2980B9),
      const Color(0xFF8E44AD),
    ];
    final categoryColor = appColors[category.colorIndex % appColors.length];

    IconData getIcon(String name) {
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

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? categoryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: categoryColor,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              getIcon(category.iconName),
              size: 18,
              color: isSelected ? Colors.white : categoryColor,
            ),
            const SizedBox(width: 8),
            Text(
              category.name,
              style: TextStyle(
                color: isSelected ? Colors.white : categoryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      )
      .animate(target: isSelected ? 1 : 0)
      .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 200.ms, curve: Curves.bounceOut),
    );
  }
}
