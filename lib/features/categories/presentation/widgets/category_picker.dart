import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo/features/categories/presentation/providers/category_provider.dart';
import 'package:kakeibo/features/categories/presentation/widgets/category_chip.dart';

class CategoryPicker extends ConsumerWidget {
  final int? selectedCategoryId;
  final Function(int) onSelected;

  const CategoryPicker({
    super.key,
    required this.selectedCategoryId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoryNotifierProvider);

    return SizedBox(
      height: 48,
      child: categoriesState.when(
        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (err, stack) => const Text('Failed to load categories', style: TextStyle(color: Colors.red)),
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No categories available'));
          }

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = categories[index];
              return Center(
                child: CategoryChip(
                  category: category,
                  isSelected: selectedCategoryId == category.id,
                  onTap: () {
                    if (category.id != null) {
                      onSelected(category.id!);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
