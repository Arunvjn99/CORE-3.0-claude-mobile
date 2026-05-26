import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../../../core/models/enrollment_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/flow_scaffold.dart';

class ContributionPage extends ConsumerStatefulWidget {
  const ContributionPage({super.key});

  @override
  ConsumerState<ContributionPage> createState() => _ContributionPageState();
}

class _ContributionPageState extends ConsumerState<ContributionPage> {
  double _rate = 6.0;
  ContributionType _type = ContributionType.percentage;

  static const double _salary = 75000;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(enrollmentProvider);
    _rate = draft.contributionRate ?? 6.0;
    _type = draft.contributionType;
  }

  double get _matchPercent => _rate >= 6 ? 3.0 : _rate >= 4 ? 2.0 : _rate >= 2 ? 1.0 : 0.0;

  double get _myMonthly => _type == ContributionType.percentage
      ? _salary / 12 * _rate / 100
      : _rate;

  double get _matchMonthly => _salary / 12 * _matchPercent / 100;

  double get _totalMonthly => _myMonthly + _matchMonthly;

  double get _projected30yr {
    double total = 0;
    final annual = _myMonthly * 12 + _matchMonthly * 12;
    for (int y = 0; y < 30; y++) {
      total = (total + annual) * 1.07;
    }
    return total;
  }

  void _adjust(double delta) {
    final min = _type == ContributionType.percentage ? 1.0 : 50.0;
    final max = _type == ContributionType.percentage ? 25.0 : 2000.0;
    setState(() => _rate = (_rate + delta).clamp(min, max));
  }

  String _fmt(double v) => v >= 1000
      ? '\$${(v / 1000).toStringAsFixed(0)}K'
      : '\$${v.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Set Contribution',
      currentStep: 2,
      totalSteps: 8,
      primaryLabel: 'Continue',
      primaryEnabled: true,
      onPrimary: () {
        ref.read(enrollmentProvider.notifier).setContribution(rate: _rate, type: _type);
        context.go(AppRoutes.enrollmentSource);
      },
      onBack: () => context.go(AppRoutes.enrollmentPlan),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How much would you like to contribute?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF111827)),
          ),
          const SizedBox(height: 4),
          const Text(
            'Your employer matches up to 6% of your salary.',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 20),

          // % / Fixed toggle
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                _TypeTab(label: 'Percentage %', selected: _type == ContributionType.percentage,
                    onTap: () => setState(() { _type = ContributionType.percentage; _rate = 6; })),
                _TypeTab(label: 'Fixed \$', selected: _type == ContributionType.fixed,
                    onTap: () => setState(() { _type = ContributionType.fixed; _rate = 375; })),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Big number + stepper
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StepBtn(icon: Icons.remove, onTap: () => _adjust(_type == ContributionType.percentage ? -1 : -50)),
                    const SizedBox(width: 24),
                    Column(
                      children: [
                        Text(
                          _type == ContributionType.percentage
                              ? '${_rate.toStringAsFixed(0)}%'
                              : '\$${_rate.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w800, color: AppColors.primary),
                        ),
                        Text(
                          _type == ContributionType.percentage
                              ? 'of each paycheck'
                              : 'per paycheck',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    _StepBtn(icon: Icons.add, onTap: () => _adjust(_type == ContributionType.percentage ? 1 : 50)),
                  ],
                ),
                const SizedBox(height: 20),

                // Quick presets (only for percentage)
                if (_type == ContributionType.percentage) ...[
                  const Text('Quick select', style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _QuickChip(label: '4%', onTap: () => setState(() => _rate = 4)),
                      _QuickChip(label: '6% ✅', onTap: () => setState(() => _rate = 6), highlight: true),
                      _QuickChip(label: '10%', onTap: () => setState(() => _rate = 10)),
                      _QuickChip(label: '15% 🚀', onTap: () => setState(() => _rate = 15)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Match progress bar
          if (_type == ContributionType.percentage) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Employer Match', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF111827))),
                      Text(
                        _rate >= 6 ? 'Full match unlocked! 🎉' : 'Add ${(6 - _rate).toStringAsFixed(0)}% more to unlock full match',
                        style: TextStyle(fontSize: 11, color: _rate >= 6 ? AppColors.success : AppColors.warning, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_rate / 6).clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: const Color(0xFFE5E7EB),
                      valueColor: AlwaysStoppedAnimation(
                        _rate >= 6 ? AppColors.success : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Monthly summary card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary.withValues(alpha: 0.07), AppColors.primary.withValues(alpha: 0.02)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
            ),
            child: Column(
              children: [
                _SummaryRow(label: 'Your monthly contribution', value: '\$${_myMonthly.toStringAsFixed(0)}', color: AppColors.primary),
                const SizedBox(height: 8),
                _SummaryRow(label: 'Employer match', value: '+\$${_matchMonthly.toStringAsFixed(0)}', color: AppColors.success),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: Color(0xFFE5E7EB)),
                ),
                _SummaryRow(label: 'Total monthly savings', value: '\$${_totalMonthly.toStringAsFixed(0)}', color: const Color(0xFF111827), bold: true),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Projected balance in 30 years', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                      Text(
                        _fmt(_projected30yr),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (_rate < 6 && _type == ContributionType.percentage) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: AppColors.warning, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Contribute at least 6% to maximize your employer match — that\'s free money!',
                      style: TextStyle(fontSize: 12, color: AppColors.warning, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool highlight;
  const _QuickChip({required this.label, required this.onTap, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: highlight ? AppColors.success.withValues(alpha: 0.1) : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
            border: highlight ? Border.all(color: AppColors.success.withValues(alpha: 0.4)) : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: highlight ? AppColors.success : const Color(0xFF374151),
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeTab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4)] : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? const Color(0xFF111827) : const Color(0xFF9CA3AF),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool bold;

  const _SummaryRow({required this.label, required this.value, required this.color, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: const Color(0xFF6B7280), fontWeight: bold ? FontWeight.w600 : FontWeight.w400)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}
