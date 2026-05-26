import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/flow_scaffold.dart';

class LoanReviewPage extends StatelessWidget {
  const LoanReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
          Text('Review Your Loan', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Please confirm your loan details before submitting.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
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
            decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.info.withValues(alpha: 0.3))),
            child: const Text('Your loan will be disbursed within 3-5 business days after approval.', style: TextStyle(fontSize: 12, color: AppColors.info, height: 1.5)),
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
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: BorderRadius.circular(12), border: Border.all(color: scheme.outline.withValues(alpha: 0.5))),
      child: Column(
        children: rows.asMap().entries.map((e) {
          final (label, value) = e.value;
          return Column(
            children: [
              if (e.key > 0) const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
                    Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
