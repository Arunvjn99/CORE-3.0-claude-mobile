import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/flow_scaffold.dart';

class LoanEligibilityPage extends StatelessWidget {
  const LoanEligibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FlowScaffold(
      title: 'Loan Eligibility',
      currentStep: 1,
      totalSteps: 6,
      primaryLabel: 'I\'m Eligible — Continue',
      onPrimary: () => context.go(AppRoutes.loanSimulator),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Check Your Eligibility', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Review your loan eligibility before proceeding.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 24),

          _EligibilityItem(icon: Icons.check_circle, text: 'Account in good standing', status: true),
          const SizedBox(height: 10),
          _EligibilityItem(icon: Icons.check_circle, text: 'Minimum balance met (\$10,000)', status: true),
          const SizedBox(height: 10),
          _EligibilityItem(icon: Icons.check_circle, text: 'No outstanding defaulted loans', status: true),
          const SizedBox(height: 10),
          _EligibilityItem(icon: Icons.check_circle, text: 'Employment status: Active', status: true),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.successBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.verified_outlined, color: AppColors.success, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('You\'re Eligible!', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.success)),
                      Text('You qualify for a 401(k) loan. Maximum loan amount: \$71,447', style: TextStyle(fontSize: 12, color: AppColors.success)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EligibilityItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool status;

  const _EligibilityItem({required this.icon, required this.text, required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(status ? Icons.check_circle : Icons.cancel, color: status ? AppColors.success : AppColors.danger, size: 20),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
