import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_budget/core/constants/index.dart';
import 'package:intl/intl.dart';

import '../../../budget/domain/entities/budget.dart';
import '../../../budget/presentation/providers/budget_provider.dart';
import '../../../budget/presentation/screens/budget_screen.dart';
import '../../../budget/presentation/widgets/budget_card.dart';
import '../../../expense/domain/entities/expense.dart';
import '../../../expense/presentation/providers/expense_provider.dart';
import '../../../expense/presentation/screens/expense_screen.dart';
import '../../../financial_guide/presentation/screens/financial_guide_screen.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(budgetsProvider);
    final expensesAsync = ref.watch(expensesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppString.home), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(budgetsAsync, expensesAsync),
            const SizedBox(height: 24),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            _buildRecentBudgets(budgetsAsync),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(
    AsyncValue<List<Budget>> budgetsAsync,
    AsyncValue<List<Expense>> expensesAsync,
  ) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.account_balance_wallet, color: Colors.green),
                  const SizedBox(height: 8),
                  const Text(AppString.totalBudget),
                  budgetsAsync.when(
                    data: (budgets) {
                      final total = budgets.fold(
                        0.0,
                        (sum, budget) => sum + budget.amount,
                      );
                      return Text(
                        NumberFormat.currency(symbol: '\$').format(total),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (_, __) => const Text(AppString.homeErrorMessage),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.receipt, color: Colors.red),
                  const SizedBox(height: 8),
                  const Text(AppString.totalExpenses),
                  expensesAsync.when(
                    data: (expenses) {
                      final total = expenses.fold(
                        0.0,
                        (sum, expense) => sum + expense.amount,
                      );
                      return Text(
                        NumberFormat.currency(symbol: '\$').format(total),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (_, __) => const Text('Error'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              context,
              AppString.addBudget,
              Icons.add_circle,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BudgetScreen()),
              ),
            ),
            _buildActionButton(
              context,
              AppString.addExpense,
              Icons.receipt_long,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ExpenseScreen()),
              ),
            ),
            _buildActionButton(
              context,
              AppString.viewGuide,
              Icons.lightbulb,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FinancialGuideScreen(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Card(
      elevation: 2.5,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
              ),
              child: Icon(icon),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentBudgets(AsyncValue<List<Budget>> budgetsAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppString.recentBudget,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        budgetsAsync.when(
          data: (budgets) {
            if (budgets.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(AppString.noBudgetSubtitle2),
                ),
              );
            }
            return Column(
              children: budgets
                  .take(3)
                  .map((budget) => BudgetCard(budget: budget, onTap: () {}))
                  .toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text(AppString.homeErrorMessage),
        ),
      ],
    );
  }
}
