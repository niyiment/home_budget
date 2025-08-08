import 'dart:convert';

import '../../domain/entities/budget.dart';

class BudgetModel extends Budget {
  
  const BudgetModel({
    super.id,
    required super.category,
    required super.amount,
    super.isHoliday = false
  });

  factory BudgetModel.fromEntity(Budget budget) {
    return BudgetModel(
      id: budget.id,
      category: budget.category,
      amount: budget.amount,
      isHoliday: budget.isHoliday,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'isHoliday': isHoliday ? 1 : 0
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    final map = toMap();
    map.remove('id');
    return map;
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] as int?,
      category: map['category'] as String,
      amount: map['amount'] as double,
      isHoliday: map['isHoliday'] == 1,
    );
  }

  factory BudgetModel.fromJson(String source) {
    final map = json.decode(source) as Map<String, dynamic>;
    return BudgetModel.fromMap(map);
  }

  @override
  BudgetModel copyWith({
    int? id,
    String? category,
    double? amount,
    bool? isHoliday,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      isHoliday: isHoliday ?? this.isHoliday,
    );
  }

}