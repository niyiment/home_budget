import '../../domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    super.id,
    super.budgetId,
    required super.amount,
    required super.description,
    required super.date,
  });

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'],
      budgetId: map['budgetId'],
      amount: map['amount'].toDouble(),
      description: map['description'],
      date: DateTime.parse(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'budgetId': budgetId,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    final map = toMap();
    map.remove('id');
    return map;
  }

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      budgetId: expense.budgetId,
      amount: expense.amount,
      description: expense.description,
      date: expense.date,
    );
  }
}


