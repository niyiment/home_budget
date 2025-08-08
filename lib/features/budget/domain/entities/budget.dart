
class Budget {
  final int? id;
  final String category;
  final double amount;
  final bool isHoliday;

  Budget({
    this.id,
    required this.category,
    required this.amount,
    required this.isHoliday,
  });
}
