import 'package:flutter/material.dart';
import 'package:home_budget/core/constants/index.dart';
import 'package:home_budget/features/budget/presentation/screens/budget_screen.dart';

import '../../../financial_guide/presentation/screens/financial_guide_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const BudgetList(),
    Center(child: Text(AppString.expenseTitle)),
    FinancialGuideScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Budgets'),

          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Expenses'),

          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'Guide'),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppString.home),
        centerTitle: true,
      ),
      body: Center(
        child: Text(AppString.home),
      ),
    );
  }
}


