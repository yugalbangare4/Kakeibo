import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../providers/expense_provider.dart';
import 'package:kakeibo/features/expenses/presentation/widgets/expense_list_tile.dart';
import 'package:kakeibo/features/expenses/presentation/widgets/add_expense_sheet.dart';

class DayExpensesScreen extends ConsumerWidget {
  final DateTime date;

  const DayExpensesScreen({Key? key, required this.date}) : super(key: key);

  void _showAddExpenseSheet(BuildContext context, {dynamic expense}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddExpenseSheet(
        date: date,
        expenseToEdit: expense,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(dailyExpensesProvider(date));
    final formatCurrency = NumberFormat.simpleCurrency(name: 'INR');

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          DateFormat('MMM d, yyyy').format(date),
          style: TextStyle(
            fontFamily: 'Inter',
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: expensesAsync.when(
        data: (expenses) {
          final total = expenses.fold(0.0, (sum, item) => sum + item.amount);
          
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'Total Spent',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
                        fontSize: 16,
                      ),
                    ).animate().fadeIn().slideY(begin: -0.2),
                    const SizedBox(height: 8),
                    Text(
                      formatCurrency.format(total),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(delay: 100.ms).scale(),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: expenses.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.coffee_outlined,
                                color: Theme.of(context).colorScheme.secondary,
                              ).animate().scale(delay: 200.ms),
                              const SizedBox(height: 16),
                              const Text(
                                'No expenses today',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ).animate().fadeIn(delay: 300.ms),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 24, bottom: 100),
                          itemCount: expenses.length,
                          itemBuilder: (context, index) {
                            final expense = expenses[index];
                            return Dismissible(
                              key: ValueKey(expense.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 24),
                                color: Theme.of(context).colorScheme.error,
                                child: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.onError),
                              ),
                              onDismissed: (_) {
                                if (expense.id != null) {
                                  ref.read(expenseNotifierProvider.notifier).deleteExpense(expense.id!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Expense deleted')),
                                  );
                                }
                              },
                              child: ExpenseListTile(
                                expense: expense,
                                index: index,
                                onTap: () => _showAddExpenseSheet(context, expense: expense),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
        loading: () => Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpenseSheet(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ).animate().scale(delay: 300.ms),
    );
  }
}
