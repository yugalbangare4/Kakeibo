import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../data/expense_repository_impl.dart';
import 'package:kakeibo/features/calendar/presentation/providers/calendar_provider.dart';
import 'package:kakeibo/features/statistics/presentation/providers/statistics_provider.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepositoryImpl();
});

final dailyExpensesProvider = FutureProvider.family<List<Expense>, DateTime>((ref, date) async {
  final repo = ref.watch(expenseRepositoryProvider);
  return repo.getExpensesForDate(date);
});

class ExpenseNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  ExpenseNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> addExpense(Expense expense) async {
    state = const AsyncValue.loading();
    try {
      final repo = _ref.read(expenseRepositoryProvider);
      await repo.addExpense(expense);
      _invalidateProviders();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateExpense(Expense expense) async {
    state = const AsyncValue.loading();
    try {
      final repo = _ref.read(expenseRepositoryProvider);
      await repo.updateExpense(expense);
      _invalidateProviders();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteExpense(int id) async {
    state = const AsyncValue.loading();
    try {
      final repo = _ref.read(expenseRepositoryProvider);
      await repo.deleteExpense(id);
      _invalidateProviders();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _invalidateProviders() {
    _ref.invalidate(dailyExpensesProvider);
    _ref.invalidate(monthlySummaryProvider);
    _ref.invalidate(selectedDaySummaryProvider);
    _ref.invalidate(monthlyStatsProvider);
    _ref.invalidate(yearlyStatsProvider);
  }
}

final expenseNotifierProvider = StateNotifierProvider<ExpenseNotifier, AsyncValue<void>>((ref) {
  return ExpenseNotifier(ref);
});
