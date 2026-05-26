import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class WithdrawalEligibilityPage extends StatelessWidget {
  const WithdrawalEligibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final eligibilityChecks = [
      (label: 'Hardship Withdrawal', eligible: true, note: 'Available with documentation'),
      (label: 'In-Service Withdrawal', eligible: false, note: 'Requires age 59½ (current: 42)'),
      (label: 'Required Minimum Distribution', eligible: false, note: 'Requires age 73'),
      (label: 'Termination Withdrawal', eligible: false, note: 'Active employment detected'),
    ];

    return FlowScaffold(
      title: 'Withdrawal Eligibility',
      currentStep: 1,
      totalSteps: 6,
      primaryLabel: 'Continue',
      onPrimary: () => context.go(AppRoutes.withdrawalType),
      onBack: () => context.go(AppRoutes.transactions),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Withdrawal Eligibility',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Review your withdrawal eligibility and understand the tax implications.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),

          // Key metrics
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Withdrawal Details',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                _MetricRow(icon: Icons.attach_money, label: 'Available to Withdraw', value: '\$5,000', color: AppColors.primary),
                const SizedBox(height: 12),
                _MetricRow(icon: Icons.percent, label: 'Estimated Tax Withholding', value: '20–35%', color: AppColors.warning),
                const SizedBox(height: 12),
                _MetricRow(icon: Icons.shield_outlined, label: 'Vested Balance', value: '\$25,000', color: AppColors.primary),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Eligibility checks
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Withdrawal Type Eligibility',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                ...eligibilityChecks.map((check) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: check.eligible
                          ? AppColors.successBg
                          : scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: check.eligible
                            ? AppColors.success.withValues(alpha: 0.3)
                            : scheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          check.eligible ? Icons.check_circle : Icons.cancel_outlined,
                          size: 18,
                          color: check.eligible ? AppColors.success : scheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(check.label,
                                  style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600,
                                    color: check.eligible ? scheme.onSurface : scheme.onSurfaceVariant,
                                  )),
                              Text(check.note, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: check.eligible
                                ? AppColors.success.withValues(alpha: 0.15)
                                : scheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            check.eligible ? 'Eligible' : 'Not Eligible',
                            style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w700,
                              color: check.eligible ? AppColors.success : scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Warning banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warningBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber, color: AppColors.warning, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Important Restrictions',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.warning)),
                      const SizedBox(height: 8),
                      ...[
                        'Hardship withdrawals require documentation of financial need',
                        'Taxes and a 10% early withdrawal penalty apply if under age 59½',
                        'Withdrawn funds cannot be returned to your account',
                        'Employer match contributions may have vesting restrictions',
                      ].map((text) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 5, height: 5,
                              margin: const EdgeInsets.only(top: 7, right: 8),
                              decoration: const BoxDecoration(color: AppColors.warning, shape: BoxShape.circle),
                            ),
                            Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.warning))),
                          ],
                        ),
                      )),
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

class _MetricRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MetricRow({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
            ],
          ),
        ),
      ],
    );
  }
}
