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

  double _calcProjected(EnrollmentDraft draft) {
    final rate = draft.contributionRate ?? 6.0;
    const salary = 75000.0;
    const matchRate = 3.0;
    double total = 0;
    final annual = salary * rate / 100 + salary * matchRate / 100;
    for (int y = 0; y < 30; y++) {
      total = (total + annual) * 1.07;
    }
    return total;
  }

  String _fmtCurrency(double v) {
    if (v >= 1000000) return '\$${(v / 1000000).toStringAsFixed(2)}M';
    if (v >= 1000) return '\$${(v / 1000).toStringAsFixed(0)}K';
    return '\$${v.toStringAsFixed(0)}';
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

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final draft = ref.watch(enrollmentProvider);
    final projected = _calcProjected(draft);
    final rate = draft.contributionRate ?? 6.0;
    const salary = 75000.0;
    final annualContrib = salary * rate / 100;
    final annualMatch = salary * 3.0 / 100;

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
          const Text('Review Your Enrollment', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
          const SizedBox(height: 4),
          const Text('Please confirm your enrollment details before submitting.', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.5)),
          const SizedBox(height: 20),

          // Projected balance hero
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E40AF), Color(0xFF4F46E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Projected Balance at Retirement', style: TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w500, letterSpacing: 0.3)),
                const SizedBox(height: 8),
                Text(
                  _fmtCurrency(projected),
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(height: 4),
                const Text('Based on current plan · 30-year horizon · 7% avg return', style: TextStyle(fontSize: 11, color: Colors.white60)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 4 stat cards
          Row(
            children: [
              Expanded(child: _StatCard(
                icon: Icons.attach_money,
                label: 'Your Contribution',
                value: _fmtCurrency(annualContrib),
                sub: 'per year',
                color: AppColors.primary,
              )),
              const SizedBox(width: 10),
              Expanded(child: _StatCard(
                icon: Icons.business_center_outlined,
                label: 'Employer Match',
                value: _fmtCurrency(annualMatch),
                sub: 'per year',
                color: AppColors.success,
              )),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _StatCard(
                icon: Icons.trending_up,
                label: 'Growth Rate',
                value: '7.0%',
                sub: 'avg annual return',
                color: const Color(0xFF7C3AED),
              )),
              const SizedBox(width: 10),
              Expanded(child: _StatCard(
                icon: Icons.access_time_outlined,
                label: 'Time Horizon',
                value: '30 yrs',
                sub: 'to retirement',
                color: AppColors.warning,
              )),
            ],
          ),
          const SizedBox(height: 24),

          // Section cards with edit buttons
          _ReviewSection(
            title: 'Plan Selection',
            icon: Icons.account_balance_outlined,
            editRoute: AppRoutes.enrollmentPlan,
            rows: [
              ('Plan Type', draft.plan == PlanType.roth ? 'Roth 401(k)' : 'Traditional 401(k)'),
            ],
          ),
          const SizedBox(height: 12),
          _ReviewSection(
            title: 'Contribution',
            icon: Icons.payments_outlined,
            editRoute: AppRoutes.enrollmentContribution,
            rows: [
              ('Rate', '${rate.toStringAsFixed(0)}%'),
              ('Type', draft.contributionType == ContributionType.percentage ? 'Percentage' : 'Fixed'),
              ('Source', _sourceLabel(draft.source)),
            ],
          ),
          const SizedBox(height: 12),
          _ReviewSection(
            title: 'Auto Increase',
            icon: Icons.trending_up,
            editRoute: AppRoutes.enrollmentAutoIncrease,
            rows: [
              ('Enabled', draft.autoIncreaseEnabled ? 'Yes' : 'No'),
              if (draft.autoIncreaseEnabled) ('Annual Increase', '${draft.autoIncreasePercent?.toStringAsFixed(1) ?? '1.0'}%'),
              if (draft.autoIncreaseEnabled) ('Maximum Cap', '${draft.autoIncreaseMax?.toStringAsFixed(0) ?? '15'}%'),
            ],
          ),
          const SizedBox(height: 12),
          _ReviewSection(
            title: 'Investment Strategy',
            icon: Icons.pie_chart_outline,
            editRoute: AppRoutes.enrollmentInvestment,
            rows: [
              ('Risk Level', _riskLabel(draft.riskLevel)),
            ],
          ),
          const SizedBox(height: 24),

          // Consent
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _agreed ? AppColors.primary.withValues(alpha: 0.4) : scheme.outline.withValues(alpha: 0.4)),
            ),
            child: GestureDetector(
              onTap: () => setState(() => _agreed = !_agreed),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24, height: 24,
                    child: Checkbox(
                      value: _agreed,
                      onChanged: (v) => setState(() => _agreed = v ?? false),
                      activeColor: AppColors.primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'I confirm that the above information is accurate and I agree to the Terms of Service and Privacy Policy.',
                      style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _sourceLabel(SourceType? source) {
    switch (source) {
      case SourceType.pretax: return 'Pre-Tax (Traditional)';
      case SourceType.roth: return 'Roth (After-Tax)';
      case SourceType.split: return 'Split';
      case null: return 'Pre-Tax';
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String sub;
  final Color color;

  const _StatCard({required this.icon, required this.label, required this.value, required this.sub, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
          Text(sub, style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF))),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
        ],
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final String editRoute;
  final List<(String, String)> rows;

  const _ReviewSection({required this.title, required this.icon, required this.editRoute, required this.rows});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
                GestureDetector(
                  onTap: () => context.go(editRoute),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit_outlined, size: 12, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text('Edit', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
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
