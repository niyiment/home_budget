import 'package:home_budget/core/utils/database_helper.dart';
import 'package:home_budget/features/budget/domain/entities/budget.dart';
import 'package:home_budget/features/budget/domain/repositories/budget_repository.dart';

import '../models/budget_model.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  static final String tableName = 'budgets';


  @override
  Future<List<Budget>> getBudgets() async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(tableName);

      return result.map((budget) => BudgetModel.fromMap(budget)).toList();
    } catch (e) {
      throw Exception('Failed to get budgets: $e');
    }
  }

  @override
  Future<Budget?> getBudgetById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return BudgetModel.fromMap(result.first);
    }
    return null;
  }


  @override
  Future<int> addBudget(Budget budget) async {
    try {
      final db = await _dbHelper.database;
      final entry = BudgetModel.fromEntity(budget);
      int id =await db.insert(tableName, entry.toMap());
      return id;
    } catch (e) {
      throw Exception('Failed to create budget: $e');
    }
  }
  
  @override
  Future<void> updateBudget(Budget budget) async {
    try {
      final db = await _dbHelper.database;
      final entry = BudgetModel.fromEntity(budget);
      await db.update(tableName, entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id]
      );
    } catch(e) {
      throw Exception('Failed to update budget: $e');
    }
    
  }

  @override
  Future<void> deleteBudget(int id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Failed to delete budget: $e');
    }
  }

  @override
  Future<List<Budget>> getHolidayBudgets() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      tableName,
      where: 'isHoliday = ?',
      whereArgs: [1],
    );
    return result.map((map) => BudgetModel.fromMap(map)).toList();
  }
}