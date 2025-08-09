import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_budget/core/constants/index.dart';
import '../../../../common/widgets/app_button.dart';
import '../../domain/entities/budget.dart';

class BudgetFormScreen extends ConsumerStatefulWidget {
  final Budget? budget;
  final Function(Budget) onSave;

  const BudgetFormScreen({super.key, this.budget, required this.onSave});

  @override
  ConsumerState<BudgetFormScreen> createState() => _BudgetFormScreenState();
}

class _BudgetFormScreenState extends ConsumerState<BudgetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  bool _isHoliday = false;
  String _selectedCategory = AppString.budgeCategories.first;

  @override
  void initState() {
    super.initState();
    _selectedCategory =
        widget.budget?.category ?? AppString.budgeCategories.first;
    _amountController = TextEditingController(
      text: widget.budget?.amount.toString() ?? '',
    );
    _isHoliday = widget.budget?.isHoliday ?? false;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _saveBudget() {
    if (_formKey.currentState!.validate()) {
      final budget = Budget(
        id: widget.budget?.id,
        category: _selectedCategory,
        amount: double.parse(_amountController.text),
        isHoliday: _isHoliday,
      );
      widget.onSave(budget);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.budget == null ? AppString.addBudget : AppString.editBudget),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: AppString.category,
                border: OutlineInputBorder(),
              ),
              items: AppString.budgeCategories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: AppString.amount,
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
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
            CheckboxListTile(
              title: const Text(AppString.holidayBudget),
              value: _isHoliday,
              onChanged: (value) {
                setState(() {
                  _isHoliday = value ?? false;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        AppTextButton(
          onPressed: () => Navigator.of(context).pop(),
          text: AppString.cancel,
        ),
        AppButton(
          width: 80.w,
          onPressed: () => _saveBudget(),
          text: AppString.save,
        ),
      ],
    );
  }
}


