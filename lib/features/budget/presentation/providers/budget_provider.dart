
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_budget/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:home_budget/features/budget/domain/repositories/budget_repository.dart';

import '../../domain/entities/budget.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) => 
BudgetRepositoryImpl());

final budgetListProvider = FutureProvider<List<Budget>>((ref) async {
  final repo = ref.read(budgetRepositoryProvider);

  return await repo.getBudgets();
});

final budgetNotifierProvider = StateNotifierProvider<BudgetNotifier, List<Budget>>((ref) {
  return BudgetNotifier(ref.read(budgetRepositoryProvider));
});

class BudgetNotifier extends StateNotifier<List<Budget>> {
  final BudgetRepository _repository;

  BudgetNotifier(this._repository) : super([]);

  Future<void> loadBudgets() async {
    state = await _repository.getBudgets();
  }

  Future<void> addBudget(Budget budget) async {
    await _repository.addBudget(budget);
    state = await _repository.getBudgets();
  }

  Future<void> updateBudget(Budget budget) async {
    await _repository.updateBudget(budget);
    state = await _repository.getBudgets();
  }

  Future<void> deleteBudget(int id) async {
    await _repository.deleteBudget(id);
    state = await _repository.getBudgets();
  }

}

