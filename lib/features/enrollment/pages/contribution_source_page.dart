import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../widgets/enrollment_scaffold.dart';

/// Tax Source page — Step 3 of 7, 42% Complete
/// Matches Figma "Source" frame (2239:4840)
class ContributionSourcePage extends StatefulWidget {
  const ContributionSourcePage({super.key});

  @override
  State<ContributionSourcePage> createState() => _ContributionSourcePageState();
}

class _ContributionSourcePageState extends State<ContributionSourcePage> {
  bool _useCustom = false;
  double _preTaxPct = 100.0;
  bool _preTaxExpanded = false;
  bool _rothExpanded = false;

  double get _rothPct => 100.0 - _preTaxPct;
  int get _taxOptScore => (_preTaxPct >= 80) ? 94 : (_preTaxPct >= 50 ? 78 : 62);

  @override
  Widget build(BuildContext context) {
    return EnrollmentScaffold(
      stepName: 'Tax Source',
      stepNumber: 3,
      totalSteps: 7,
      bottomButton: EnrollmentButton(
        label: 'Continue to Auto Increase',
        onTap: () => context.push(AppRoutes.enrollmentAutoIncrease),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EnrollmentHeading(
            title: 'How Do You Want To Pay Taxes?',
            subtitle: 'Distribute your 10% contribution across different tax sources to optimize your future income.',
          ),
          const SizedBox(height: 24),
          // Tab switcher
          Container(
            height: 44,
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(4),
            child: Row(children: [
              _TabButton(label: 'Plan Default', selected: !_useCustom, onTap: () => setState(() => _useCustom = false)),
              _TabButton(label: 'Custom Allocation', selected: _useCustom, onTap: () => setState(() => _useCustom = true)),
            ]),
          ),
          const SizedBox(height: 20),
          // Pre-Tax / Roth sliders
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Column(children: [
              Row(children: [
                Container(width: 36, height: 36, decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.account_balance_outlined, size: 18, color: Color(0xFF2563EB))),
                const SizedBox(width: 12),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Pre-Tax', style: TextStyle(fontFamily: 'Lato', fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                  Text('Pay taxes when you withdraw', style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF64748B))),
                ])),
                Text('${_preTaxPct.round()}%', style: const TextStyle(fontFamily: 'Lato', fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
              ]),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(activeTrackColor: const Color(0xFF2563EB), inactiveTrackColor: const Color(0xFFE2E8F0), thumbColor: const Color(0xFF2563EB), trackHeight: 4, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12)),
                child: Slider(value: _preTaxPct, min: 0, max: 100, onChanged: _useCustom ? (v) => setState(() => _preTaxPct = v) : null),
              ),
              const Divider(height: 16, color: Color(0xFFE2E8F0)),
              Row(children: [
                Container(width: 36, height: 36, decoration: BoxDecoration(color: const Color(0xFFF5F3FF), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.wb_sunny_outlined, size: 18, color: Color(0xFF7C3AED))),
                const SizedBox(width: 12),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Roth', style: TextStyle(fontFamily: 'Lato', fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                  Text('Pay taxes now, withdraw tax-free', style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF64748B))),
                ])),
                Text('${_rothPct.round()}%', style: const TextStyle(fontFamily: 'Lato', fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
              ]),
            ]),
          ),
          const SizedBox(height: 16),
          // Tax Optimization Score
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFBBF7D0))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.auto_awesome_outlined, size: 18, color: Color(0xFF059669)),
                const SizedBox(width: 8),
                const Expanded(child: Text('Tax Optimization Score', style: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)))),
                Text('$_taxOptScore/100', style: const TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF059669))),
              ]),
              const SizedBox(height: 8),
              const Text('Your current 100% Pre-Tax allocation is optimal for your current tax bracket (\$85k–\$120k). It maximizes your take-home pay today while your employer match (6%) also grows tax-deferred.', style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF64748B), height: 1.5)),
              const SizedBox(height: 10),
              const Row(children: [
                Text('WHY RECOMMENDED', style: TextStyle(fontFamily: 'Lato', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF059669), letterSpacing: 0.3)),
                SizedBox(width: 12),
                Text('TAX SAVINGS: \$2,400/YR', style: TextStyle(fontFamily: 'Lato', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF059669), letterSpacing: 0.3)),
              ]),
            ]),
          ),
          const SizedBox(height: 16),
          const Text('Understanding Tax Strategies', style: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
          const SizedBox(height: 12),
          _AccordionTile(title: 'Pre-Tax Benefits', expanded: _preTaxExpanded, onTap: () => setState(() => _preTaxExpanded = !_preTaxExpanded), content: 'Pre-tax contributions reduce your taxable income today. You pay taxes when you withdraw in retirement, potentially at a lower rate.'),
          const SizedBox(height: 8),
          _AccordionTile(title: 'Roth Considerations', expanded: _rothExpanded, onTap: () => setState(() => _rothExpanded = !_rothExpanded), content: 'Roth contributions are made with after-tax dollars, meaning your withdrawals in retirement are completely tax-free, including all the growth.'),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({required this.label, required this.selected, required this.onTap});
  final String label; final bool selected; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Expanded(child: GestureDetector(onTap: onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 150), height: double.infinity, decoration: BoxDecoration(color: selected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(8), boxShadow: selected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4, offset: const Offset(0, 2))] : []), alignment: Alignment.center, child: Text(label, style: TextStyle(fontFamily: 'Lato', fontSize: 13, fontWeight: selected ? FontWeight.w600 : FontWeight.w400, color: selected ? const Color(0xFF0F172A) : const Color(0xFF64748B))))));
}

class _AccordionTile extends StatelessWidget {
  const _AccordionTile({required this.title, required this.expanded, required this.onTap, required this.content});
  final String title; final bool expanded; final VoidCallback onTap; final String content;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
    child: Column(children: [
      GestureDetector(onTap: onTap, child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
        const Icon(Icons.info_outline, size: 18, color: Color(0xFF64748B)),
        const SizedBox(width: 10),
        Expanded(child: Text(title, style: const TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF0F172A)))),
        Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: const Color(0xFF64748B)),
      ]))),
      if (expanded) Padding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 14), child: Text(content, style: const TextStyle(fontFamily: 'Lato', fontSize: 13, color: Color(0xFF64748B), height: 1.5))),
    ]),
  );
}
