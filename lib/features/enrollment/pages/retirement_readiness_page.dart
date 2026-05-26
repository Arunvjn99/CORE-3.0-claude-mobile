import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/flow_scaffold.dart';

class RetirementReadinessPage extends ConsumerWidget {
  const RetirementReadinessPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return FlowScaffold(
      title: 'Retirement Readiness',
      currentStep: 6,
      totalSteps: 8,
      primaryLabel: 'Continue',
      onPrimary: () {
        ref.read(enrollmentProvider.notifier).setReadiness(78);
        context.go(AppRoutes.enrollmentReview);
      },
      onBack: () => context.go(AppRoutes.enrollmentInvestment),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Readiness Score', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Based on your inputs, here is your projected retirement readiness.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 28),

          // Score circle
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: 0.78,
                    strokeWidth: 12,
                    backgroundColor: scheme.surfaceContainerHigh,
                    valueColor: const AlwaysStoppedAnimation(AppColors.success),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  children: [
                    const Text('78', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800)),
                    Text('/100', style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.successBg,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 16),
                  SizedBox(width: 6),
                  Text('Good Progress', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Breakdown
          _ReadinessItem(label: 'Contribution Rate', score: 80, detail: '6% of salary'),
          const SizedBox(height: 8),
          _ReadinessItem(label: 'Investment Mix', score: 75, detail: 'Balanced portfolio'),
          const SizedBox(height: 8),
          _ReadinessItem(label: 'Time Horizon', score: 85, detail: '28 years to retirement'),
          const SizedBox(height: 8),
          _ReadinessItem(label: 'Savings Rate', score: 70, detail: 'Room to improve'),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Projected Retirement Income', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                SizedBox(height: 4),
                Text('\$2,850 / month', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary)),
                SizedBox(height: 4),
                Text('Based on current savings rate and investment strategy', style: TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadinessItem extends StatelessWidget {
  final String label;
  final int score;
  final String detail;

  const _ReadinessItem({required this.label, required this.score, required this.detail});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = score >= 80 ? AppColors.success : score >= 60 ? AppColors.warning : AppColors.danger;
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: scheme.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text('$score', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}
