import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_budget/common/widgets/loading_indicator.dart';
import 'package:home_budget/features/budget/presentation/providers/budget_provider.dart';
import 'package:home_budget/features/budget/presentation/screens/budget_form.dart';

import '../../../../common/widgets/app_button.dart';
import '../../../../core/constants/index.dart';
import '../../domain/entities/budget.dart';
import '../widgets/budget_card.dart';



class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(budgetsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppString.budgetTile),
        actions: [
          IconButton(
            onPressed: () => _showAddBudgetDialog(context, ref),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: budgetsAsync.when(
        data: (budgets) {
          if (budgets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 16.h),
                  Text(AppString.noBudget),
                  Text(AppString.noBudgetSubtitle),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              final budget = budgets[index];
              return BudgetCard(
                budget: budget,
                onTap: () => _showEditBudgetDialog(context, ref, budget),
                onDelete: () => _deleteBudget(context, ref, budget.id!),
              );
            },
          );
        },
        loading: () => Center(child: AppLoading()),
        error: (error, _) => Center(
          child: Column(
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16.h),
              Text(AppString.budgetErrorMessage),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => BudgetFormScreen(
        onSave: (budget) {
          ref.read(budgetsProvider.notifier).addBudget(budget);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showEditBudgetDialog(
    BuildContext context,
    WidgetRef ref,
    Budget budget,
  ) {
    showDialog(
      context: context,
      builder: (context) => BudgetFormScreen(
        budget: budget,
        onSave: (updatedBudget) {
          ref.read(budgetsProvider.notifier).updateBudget(updatedBudget);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _deleteBudget(BuildContext context, WidgetRef ref, int budgetId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppString.deleteBudget),
        content: const Text(AppString.deleteMessage),
        actions: [
          AppTextButton(
            onPressed: () => Navigator.of(context).pop(),
            text: AppString.cancel,
          ),
          AppTextButton(
            onPressed: () {
              ref.read(budgetsProvider.notifier).deleteBudget(budgetId);
              Navigator.of(context).pop();
            },
            text: AppString.delete,
          ),
        ],
      ),
    );
  }
  
}
