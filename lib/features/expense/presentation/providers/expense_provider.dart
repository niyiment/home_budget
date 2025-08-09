
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_budget/features/expense/data/repositories/expense_repository_impl.dart';
import 'package:home_budget/features/expense/domain/repositories/expense_repository.dart';

import '../../domain/entities/expense.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepositoryImpl();
});

final expensesProvider = StateNotifierProvider<ExpenseNotifier, AsyncValue<List<Expense>>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);

  return ExpenseNotifier(repository);
});

final expensesByBudgetProvider = FutureProvider.family<List<Expense>, int>((
  ref,
  budgetId,
) async {
  final repository = ref.watch(expenseRepositoryProvider);
  return await repository.getExpensesByBudgetId(budgetId);
});

final totalExpensesForBudgetProvider = FutureProvider.family<double, int>((
  ref,
  budgetId,
) async {
  final repository = ref.watch(expenseRepositoryProvider);
  return await repository.getTotalExpensesForBudget(budgetId);
});



class ExpenseNotifier extends StateNotifier<AsyncValue<List<Expense>>> {
  final ExpenseRepository _repository;

  ExpenseNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    try {
      state = const AsyncValue.loading();
      final expenses = await _repository.getAllExpenses();
      state = AsyncValue.data(expenses);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      await _repository.insertExpense(expense);
      await loadExpenses();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await _repository.updateExpense(expense);
      await loadExpenses();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      await _repository.deleteExpense(id);
      await loadExpenses();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

}



