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

  @override
  void initState() {
    super.initState();
    final draft = ref.read(enrollmentProvider);
    _rate = draft.contributionRate ?? 6.0;
    _type = draft.contributionType;
  }

  String get _employerMatch {
    if (_rate >= 6) return '3.00%';
    if (_rate >= 4) return '2.00%';
    if (_rate >= 2) return '1.00%';
    return '0%';
  }

  double get _estimatedMonthly => _type == ContributionType.percentage ? 75000 / 12 * _rate / 100 : _rate;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

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
          Text(
            'How much would you like to contribute?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Your employer offers matching up to 6%.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),

          // Type toggle
          Container(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                _TypeTab(
                  label: 'Percentage',
                  selected: _type == ContributionType.percentage,
                  onTap: () => setState(() => _type = ContributionType.percentage),
                ),
                _TypeTab(
                  label: 'Fixed Amount',
                  selected: _type == ContributionType.fixed,
                  onTap: () => setState(() => _type = ContributionType.fixed),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Rate display
          Center(
            child: Column(
              children: [
                Text(
                  _type == ContributionType.percentage
                      ? '${_rate.toStringAsFixed(0)}%'
                      : '\$${_rate.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
                Text(
                  'per ${_type == ContributionType.percentage ? 'paycheck' : 'month'}',
                  style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: _rate,
              min: _type == ContributionType.percentage ? 1 : 50,
              max: _type == ContributionType.percentage ? 20 : 2000,
              divisions: _type == ContributionType.percentage ? 19 : 39,
              label: _type == ContributionType.percentage ? '${_rate.round()}%' : '\$${_rate.round()}',
              onChanged: (v) => setState(() => _rate = v),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _type == ContributionType.percentage ? '1%' : '\$50',
                style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
              ),
              Text(
                _type == ContributionType.percentage ? '20%' : '\$2,000',
                style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Summary card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _SummaryRow(
                  label: 'Your contribution',
                  value: '\$${_estimatedMonthly.toStringAsFixed(0)}/mo',
                  color: AppColors.primary,
                ),
                const SizedBox(height: 8),
                _SummaryRow(
                  label: 'Employer match',
                  value: '+$_employerMatch/mo',
                  color: AppColors.success,
                ),
                const Divider(height: 16),
                _SummaryRow(
                  label: 'Total monthly',
                  value: '\$${(_estimatedMonthly + (75000 / 12 * double.parse(_employerMatch.replaceAll('%', '').replaceAll('/mo', '')) / 100)).toStringAsFixed(0)}/mo',
                  color: AppColors.primaryDark,
                  bold: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Recommendation
          if (_rate < 6) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warningBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: AppColors.warning, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Contribute at least 6% to maximize employer matching.',
                      style: const TextStyle(fontSize: 12, color: AppColors.warning, height: 1.4),
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
            color: selected ? Theme.of(context).colorScheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4)]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurfaceVariant,
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
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}
