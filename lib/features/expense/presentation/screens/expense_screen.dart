import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_budget/common/widgets/loading_indicator.dart';
import 'package:home_budget/features/expense/presentation/providers/expense_provider.dart';

import '../../../../core/constants/index.dart';
import '../../domain/entities/expense.dart';
import '../widgets/expense_card.dart';
import 'expense_form.dart';


class ExpenseScreen extends ConsumerWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseAsync = ref.watch(expensesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppString.expenseTitle),
        actions: [
          IconButton(
            onPressed: () => _showAddExpenseDialog(context, ref),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: expenseAsync.when(
        data: (expenses) {
          if (expenses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(AppString.noExpense),
                  Text(AppString.noBudgetSubtitle),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];

              return ExpenseCard(
                expense: expense,
                onTap: () => _showEditExpenseDialog(context, ref, expense),
                onDelete: () => _deleteExpense(context, ref, expense.id!),
              );
            },
          );
        },
        loading: () => const AppLoading(),
        error: (error, _) => Center(
          child: Column(
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16.h),
              Text(AppString.expenseErrorMessage),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => ExpenseFormScreen(
        onSave: (expense) {
          ref.read(expensesProvider.notifier).addExpense(expense);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showEditExpenseDialog(
    BuildContext context,
    WidgetRef ref,
    Expense expense,
  ) {
    showDialog(
      context: context,
      builder: (context) => ExpenseFormScreen(
        expense: expense,
        onSave: (updatedExpense) {
          ref.read(expensesProvider.notifier).updateExpense(updatedExpense);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _deleteExpense(BuildContext context, WidgetRef ref, int expenseId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppString.deleteBudget),
        content: const Text(AppString.deleteExpenseMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppString.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(expensesProvider.notifier).deleteExpense(expenseId);
              Navigator.of(context).pop();
            },
            child: const Text(AppString.delete),
          ),
        ],
      ),
    );
  }
}
