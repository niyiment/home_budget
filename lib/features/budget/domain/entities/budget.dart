// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  final int? id;
  final String category;
  final double amount;
  final bool isHoliday;

  const Budget({
    this.id,
    required this.category,
    required this.amount,
    required this.isHoliday,
  });
  
  @override
  List<Object?> get props => [
    id,
    category,
    amount,
    isHoliday
  ];

  

  Budget copyWith({
    int? id,
    String? category,
    double? amount,
    bool? isHoliday,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      isHoliday: isHoliday ?? this.isHoliday,
    );
  }
}
