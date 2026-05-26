import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../../../core/models/enrollment_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/flow_scaffold.dart';

class ReviewEnrollmentPage extends ConsumerStatefulWidget {
  const ReviewEnrollmentPage({super.key});
  @override
  ConsumerState<ReviewEnrollmentPage> createState() => _ReviewEnrollmentPageState();
}

class _ReviewEnrollmentPageState extends ConsumerState<ReviewEnrollmentPage> {
  bool _agreed = false;

  Future<void> _submit() async {
    ref.read(enrollmentProvider.notifier).confirmReview();
    await ref.read(enrollmentProvider.notifier).complete();
    if (!mounted) return;
    context.go(AppRoutes.enrollmentSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final draft = ref.watch(enrollmentProvider);

    return FlowScaffold(
      title: 'Review & Confirm',
      currentStep: 7,
      totalSteps: 8,
      primaryLabel: 'Submit Enrollment',
      primaryEnabled: _agreed,
      onPrimary: _submit,
      onBack: () => context.go(AppRoutes.enrollmentReadiness),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review Your Enrollment', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Please confirm your enrollment details before submitting.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 24),

          _SectionCard(
            title: 'Plan Selection',
            icon: Icons.account_balance_outlined,
            rows: [
              ('Plan Type', draft.plan == PlanType.roth ? 'Roth 401(k)' : 'Traditional 401(k)'),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Contribution',
            icon: Icons.payments_outlined,
            rows: [
              ('Rate', '${draft.contributionRate?.toStringAsFixed(0) ?? '6'}%'),
              ('Type', draft.contributionType == ContributionType.percentage ? 'Percentage' : 'Fixed'),
              ('Source', draft.source?.name.toUpperCase() ?? 'Pre-Tax'),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Auto Increase',
            icon: Icons.trending_up,
            rows: [
              ('Enabled', draft.autoIncreaseEnabled ? 'Yes' : 'No'),
              if (draft.autoIncreaseEnabled) ('Annual Increase', '${draft.autoIncreasePercent?.toStringAsFixed(0) ?? '1'}%'),
              if (draft.autoIncreaseEnabled) ('Maximum', '${draft.autoIncreaseMax?.toStringAsFixed(0) ?? '15'}%'),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Investment Strategy',
            icon: Icons.pie_chart_outline,
            rows: [
              ('Risk Level', _riskLabel(draft.riskLevel)),
            ],
          ),
          const SizedBox(height: 24),

          // Consent
          GestureDetector(
            onTap: () => setState(() => _agreed = !_agreed),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _agreed,
                  onChanged: (v) => setState(() => _agreed = v ?? false),
                  activeColor: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'I confirm that the above information is accurate and I agree to the Terms of Service and Privacy Policy.',
                    style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _riskLabel(RiskLevel? level) {
    switch (level) {
      case RiskLevel.conservative: return 'Conservative';
      case RiskLevel.balanced: return 'Balanced';
      case RiskLevel.growth: return 'Growth';
      case RiskLevel.aggressive: return 'Aggressive';
      case null: return 'Balanced';
    }
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<(String, String)> rows;

  const _SectionCard({required this.title, required this.icon, required this.rows});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              ],
            ),
          ),
          const Divider(height: 1),
          ...rows.map((row) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(row.$1, style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
                Text(row.$2, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
