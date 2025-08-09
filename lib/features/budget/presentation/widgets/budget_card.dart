
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/index.dart';
import '../../../expense/presentation/providers/expense_provider.dart';
import '../../domain/entities/budget.dart';

class BudgetCard extends ConsumerWidget {
  final Budget budget;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const BudgetCard({
    super.key,
    required this.budget,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalExpensesAsync = ref.watch(
      totalExpensesForBudgetProvider(budget.id!),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: budget.isHoliday
              ? Colors.orange
              : Theme.of(context).primaryColor,
          child: Icon(
            budget.isHoliday ? Icons.celebration : Icons.account_balance_wallet,
            color: Colors.white,
          ),
        ),
        title: Text(
          budget.category,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(NumberFormat.currency(symbol: '\$').format(budget.amount)),
            totalExpensesAsync.when(
              data: (totalExpenses) {
                final percentage = budget.amount > 0
                    ? (totalExpenses / budget.amount)
                    : 0;
                    
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spent: ${NumberFormat.currency(symbol: '\$').format(totalExpenses)}',
                      style: TextStyle(
                        color: percentage > 0.8 ? Colors.red : Colors.green,
                        fontSize: 12,
                      ),
                    ),
                    LinearProgressIndicator(
                      value: percentage.clamp(0.0, 1.0).toDouble(),
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        percentage > 1.0
                            ? Colors.red
                            : percentage > 0.8
                            ? Colors.orange
                            : Colors.green,
                      ),
                    ),
                  ],
                );
              },
              loading: () =>
                  const SizedBox(height: 4, child: LinearProgressIndicator()),
              error: (_, __) => const Text('Error loading expenses'),
            ),
          ],
        ),
        trailing: onDelete != null
            ? PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: const Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text(AppString.edit),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: const Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          AppString.delete,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit' && onTap != null) {
                    onTap!();
                  } else if (value == 'delete' && onDelete != null) {
                    onDelete!();
                  }
                },
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
