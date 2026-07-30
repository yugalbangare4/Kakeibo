import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/expense.dart';
import '../providers/expense_provider.dart';
import 'package:kakeibo/features/categories/presentation/providers/category_provider.dart';
import 'package:kakeibo/features/categories/presentation/widgets/category_chip.dart';
import 'amount_input.dart';
class AddExpenseSheet extends ConsumerStatefulWidget {
  final DateTime date;
  final Expense? expenseToEdit;

  const AddExpenseSheet({
    Key? key,
    required this.date,
    this.expenseToEdit,
  }) : super(key: key);

  @override
  ConsumerState<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends ConsumerState<AddExpenseSheet> {
  late double _amount;
  late int _selectedCategoryId;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _amount = widget.expenseToEdit?.amount ?? 0.0;
    _selectedCategoryId = widget.expenseToEdit?.categoryId ?? 0;
    _noteController = TextEditingController(text: widget.expenseToEdit?.note ?? '');
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _saveExpense() {
    if (_amount <= 0) return;

    final expense = Expense(
      id: widget.expenseToEdit?.id,
      amount: _amount,
      categoryId: _selectedCategoryId,
      note: _noteController.text.trim(),
      date: widget.date,
      createdAt: widget.expenseToEdit?.createdAt ?? DateTime.now(),
      updatedAt: widget.expenseToEdit != null ? DateTime.now() : null,
    );

    if (widget.expenseToEdit == null) {
      ref.read(expenseNotifierProvider.notifier).addExpense(expense);
    } else {
      ref.read(expenseNotifierProvider.notifier).updateExpense(expense);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(allCategoriesProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomSheetTheme.backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 32),
            AmountInput(
              amount: _amount,
              currencySymbol: '₹',
              onChanged: (val) => setState(() => _amount = val),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 48,
              child: categoriesAsync.when(
                data: (categories) {
                  if (categories.isEmpty) return const Center(child: Text('No categories available'));
                  
                  if (!categories.any((c) => c.id == _selectedCategoryId)) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _selectedCategoryId = categories.first.id ?? 0);
                    });
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (c, i) => const SizedBox(width: 12),
                    itemBuilder: (c, i) {
                      final cat = categories[i];
                      return CategoryChip(
                        category: cat,
                        isSelected: _selectedCategoryId == cat.id,
                        onTap: () {
                          setState(() => _selectedCategoryId = cat.id!);
                        },
                      );
                    },
                  );
                },
                loading: () => Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)),
                error: (e, st) => const Center(child: Text('Error loading categories')),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: 'Note (Optional)',
                  hintStyle: const TextStyle(fontFamily: 'Inter', color: Colors.grey),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  if (widget.expenseToEdit != null) ...[
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                      onPressed: () {
                        if (widget.expenseToEdit?.id != null) {
                          ref.read(expenseNotifierProvider.notifier).deleteExpense(widget.expenseToEdit!.id!);
                        }
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _amount > 0 ? _saveExpense : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        disabledBackgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        widget.expenseToEdit == null ? 'Save Expense' : 'Update Expense',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
