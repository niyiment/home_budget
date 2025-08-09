import 'package:flutter/material.dart';
import 'package:home_budget/core/constants/index.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/expense.dart';


class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ExpenseCard({
    super.key,
    required this.expense,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.receipt, color: Colors.white),
        ),
        title: Text(
          expense.description,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(DateFormat('MMM dd, yyyy').format(expense.date)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              NumberFormat.currency(symbol: '\$').format(expense.amount),
              style: const TextStyle(fontSize: 14),
            ),
            if (onDelete != null)
              PopupMenuButton(
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
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
