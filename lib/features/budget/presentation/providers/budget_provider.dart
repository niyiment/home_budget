import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_budget/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:home_budget/features/budget/domain/repositories/budget_repository.dart';

import '../../domain/entities/budget.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>(
  (ref) => BudgetRepositoryImpl(),
);

final budgetListProvider = FutureProvider<List<Budget>>((ref) async {
  final repo = ref.read(budgetRepositoryProvider);

  return await repo.getBudgets();
});

final budgetNotifierProvider =
    StateNotifierProvider<BudgetNotifier, AsyncValue<List<Budget>>>((ref) {
      final repository = ref.watch(budgetRepositoryProvider);
      return BudgetNotifier(repository);
    });

class BudgetNotifier extends StateNotifier<AsyncValue<List<Budget>>> {
  final BudgetRepository _repository;

  BudgetNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadBudgets();
  }

  Future<void> loadBudgets() async {
    try {
      state = const AsyncValue.loading();
      final budgets = await _repository.getBudgets();
      state = AsyncValue.data(budgets);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addBudget(Budget budget) async {
    try {
      await _repository.addBudget(budget);
      await loadBudgets();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateBudget(Budget budget) async {
    try {
      await _repository.updateBudget(budget);
      await loadBudgets();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteBudget(int id) async {
    try {
      await _repository.deleteBudget(id);
      await loadBudgets();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> getHolidayBudgets() async {
    try {
      state = const AsyncValue.loading();
      final budgets = await _repository.getHolidayBudgets();
      state = AsyncValue.data(budgets);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
