import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_budget/common/widgets/loading_indicator.dart';
import 'package:home_budget/features/budget/presentation/providers/budget_provider.dart';
import 'package:home_budget/features/budget/presentation/screens/budget_form.dart';

import '../../../../common/widgets/app_button.dart';
import '../../../../core/constants/index.dart';

class BudgetList extends ConsumerWidget {
  const BudgetList({super.key});

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
              ref.read(budgetNotifierProvider.notifier).deleteBudget(budgetId);
              Navigator.of(context).pop();
            },
            text: AppString.delete,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(budgetListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(AppString.budgetTile)),
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
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              final budget = budgets[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: budget.isHoliday
                      ? Colors.orange
                      : Theme.of(context).primaryColor,
                  child: Icon(
                    budget.isHoliday
                        ? Icons.celebration
                        : Icons.account_balance_wallet,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  budget.category,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  budget.amount.toStringAsFixed(2),
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: AppColors.textPrimary,
                  ),
                ),
                trailing: PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: AppColors.textPrimary),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: const Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: const Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BudgetFormScreen(budget: budget),
                        ),
                      );
                    } else if (value == 'delete') {
                      _deleteBudget(context, ref, budget.id!);
                    }
                  },
                ),
              );
            },
          );
        },
        loading: () => Center(child: AppLoading()),
        error: (error, _) => Center(child: Text('Error $error')),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: () => Navigator.pushNamed(context, AppRoute.budgetForm),
        child: const Icon(Icons.add),
      ),
    );
  }
}
