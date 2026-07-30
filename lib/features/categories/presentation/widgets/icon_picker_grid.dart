import 'package:flutter/material.dart';
import 'package:kakeibo/core/utils/category_utils.dart';
class IconPickerGrid extends StatelessWidget {
  final String? selectedIconName;
  final Function(String) onSelected;

  const IconPickerGrid({
    super.key,
    required this.selectedIconName,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: CategoryUtils.iconMap.length,
        itemBuilder: (context, index) {
          final entry = CategoryUtils.iconMap.entries.elementAt(index);
          final isSelected = entry.key == selectedIconName;

          return GestureDetector(
            onTap: () => onSelected(entry.key),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Icon(
                entry.value,
                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade600,
              ),
            ),
          );
        },
      ),
    );
  }
}
