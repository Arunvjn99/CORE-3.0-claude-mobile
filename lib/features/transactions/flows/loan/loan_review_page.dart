import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/flow_scaffold.dart';

class LoanReviewPage extends StatelessWidget {
  const LoanReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Review & Submit',
      currentStep: 6,
      totalSteps: 6,
      primaryLabel: 'Submit Loan Request',
      onPrimary: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Loan Submitted!'),
            content: const Text('Your loan request has been submitted. You will receive a confirmation email shortly.'),
            actions: [TextButton(onPressed: () { Navigator.pop(context); context.go(AppRoutes.postEnrollmentDashboard); }, child: const Text('Done'))],
          ),
        );
      },
      onBack: () => context.go(AppRoutes.loanDocuments),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Review Your Loan',
              style: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
          const SizedBox(height: 6),
          const Text('Please confirm your loan details before submitting.',
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.lightTextSecondary)),
          const SizedBox(height: 24),
          _ReviewCard(rows: [
            ('Loan Amount', '\$10,000'),
            ('Interest Rate', '6.50% APR'),
            ('Term', '24 months'),
            ('Monthly Payment', '\$443.21'),
            ('Total Repayment', '\$10,637.04'),
            ('Disbursement', 'Direct Deposit'),
          ]),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.iconBgBlue,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: const Text('Your loan will be disbursed within 3-5 business days after approval.',
                style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.primary, height: 1.5)),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final List<(String, String)> rows;
  const _ReviewCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBorder),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: rows.asMap().entries.map((e) {
          final (label, value) = e.value;
          return Column(
            children: [
              if (e.key > 0) Divider(height: 1, color: AppColors.lightBorder),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.lightTextSecondary)),
                    Text(value, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary)),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
