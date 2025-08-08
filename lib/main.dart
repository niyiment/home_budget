import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_budget/core/constants/index.dart';
import 'package:home_budget/features/home/presentation/screens/home_screen.dart';
import 'package:home_budget/features/home/presentation/screens/splash_screen.dart';

void main() {
  runApp(const MainApp());
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
          initialRoute: AppRoute.splashScreen,
          routes: {
              AppRoute.splashScreen: (context) => SplashScreen(),
              AppRoute.homeScreen: (context) => HomeScreen()
          },
      ),
    );
  }
}
