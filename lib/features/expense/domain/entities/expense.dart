import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final int? id;
  final int? budgetId;
  final double amount;
  final String description;
  final DateTime date;

  const Expense({
    this.id,
    this.budgetId,
    required this.amount,
    required this.description,
    required this.date,
  });

  Expense copyWith({
    int? id,
    int? budgetId,
    double? amount,
    String? description,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [id, budgetId, amount, description, date];
}


