import 'package:home_budget/features/expense/data/models/expense_model.dart';
import 'package:home_budget/features/expense/domain/repositories/expense_repository.dart';

import '../../../../core/utils/database_helper.dart';
import '../../domain/entities/expense.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  static final String tableName = 'expenses';

  @override
  Future<List<Expense>> getAllExpenses() async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(tableName, orderBy: 'date DESC');

      return result.map((expense) => ExpenseModel.fromMap(expense)).toList();
    } catch (e) {
      throw Exception('Failed to get expenses: $e');
    }
  }

  @override
  Future<List<Expense>> getExpensesByBudgetId(int budgetId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      tableName,
      where: 'budgetId = ?',
      whereArgs: [budgetId],
      orderBy: 'date DESC',
    );
    return result.map((map) => ExpenseModel.fromMap(map)).toList();
  }

  @override
  Future<int> insertExpense(Expense expense) async {
    try {
      final db = await _dbHelper.database;
      final entry = ExpenseModel.fromEntity(expense);
      return await db.insert(tableName, entry.toMap());
    } catch (e) {
      throw Exception('Failed to create expense: $e');
    }
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    try {
      final db = await _dbHelper.database;
      final entry = ExpenseModel.fromEntity(expense);
      await db.update(
        tableName,
        entry.toMap(),
        where: 'id = ?',
        whereArgs: [entry.id],
      );
    } catch (e) {
      throw Exception('Failed to create expense: $e');
    }
  }

  @override
  Future<void> deleteExpense(int id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }

  @override
  Future<double> getTotalExpensesForBudget(int budgetId) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.rawQuery(
        'SELECT SUM(amount) as total FROM $tableName WHERE budgetId = ?',
        [budgetId],
      );

      return result.first['total'] as double? ?? 0.0;
    } catch (e) {
      throw Exception('Failed to get expenses by budget');
    }
  }

  @override
  Future<List<Expense>> getExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        tableName,
        where: 'date BETWEEN ? AND ?',
        whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
        orderBy: 'date DESC',
      );
      return result.map((map) => ExpenseModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get expenses by date range');
    }
  }
}
