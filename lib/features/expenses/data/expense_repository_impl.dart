import 'package:kakeibo/database/app_database.dart';
import '../domain/entities/expense.dart';
import '../domain/repositories/expense_repository.dart';
import 'models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  @override
  Future<List<Expense>> getExpensesForDate(DateTime date) async {
    final db = await AppDatabase.database;
    final start = DateTime(date.year, date.month, date.day);
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    final results = await db.query(
      'expenses',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC',
    );

    return results.map((m) => Expense.fromModel(ExpenseModel.fromMap(m))).toList();
  }

  @override
  Future<List<Expense>> getExpensesForMonth(int year, int month) async {
    final db = await AppDatabase.database;
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0, 23, 59, 59, 999);

    final results = await db.query(
      'expenses',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC',
    );

    return results.map((m) => Expense.fromModel(ExpenseModel.fromMap(m))).toList();
  }

  @override
  Future<List<Expense>> getExpensesForYear(int year) async {
    final db = await AppDatabase.database;
    final start = DateTime(year, 1, 1);
    final end = DateTime(year, 12, 31, 23, 59, 59, 999);

    final results = await db.query(
      'expenses',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC',
    );

    return results.map((m) => Expense.fromModel(ExpenseModel.fromMap(m))).toList();
  }

  @override
  Future<Expense> addExpense(Expense expense) async {
    final db = await AppDatabase.database;
    final model = expense.toModel();
    final id = await db.insert('expenses', model.toMap());
    return Expense.fromModel(ExpenseModel(
      id: id,
      amount: model.amount,
      note: model.note,
      categoryId: model.categoryId,
      date: model.date,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    ));
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    final db = await AppDatabase.database;
    final model = expense.toModel();
    await db.update(
      'expenses',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  @override
  Future<void> deleteExpense(int id) async {
    final db = await AppDatabase.database;
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<double> getTotalForDate(DateTime date) async {
    final expenses = await getExpensesForDate(date);
    return expenses.fold<double>(0.0, (double sum, item) => sum + item.amount);
  }

  @override
  Future<double> getTotalForMonth(int year, int month) async {
    final expenses = await getExpensesForMonth(year, month);
    return expenses.fold<double>(0.0, (double sum, item) => sum + item.amount);
  }
}
