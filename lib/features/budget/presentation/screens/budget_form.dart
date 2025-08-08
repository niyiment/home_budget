import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_budget/common/widgets/app_button.dart';
import 'package:home_budget/common/widgets/app_text_field.dart';
import 'package:home_budget/core/constants/index.dart';
import 'package:home_budget/features/budget/presentation/providers/budget_provider.dart';

import '../../domain/entities/budget.dart';



class BudgetFormScreen extends ConsumerStatefulWidget {
  final Budget? budget;

  const BudgetFormScreen({super.key, this.budget});

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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> saveBudget() async {
    if (_formKey.currentState!.validate()) {
      final budget = Budget(
        id: widget.budget?.id,
        category: _selectedCategory,
        amount: double.parse(_amountController.text),
        isHoliday: _isHoliday,
      );

      if (widget.budget == null) {
        ref.read(budgetNotifierProvider.notifier).addBudget(budget);
        _showSuccessSnackBar('Budget saved successfully');
      } else {
        ref.read(budgetNotifierProvider.notifier).updateBudget(budget);
        _showSuccessSnackBar('Budget updated successfully');
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.budget == null ? AppString.addBudget : AppString.editBudget,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              Text(
                'Widget: ${widget.budget?.category} ${widget.budget?.amount}',
                style: TextStyle(color: Colors.white),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    DropdownButtonFormField<String>(
                      padding: const EdgeInsets.only(top: 2.0),
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: AppString.category,
                        labelStyle: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w400,
                        ),
                        border: OutlineInputBorder(),
                        fillColor: AppColors.surface,
                      ),
                      dropdownColor: AppColors.background,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                      items: AppString.budgeCategories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16.h),

                    AppTextField(
                      controller: _amountController,
                      labelText: AppString.amount,
                      hintText: AppString.amountHint,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    AppButton(
                      onPressed: () => saveBudget(),
                      text: AppString.add,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



