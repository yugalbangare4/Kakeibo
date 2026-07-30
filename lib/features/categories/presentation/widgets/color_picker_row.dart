import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kakeibo/core/theme/app_colors.dart';
class ColorPickerRow extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelected;

  const ColorPickerRow({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: AppColors.categoryColors.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final color = AppColors.categoryColors[index % AppColors.categoryColors.length];
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(
                  color: isSelected ? Theme.of(context).colorScheme.onSurface : Colors.transparent,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            )
            .animate(target: isSelected ? 1 : 0)
            .scale(begin: const Offset(1, 1), end: const Offset(1.15, 1.15), duration: 200.ms, curve: Curves.bounceOut),
          );
        },
      ),
    );
  }
}
