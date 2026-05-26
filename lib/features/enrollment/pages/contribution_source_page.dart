import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../../../core/models/enrollment_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/flow_scaffold.dart';

class ContributionSourcePage extends ConsumerStatefulWidget {
  const ContributionSourcePage({super.key});
  @override
  ConsumerState<ContributionSourcePage> createState() => _ContributionSourcePageState();
}

class _ContributionSourcePageState extends ConsumerState<ContributionSourcePage> {
  bool _useDefault = true;
  double _preTax = 60;
  double _roth = 40;
  double _afterTax = 0;

  static const _defaultPreTax = 60.0;
  static const _defaultRoth = 40.0;
  static const _defaultAfterTax = 0.0;

  double get _total => _preTax + _roth + _afterTax;
  bool get _valid => (_total - 100).abs() < 0.5;

  SourceType get _resolvedSource {
    if (_useDefault) return SourceType.pretax;
    if (_roth == 0 && _afterTax == 0) return SourceType.pretax;
    if (_preTax == 0 && _afterTax == 0) return SourceType.roth;
    return SourceType.split;
  }

  @override
  void initState() {
    super.initState();
    final draft = ref.read(enrollmentProvider);
    if (draft.source == SourceType.roth) {
      _useDefault = false;
      _preTax = 0;
      _roth = 100;
      _afterTax = 0;
    } else if (draft.source == SourceType.split) {
      _useDefault = false;
    }
  }

  void _onPreTaxChanged(double v) {
    final remaining = 100 - v;
    setState(() {
      _preTax = v;
      if (_afterTax > remaining) _afterTax = remaining;
      _roth = (remaining - _afterTax).clamp(0, 100);
    });
  }

  void _onRothChanged(double v) {
    final remaining = 100 - v;
    setState(() {
      _roth = v;
      if (_afterTax > remaining) _afterTax = remaining;
      _preTax = (remaining - _afterTax).clamp(0, 100);
    });
  }

  void _onAfterTaxChanged(double v) {
    final remaining = 100 - v;
    setState(() {
      _afterTax = v;
      if (_roth > remaining) _roth = remaining;
      _preTax = (remaining - _roth).clamp(0, 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FlowScaffold(
      title: 'Contribution Source',
      currentStep: 3,
      totalSteps: 8,
      primaryLabel: 'Continue',
      primaryEnabled: _useDefault || _valid,
      onPrimary: () {
        ref.read(enrollmentProvider.notifier).setSource(_resolvedSource);
        context.go(AppRoutes.enrollmentAutoIncrease);
      },
      onBack: () => context.go(AppRoutes.enrollmentContribution),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('How would you like to contribute?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
          const SizedBox(height: 4),
          const Text('Choose between your plan\'s default allocation or customize your own split.', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.5)),
          const SizedBox(height: 20),

          // Plan Default vs Custom toggle
          Container(
            decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                _TabBtn(label: 'Plan Default', selected: _useDefault, onTap: () => setState(() { _useDefault = true; _preTax = _defaultPreTax; _roth = _defaultRoth; _afterTax = _defaultAfterTax; })),
                _TabBtn(label: 'Customize', selected: !_useDefault, onTap: () => setState(() => _useDefault = false)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (_useDefault) ...[
            // Plan default info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.verified_outlined, color: AppColors.primary, size: 18),
                      SizedBox(width: 8),
                      Text('Plan Default Allocation', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _AllocRow(label: 'Pre-Tax (Traditional)', pct: _defaultPreTax, color: AppColors.primary),
                  const SizedBox(height: 8),
                  _AllocRow(label: 'Roth (After-Tax)', pct: _defaultRoth, color: AppColors.success),
                  const SizedBox(height: 8),
                  _AllocRow(label: 'After-Tax', pct: _defaultAfterTax, color: const Color(0xFF9CA3AF)),
                  const SizedBox(height: 12),
                  const Text('This is the allocation recommended by your plan administrator.', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280), height: 1.4)),
                ],
              ),
            ),
          ] else ...[
            // Custom sliders
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Custom Allocation', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _valid ? AppColors.successBg : const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          'Total: ${_total.toStringAsFixed(0)}%',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _valid ? AppColors.success : const Color(0xFFDC2626)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _SourceSlider(
                    label: 'Pre-Tax (Traditional)',
                    icon: Icons.shield_outlined,
                    color: AppColors.primary,
                    value: _preTax,
                    onChanged: _onPreTaxChanged,
                    description: 'Taxed at withdrawal, reduces taxable income now.',
                  ),
                  const SizedBox(height: 16),
                  _SourceSlider(
                    label: 'Roth (After-Tax)',
                    icon: Icons.savings_outlined,
                    color: AppColors.success,
                    value: _roth,
                    onChanged: _onRothChanged,
                    description: 'Tax-free at retirement. Pay taxes now.',
                  ),
                  const SizedBox(height: 16),
                  _SourceSlider(
                    label: 'After-Tax',
                    icon: Icons.account_balance_wallet_outlined,
                    color: const Color(0xFF7C3AED),
                    value: _afterTax,
                    onChanged: _onAfterTaxChanged,
                    description: 'Additional after-tax contributions.',
                  ),
                ],
              ),
            ),
            if (!_valid) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFDC2626).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Allocations must total exactly 100%. Currently ${_total.toStringAsFixed(0)}%.',
                        style: const TextStyle(fontSize: 12, color: Color(0xFFDC2626), height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],

          const SizedBox(height: 20),

          // Educational cards
          _InfoCard(
            icon: Icons.shield_outlined,
            color: AppColors.primary,
            title: 'Pre-Tax (Traditional)',
            body: 'Contributions reduce your taxable income today. You\'ll pay taxes when you withdraw in retirement.',
          ),
          const SizedBox(height: 10),
          _InfoCard(
            icon: Icons.savings_outlined,
            color: AppColors.success,
            title: 'Roth (After-Tax)',
            body: 'You pay taxes now but withdrawals in retirement are completely tax-free — including growth.',
          ),
        ],
      ),
    );
  }
}

class _AllocRow extends StatelessWidget {
  final String label;
  final double pct;
  final Color color;
  const _AllocRow({required this.label, required this.pct, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 150, child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF374151)))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: pct / 100,
              minHeight: 6,
              backgroundColor: const Color(0xFFF3F4F6),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('${pct.toStringAsFixed(0)}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}

class _SourceSlider extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final double value;
  final ValueChanged<double> onChanged;
  final String description;

  const _SourceSlider({required this.label, required this.icon, required this.color, required this.value, required this.onChanged, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(7)),
              child: Icon(icon, color: color, size: 14),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF111827)))),
            Text('${value.toStringAsFixed(0)}%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: color.withValues(alpha: 0.15),
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.15),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: onChanged,
          ),
        ),
        Text(description, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF), height: 1.4)),
      ],
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabBtn({required this.label, required this.selected, required this.onTap});

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

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  const _InfoCard({required this.icon, required this.color, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
                const SizedBox(height: 3),
                Text(body, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280), height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
