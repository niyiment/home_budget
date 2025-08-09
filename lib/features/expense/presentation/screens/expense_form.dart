import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_budget/common/widgets/app_button.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/index.dart';
import '../../../budget/domain/entities/budget.dart';
import '../../../budget/presentation/providers/budget_provider.dart';
import '../../domain/entities/expense.dart';


class ExpenseFormScreen extends ConsumerStatefulWidget {
  final Expense? expense;
  final Function(Expense) onSave;

  const ExpenseFormScreen({super.key, this.expense, required this.onSave});

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  Budget? _selectedBudget;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _amountController.text = widget.expense!.amount.toString();
      _descriptionController.text = widget.expense!.description;
      _selectedDate = widget.expense!.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final budgetsAsync = ref.watch(budgetsProvider);

    return AlertDialog(
      title: Text(widget.expense == null ? AppString.addExpense: AppString.editBudget),
      content: budgetsAsync.when(
        data: (budgets) {
          if (budgets.isEmpty) {
            return const Text(
              'Please create a budget first before adding expenses.',
            );
          }

          if (_selectedBudget == null && widget.expense?.budgetId != null) {
            try {
              _selectedBudget = budgets.firstWhere(
                (b) => b.id == widget.expense!.budgetId,
              );
            } catch (e) {
              _selectedBudget = budgets.isNotEmpty ? budgets.first : null;
            }
          } else {
            _selectedBudget ??= budgets.first;
          }

          return Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<Budget>(
                  value: _selectedBudget,
                  decoration: const InputDecoration(
                    labelText: AppString.category,
                    border: OutlineInputBorder(),
                  ),
                  items: budgets.map((budget) {
                    return DropdownMenuItem(
                      value: budget,
                      child: Text(budget.category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBudget = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  decoration:  InputDecoration(
                    labelText: AppString.amount,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: AppString.description,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text(AppString.date),
                  subtitle: Text(
                    DateFormat('MMM dd, yyyy').format(_selectedDate),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: _selectDate,
                ),
              ],
            ),
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, _) => Text('Error: $error'),
      ),
      actions: [
         AppTextButton(
          onPressed: () => Navigator.of(context).pop(),
          text: AppString.cancel,
        ),
        AppButton(
          width: 90.w,
          onPressed: () => _saveExpense(context),
          text: AppString.save,
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveExpense(BuildContext context) {
    if (_formKey.currentState!.validate() && _selectedBudget != null) {
      final expense = Expense(
        id: widget.expense?.id,
        budgetId: _selectedBudget!.id,
        amount: double.parse(_amountController.text),
        description: _descriptionController.text,
        date: _selectedDate,
      );
      widget.onSave(expense);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
