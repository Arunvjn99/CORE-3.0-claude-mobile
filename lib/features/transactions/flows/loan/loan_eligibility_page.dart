import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/flow_scaffold.dart';

class LoanEligibilityPage extends StatelessWidget {
  const LoanEligibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Loan Eligibility',
      currentStep: 1,
      totalSteps: 6,
      primaryLabel: 'I\'m Eligible — Continue',
      onPrimary: () => context.go(AppRoutes.loanSimulator),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Check Your Eligibility',
              style: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
          const SizedBox(height: 6),
          const Text('Review your loan eligibility before proceeding.',
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.lightTextSecondary)),
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
                      Text('You\'re Eligible!',
                          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.success)),
                      Text('You qualify for a 401(k) loan. Maximum loan amount: \$71,447',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.success)),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBorder),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: status ? AppColors.iconBgGreen : AppColors.iconBgRed,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(status ? Icons.check_circle : Icons.cancel,
                color: status ? AppColors.success : AppColors.danger, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.lightTextPrimary))),
        ],
      ),
    );
  }
}
