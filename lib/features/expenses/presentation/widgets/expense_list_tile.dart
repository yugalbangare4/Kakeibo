import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/expense.dart';
import 'package:kakeibo/core/theme/app_colors.dart';
import 'package:kakeibo/features/categories/presentation/providers/category_provider.dart';
import 'package:kakeibo/core/utils/category_utils.dart';

class ExpenseListTile extends ConsumerWidget {
  final Expense expense;
  final int index;
  final VoidCallback onTap;

  const ExpenseListTile({
    Key? key,
    required this.expense,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatCurrency = NumberFormat.simpleCurrency(name: 'INR');
    final timeFormat = DateFormat('jm');
    
    final categoriesAsync = ref.watch(allCategoriesProvider);
    
    String catName = 'Unknown';
    IconData catIcon = Icons.circle_outlined;
    Color catColor = AppColors.categoryColors[0];

    categoriesAsync.whenData((cats) {
      final cat = cats.firstWhere((c) => c.id == expense.categoryId, orElse: () => cats.first);
      catName = cat.name;
      catIcon = CategoryUtils.getIcon(cat.iconName);
      catColor = AppColors.categoryColors[cat.colorIndex % AppColors.categoryColors.length];
    });

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: catColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                catIcon,
                color: catColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    catName,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expense.note?.isNotEmpty == true
                        ? '${expense.note} • ${timeFormat.format(expense.createdAt)}'
                        : timeFormat.format(expense.createdAt),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              formatCurrency.format(expense.amount),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1);
  }
}
