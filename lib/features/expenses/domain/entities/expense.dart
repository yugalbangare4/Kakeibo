import '../../data/models/expense_model.dart';

class Expense {
  final int? id;
  final double amount;
  final String? note;
  final int categoryId;
  final DateTime date;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Expense({
    this.id,
    required this.amount,
    this.note,
    required this.categoryId,
    required this.date,
    required this.createdAt,
    this.updatedAt,
  });

  factory Expense.fromModel(ExpenseModel model) {
    return Expense(
      id: model.id,
      amount: model.amount,
      note: model.note,
      categoryId: model.categoryId,
      date: model.date,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  ExpenseModel toModel() {
    return ExpenseModel(
      id: id,
      amount: amount,
      note: note,
      categoryId: categoryId,
      date: date,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
