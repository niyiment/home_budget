import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getAllExpenses();

  Future<List<Expense>> getExpensesByBudgetId(int budgetId);

  Future<int> insertExpense(Expense expense);

  Future<void> updateExpense(Expense expense);

  Future<void> deleteExpense(int id);

  Future<double> getTotalExpensesForBudget(int budgetId);

  Future<List<Expense>> getExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
}

