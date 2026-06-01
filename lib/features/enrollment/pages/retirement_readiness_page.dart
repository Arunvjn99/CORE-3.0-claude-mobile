import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../../../core/models/enrollment_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/flow_scaffold.dart';

class _Suggestion {
  final String id;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final int scoreIncrease;
  final int newScore;
  final int additionalAnnual;
  final String currentLabel;
  final String currentValue;
  final String newLabel;
  final String newValue;
  final void Function(WidgetRef) apply;

  const _Suggestion({
    required this.id, required this.icon, required this.iconColor,
    required this.title, required this.description, required this.scoreIncrease,
    required this.newScore, required this.additionalAnnual, required this.currentLabel,
    required this.currentValue, required this.newLabel, required this.newValue,
    required this.apply,
  });
}

class RetirementReadinessPage extends ConsumerStatefulWidget {
  const RetirementReadinessPage({super.key});
  @override
  ConsumerState<RetirementReadinessPage> createState() => _RetirementReadinessPageState();
}

class _RetirementReadinessPageState extends ConsumerState<RetirementReadinessPage> {
  final Set<String> _applied = {};
  _Suggestion? _confirming;
  bool _showSuccess = false;

  static const _salary = 75000.0;
  static const _yearsToRetirement = 30;

  int _computeScore(EnrollmentDraft draft) {
    final rate = draft.contributionRate ?? 6.0;
    final contrib = (rate * 5).clamp(0, 50);
    final autoInc = draft.autoIncreaseEnabled ? 12 : 0;
    final riskBonus = draft.riskLevel == RiskLevel.growth ? 3 : draft.riskLevel == RiskLevel.aggressive ? 5 : 0;
    return (contrib + autoInc + 15 + riskBonus).round().clamp(0, 100);
  }

  double _projectBalance(double rate) {
    double total = 0;
    final annual = _salary * rate / 100 + _salary * 3.0 / 100;
    for (int y = 0; y < _yearsToRetirement; y++) total = (total + annual) * 1.07;
    return total;
  }

  String _fmtCurrency(double v) {
    if (v >= 1000000) return '\$${(v / 1000000).toStringAsFixed(2)}M';
    if (v >= 1000) return '\$${(v / 1000).toStringAsFixed(0)}K';
    return '\$${v.toStringAsFixed(0)}';
  }

  Color _scoreColor(int score) {
    if (score >= 70) return AppColors.success;
    if (score >= 50) return AppColors.warning;
    return AppColors.danger;
  }

  String _scoreMessage(int score) {
    if (score >= 80) return 'Excellent! You\'re on track for a comfortable retirement.';
    if (score >= 60) return 'Good progress! A few tweaks could significantly boost your score.';
    if (score >= 40) return 'You\'re getting started. Apply suggestions below to improve.';
    return 'Your retirement savings need attention. Apply the recommendations.';
  }

  List<_Suggestion> _buildSuggestions(EnrollmentDraft draft, int currentScore) {
    final suggestions = <_Suggestion>[];
    final currentRate = draft.contributionRate ?? 6.0;

    // 1. Boost contribution
    final boostedRate = currentRate + 2;
    if (boostedRate <= 25 && !_applied.contains('boost-contribution')) {
      final newScore = (_computeScore(draft.copyWith(contributionRate: boostedRate))).clamp(0, 100);
      final extra = ((_salary * boostedRate / 100) - (_salary * currentRate / 100)).round();
      suggestions.add(_Suggestion(
        id: 'boost-contribution',
        icon: Icons.percent,
        iconColor: AppColors.primary,
        title: 'Increase Contribution by 2%',
        description: 'Boost from ${currentRate.toStringAsFixed(0)}% to ${boostedRate.toStringAsFixed(0)}% to significantly grow your retirement nest egg.',
        scoreIncrease: newScore - currentScore,
        newScore: newScore,
        additionalAnnual: extra,
        currentLabel: 'Current Rate',
        currentValue: '${currentRate.toStringAsFixed(0)}%',
        newLabel: 'New Rate',
        newValue: '${boostedRate.toStringAsFixed(0)}%',
        apply: (ref) => ref.read(enrollmentProvider.notifier).setContribution(rate: boostedRate, type: draft.contributionType),
      ));
    }

    // 2. Enable Auto Increase
    if (!draft.autoIncreaseEnabled && !_applied.contains('enable-auto-increase')) {
      final newScore = (_computeScore(draft.copyWith(autoIncreaseEnabled: true))).clamp(0, 100);
      suggestions.add(_Suggestion(
        id: 'enable-auto-increase',
        icon: Icons.trending_up,
        iconColor: AppColors.success,
        title: 'Enable Auto Increase',
        description: 'Auto-increment your contributions by 1% annually until 15% max.',
        scoreIncrease: newScore - currentScore,
        newScore: newScore,
        additionalAnnual: (_salary * 0.01).round(),
        currentLabel: 'Auto Increase',
        currentValue: 'Off',
        newLabel: 'Auto Increase',
        newValue: '+1% / yr',
        apply: (ref) => ref.read(enrollmentProvider.notifier).setAutoIncrease(enabled: true, percent: 1.0, max: 15.0),
      ));
    }

    // 3. Upgrade strategy
    final growthUpgrade = <RiskLevel, RiskLevel>{
      RiskLevel.conservative: RiskLevel.balanced,
      RiskLevel.balanced: RiskLevel.growth,
    };
    final nextRisk = growthUpgrade[draft.riskLevel ?? RiskLevel.balanced];
    if (nextRisk != null && !_applied.contains('upgrade-strategy')) {
      final newScore = (_computeScore(draft.copyWith(riskLevel: nextRisk))).clamp(0, 100);
      suggestions.add(_Suggestion(
        id: 'upgrade-strategy',
        icon: Icons.auto_awesome,
        iconColor: const Color(0xFF7C3AED),
        title: 'Upgrade Investment Strategy',
        description: 'Switch to a higher-growth strategy for a potentially larger retirement balance.',
        scoreIncrease: newScore - currentScore,
        newScore: newScore,
        additionalAnnual: 800,
        currentLabel: 'Strategy',
        currentValue: _riskLabel(draft.riskLevel ?? RiskLevel.balanced),
        newLabel: 'New Strategy',
        newValue: _riskLabel(nextRisk),
        apply: (ref) => ref.read(enrollmentProvider.notifier).setInvestment(riskLevel: nextRisk),
      ));
    }

    suggestions.sort((a, b) => b.scoreIncrease.compareTo(a.scoreIncrease));
    return suggestions;
  }

  String _riskLabel(RiskLevel level) {
    switch (level) {
      case RiskLevel.conservative: return 'Conservative';
      case RiskLevel.balanced: return 'Balanced';
      case RiskLevel.growth: return 'Growth';
      case RiskLevel.aggressive: return 'Aggressive';
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final draft = ref.watch(enrollmentProvider);
    final score = _computeScore(draft);
    final scoreColor = _scoreColor(score);
    final balance = _projectBalance(draft.contributionRate ?? 6.0);
    final suggestions = _buildSuggestions(draft, score);
    final potentialScore = suggestions.isNotEmpty ? suggestions.map((s) => s.newScore).reduce((a, b) => a > b ? a : b) : score;

    return FlowScaffold(
      title: 'Retirement Readiness',
      currentStep: 6,
      totalSteps: 8,
      primaryLabel: 'Continue',
      onPrimary: () {
        ref.read(enrollmentProvider.notifier).setReadiness(score);
        context.go(AppRoutes.enrollmentReview);
      },
      onBack: () => context.go(AppRoutes.enrollmentInvestment),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Readiness Score', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: scheme.onSurface)),
          const SizedBox(height: 4),
          Text('Based on your enrollment choices. Apply suggestions to improve your score.', style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant, height: 1.5)),
          const SizedBox(height: 20),

          // Score card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))],
              border: Border.all(color: scheme.outline.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                // Score circle
                SizedBox(
                  width: 160,
                  height: 160,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 160, height: 160,
                        child: CircularProgressIndicator(
                          value: score / 100,
                          strokeWidth: 12,
                          backgroundColor: scheme.surfaceContainerHigh,
                          valueColor: AlwaysStoppedAnimation(scoreColor),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('$score', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: scheme.onSurface)),
                          Text('/100', style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(color: scoreColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(score >= 60 ? Icons.check_circle : Icons.info_outline, color: scoreColor, size: 16),
                      const SizedBox(width: 6),
                      Text(_scoreMessage(score).split('!').first + (score >= 60 ? '!' : ''), style: TextStyle(color: scoreColor, fontWeight: FontWeight.w700, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 14),
                // Projected balance
                Column(
                  children: [
                    Text('PROJECTED BALANCE AT RETIREMENT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: scheme.onSurfaceVariant, letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    Text(_fmtCurrency(balance), style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: scheme.onSurface)),
                    Text('Age 65 · 7% avg return · 30-year horizon', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Annual Funding Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: scheme.outline.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Annual Funding Summary', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: scheme.onSurface)),
                const SizedBox(height: 12),
                _FundingRow(label: 'Income Goal (80% of salary)', value: '\$${((_salary * 0.8) / 1000).toStringAsFixed(0)}K', color: scheme.onSurfaceVariant, dot: const Color(0xFF9CA3AF)),
                const SizedBox(height: 8),
                _FundingRow(label: 'Your Contributions', value: '\$${((_salary * (draft.contributionRate ?? 6) / 100) / 1000).toStringAsFixed(0)}K', color: AppColors.primary, dot: AppColors.primary),
                const SizedBox(height: 8),
                _FundingRow(label: 'Employer Match', value: '\$${(_salary * 3 / 100 / 1000).toStringAsFixed(0)}K', color: AppColors.success, dot: AppColors.success),
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Text('Projected gap closes over time with compound growth.', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Success message
          if (_showSuccess) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.successBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 18),
                  SizedBox(width: 10),
                  Text('Change applied! Your score has updated.', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.successText)),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Suggestions panel
          if (suggestions.isNotEmpty) ...[
            if (potentialScore > score) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.primaryLight, AppColors.primaryLight.withValues(alpha: 0.3)]),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: AppColors.primary, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Potential Score: $potentialScore', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary)),
                          Text('Apply all suggestions to reach $potentialScore — ${potentialScore - score} points higher.', style: const TextStyle(fontSize: 11, color: AppColors.primary, height: 1.4)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                      child: Text('$potentialScore', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            Text('Optional Improvements', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: scheme.onSurface)),
            const SizedBox(height: 4),
            Text('These changes are optional — apply any to boost your score.', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
            const SizedBox(height: 12),

            ...suggestions.asMap().entries.map((e) {
              final i = e.key;
              final s = e.value;
              final isTop = i == 0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _SuggestionCard(
                  suggestion: s,
                  currentScore: score,
                  isRecommended: isTop,
                  onApply: () => setState(() => _confirming = s),
                ),
              );
            }),
          ] else if (_applied.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.primary, size: 22),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('All improvements applied!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        Text('Your enrollment is fully optimized.', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Confirm modal (shown as overlay bottom sheet behavior via dialog)
          if (_confirming != null)
            _ConfirmOverlay(
              suggestion: _confirming!,
              currentScore: score,
              onCancel: () => setState(() => _confirming = null),
              onApply: () {
                _confirming!.apply(ref);
                setState(() {
                  _applied.add(_confirming!.id);
                  _confirming = null;
                  _showSuccess = true;
                });
                Future.delayed(const Duration(seconds: 3), () {
                  if (mounted) setState(() => _showSuccess = false);
                });
              },
            ),
        ],
      ),
    );
  }
}

class _FundingRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color dot;
  const _FundingRow({required this.label, required this.value, required this.color, required this.dot});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)))),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final _Suggestion suggestion;
  final int currentScore;
  final bool isRecommended;
  final VoidCallback onApply;

  const _SuggestionCard({required this.suggestion, required this.currentScore, required this.isRecommended, required this.onApply});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isRecommended ? AppColors.primaryLight : scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isRecommended ? AppColors.primary.withValues(alpha: 0.25) : scheme.outline.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRecommended) ...[
            Row(
              children: const [
                Icon(Icons.emoji_events, color: AppColors.primary, size: 12),
                SizedBox(width: 4),
                Text('RECOMMENDED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.5)),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: suggestion.iconColor.withValues(alpha: isRecommended ? 0.15 : 0.1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(suggestion.icon, color: suggestion.iconColor, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(suggestion.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: scheme.onSurface)),
                    const SizedBox(height: 2),
                    Text(suggestion.description, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant, height: 1.4)),
                    const SizedBox(height: 10),
                    // Stats row
                    Row(
                      children: [
                        _StatPill(label: 'Score', value: '$currentScore → ${suggestion.newScore}', color: AppColors.primary),
                        const SizedBox(width: 8),
                        _StatPill(label: 'Extra/yr', value: '+\$${suggestion.additionalAnnual.toString()}', color: AppColors.success),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onApply,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: scheme.outline.withValues(alpha: 0.5)),
              ),
              child: const Text('Apply Recommendation', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatPill({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.7))),
          Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

class _ConfirmOverlay extends StatelessWidget {
  final _Suggestion suggestion;
  final int currentScore;
  final VoidCallback onCancel;
  final VoidCallback onApply;

  const _ConfirmOverlay({required this.suggestion, required this.currentScore, required this.onCancel, required this.onApply});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onCancel,
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        // Uses a floating card overlay inside the scrollable body
        child: GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: scheme.outline.withValues(alpha: 0.3)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 24)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text('Confirm Change', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: scheme.onSurface))),
                    GestureDetector(onTap: onCancel, child: Icon(Icons.close, color: scheme.onSurfaceVariant, size: 20)),
                  ],
                ),
                Text('Review what will change before applying.', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                const SizedBox(height: 16),

                // What's changing
                Text('WHAT\'S CHANGING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: scheme.onSurfaceVariant, letterSpacing: 0.5)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _ChangeBox(label: suggestion.currentLabel, value: suggestion.currentValue, isNew: false)),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.arrow_forward, color: Color(0xFF9CA3AF), size: 16)),
                    Expanded(child: _ChangeBox(label: suggestion.newLabel, value: suggestion.newValue, isNew: true)),
                  ],
                ),
                const SizedBox(height: 16),

                // Impact
                Text('IMPACT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: scheme.onSurfaceVariant, letterSpacing: 0.5)),
                const SizedBox(height: 8),
                _ImpactRow(label: 'Readiness Score', value: '$currentScore → ${suggestion.newScore}', delta: '+${suggestion.scoreIncrease}'),
                const SizedBox(height: 6),
                _ImpactRow(label: 'Additional Annual Savings', value: '+\$${suggestion.additionalAnnual}'),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onCancel,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(child: Text('Cancel', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: scheme.onSurface))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: onApply,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryHover]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.bolt, color: Colors.white, size: 16),
                              SizedBox(width: 6),
                              Text('Apply Change', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChangeBox extends StatelessWidget {
  final String label;
  final String value;
  final bool isNew;
  const _ChangeBox({required this.label, required this.value, required this.isNew});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isNew ? AppColors.primaryLight : Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isNew ? AppColors.primary.withValues(alpha: 0.3) : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: isNew ? AppColors.primary : const Color(0xFF9CA3AF))),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: isNew ? AppColors.primary : const Color(0xFF374151))),
        ],
      ),
    );
  }
}

class _ImpactRow extends StatelessWidget {
  final String label;
  final String value;
  final String? delta;
  const _ImpactRow({required this.label, required this.value, this.delta});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant))),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: scheme.onSurface)),
          if (delta != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(6)),
              child: Row(
                children: [
                  const Icon(Icons.arrow_upward, size: 10, color: AppColors.primary),
                  Text(delta!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

extension _DoubleExt on double {
  String toFixed(int places) => toStringAsFixed(places);
}
