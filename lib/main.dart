import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_budget/core/constants/index.dart';
import 'package:home_budget/features/budget/presentation/screens/budget_screen.dart';
import 'package:home_budget/features/expense/presentation/screens/expense_screen.dart';
import 'package:home_budget/features/financial_guide/presentation/screens/financial_guide_screen.dart';
import 'package:home_budget/features/home/presentation/screens/home_screen.dart';
import 'package:home_budget/features/home/presentation/screens/splash_screen.dart';

void main() {
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title: 'Home Budgeting App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRoute.splash,
        routes: {
          AppRoute.splash: (context) => SplashScreen(),
          AppRoute.home: (context) => HomeScreen(),
          AppRoute.budget: (context) => BudgetScreen(),
          AppRoute.expense: (context) => ExpenseScreen(),
          AppRoute.guide: (context) => FinancialGuideScreen(),
        },
      ),
    );
  }
}
