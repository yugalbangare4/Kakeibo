class ExpenseModel {
  final int? id;
  final double amount;
  final String? note;
  final int categoryId;
  final DateTime date;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ExpenseModel({
    this.id,
    required this.amount,
    this.note,
    required this.categoryId,
    required this.date,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'amount': amount,
      'note': note,
      'category_id': categoryId,
      'date': date.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': (updatedAt ?? DateTime.now()).toIso8601String(),
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] as int?,
      amount: map['amount'] as double,
      note: map['note'] as String?,
      categoryId: map['category_id'] as int,
      date: DateTime.parse(map['date'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at'] as String) : null,
    );
  }
}
