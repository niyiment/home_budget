import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/index.dart';

class FinancialGuideScreen extends StatelessWidget {
  const FinancialGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Financial Guide')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildGuideSection(
            'Budgeting Basics',
            'Learn the fundamentals of creating and managing a budget',
            [
              'Track your income and expenses',
              'Set realistic spending limits',
              'Review and adjust regularly',
              'Use the 50/30/20 rule as a starting point',
            ],
          ),
          _buildGuideSection(
            'Saving Strategies',
            'Effective ways to build your savings',
            [
              'Pay yourself first',
              'Automate your savings',
              'Start with small amounts',
              'Set specific savings goals',
            ],
          ),
          _buildGuideSection(
            'Holiday Budget Planning',
            'Special tips for managing holiday expenses',
            [
              'Start planning early',
              'Set a total holiday budget',
              'Track gift expenses separately',
              'Consider alternative celebrations',
            ],
          ),
          _buildGuideSection('Emergency Fund', 'Building financial security', [
            'Aim for 3-6 months of expenses',
            'Keep it in a separate account',
            'Only use for true emergencies',
            'Build gradually over time',
          ]),
          _buildGuideSection(
            'Debt Management',
            'Strategies for paying off debt',
            [
              'List all your debts',
              'Consider debt snowball or avalanche method',
              'Avoid taking on new debt',
              'Negotiate with creditors if needed',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuideSection(
    String title,
    String description,
    List<String> tips,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(description, style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 12.h),
            ...tips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: Text(tip)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
