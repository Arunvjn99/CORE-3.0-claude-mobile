import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../../../core/models/enrollment_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/flow_scaffold.dart';

class InvestmentStrategyPage extends ConsumerStatefulWidget {
  const InvestmentStrategyPage({super.key});
  @override
  ConsumerState<InvestmentStrategyPage> createState() => _InvestmentStrategyPageState();
}

class _InvestmentStrategyPageState extends ConsumerState<InvestmentStrategyPage> {
  RiskLevel? _selected;

  @override
  void initState() {
    super.initState();
    _selected = ref.read(enrollmentProvider).riskLevel;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FlowScaffold(
      title: 'Investment Strategy',
      currentStep: 5,
      totalSteps: 8,
      primaryLabel: 'Continue',
      primaryEnabled: _selected != null,
      onPrimary: () {
        ref.read(enrollmentProvider.notifier).setInvestment(riskLevel: _selected!);
        context.go(AppRoutes.enrollmentReadiness);
      },
      onBack: () => context.go(AppRoutes.enrollmentAutoIncrease),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose Your Risk Level', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Select an investment strategy that aligns with your risk tolerance and retirement timeline.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 24),
          ..._options.map((opt) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _RiskOption(
              level: opt.$1,
              title: opt.$2,
              subtitle: opt.$3,
              color: opt.$4,
              allocation: opt.$5,
              isSelected: _selected == opt.$1,
              onTap: () => setState(() => _selected = opt.$1),
            ),
          )),
        ],
      ),
    );
  }

  final _options = [
    (RiskLevel.conservative, 'Conservative', 'Lower risk, steady growth', AppColors.chartGreen, '20/80'),
    (RiskLevel.balanced, 'Balanced', 'Moderate risk and growth', AppColors.chartBlue, '60/40'),
    (RiskLevel.growth, 'Growth', 'Higher risk, higher potential', AppColors.chartOrange, '80/20'),
    (RiskLevel.aggressive, 'Aggressive', 'Maximum growth potential', AppColors.danger, '95/5'),
  ];
}

class _RiskOption extends StatelessWidget {
  final RiskLevel level;
  final String title;
  final String subtitle;
  final Color color;
  final String allocation;
  final bool isSelected;
  final VoidCallback onTap;

  const _RiskOption({
    required this.level, required this.title, required this.subtitle,
    required this.color, required this.allocation, required this.isSelected, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.07) : scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? color : scheme.outline.withValues(alpha: 0.6), width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(allocation, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  Text('Stocks/Bonds ratio', style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            if (isSelected)
              Container(width: 22, height: 22, decoration: BoxDecoration(color: color, shape: BoxShape.circle), child: const Icon(Icons.check, color: Colors.white, size: 13))
            else
              Container(width: 22, height: 22, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: scheme.outline))),
          ],
        ),
      ),
    );
  }
}
