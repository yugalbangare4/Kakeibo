import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getExpensesForDate(DateTime date);
  Future<List<Expense>> getExpensesForMonth(int year, int month);
  Future<List<Expense>> getExpensesForYear(int year);
  Future<Expense> addExpense(Expense expense);
  Future<void> updateExpense(Expense expense);
  Future<void> deleteExpense(int id);
  Future<double> getTotalForDate(DateTime date);
  Future<double> getTotalForMonth(int year, int month);
}
