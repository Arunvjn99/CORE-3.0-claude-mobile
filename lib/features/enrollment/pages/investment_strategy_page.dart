import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../../../core/models/enrollment_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/flow_scaffold.dart';

class _Fund {
  final String name;
  final String ticker;
  final String expense;
  const _Fund(this.name, this.ticker, this.expense);
}

class _Alloc {
  final String label;
  final double pct;
  final Color color;
  const _Alloc(this.label, this.pct, this.color);
}

class _Strategy {
  final RiskLevel level;
  final String title;
  final String description;
  final String returns;
  final String risk;
  final Color color;
  final Color bg;
  final List<_Alloc> allocations;
  final List<_Fund> funds;
  const _Strategy({required this.level, required this.title, required this.description, required this.returns, required this.risk, required this.color, required this.bg, required this.allocations, required this.funds});
}

const _strategies = [
  _Strategy(
    level: RiskLevel.conservative, title: 'Conservative', description: 'Capital preservation with steady income. Best for those near retirement.', returns: '4–6% avg/yr', risk: 'Low', color: Color(0xFF0891B2), bg: Color(0xFFECFEFF),
    allocations: [_Alloc('Bonds', 45, Color(0xFF0891B2)), _Alloc('US Stocks', 25, Color(0xFF10B981)), _Alloc('International', 15, Color(0xFF8B5CF6)), _Alloc('Real Estate', 15, Color(0xFFF59E0B))],
    funds: [_Fund('Vanguard Total Bond Market', 'VBTLX', '0.05%'), _Fund('Vanguard Total Stock Market', 'VTSAX', '0.04%'), _Fund('International Growth Fund', 'VWIGX', '0.42%')],
  ),
  _Strategy(
    level: RiskLevel.balanced, title: 'Balanced', description: 'Equal focus on growth and stability. Good for mid-career investors.', returns: '6–8% avg/yr', risk: 'Moderate', color: Color(0xFF2563EB), bg: Color(0xFFEFF6FF),
    allocations: [_Alloc('US Stocks', 40, Color(0xFF10B981)), _Alloc('Bonds', 25, Color(0xFF0891B2)), _Alloc('International', 20, Color(0xFF8B5CF6)), _Alloc('Real Estate', 15, Color(0xFFF59E0B))],
    funds: [_Fund('Vanguard Total Stock Market', 'VTSAX', '0.04%'), _Fund('Vanguard Total Bond Market', 'VBTLX', '0.05%'), _Fund('Vanguard Mid-Cap Index', 'VIMAX', '0.05%')],
  ),
  _Strategy(
    level: RiskLevel.growth, title: 'Growth', description: 'Aggressive equity focus for long-term wealth accumulation.', returns: '8–10% avg/yr', risk: 'High', color: Color(0xFF7C3AED), bg: Color(0xFFF5F3FF),
    allocations: [_Alloc('US Stocks', 50, Color(0xFF10B981)), _Alloc('International', 20, Color(0xFF8B5CF6)), _Alloc('Bonds', 20, Color(0xFF0891B2)), _Alloc('Real Estate', 10, Color(0xFFF59E0B))],
    funds: [_Fund('Vanguard Total Stock Market', 'VTSAX', '0.04%'), _Fund('Vanguard Growth Index', 'VIGAX', '0.05%'), _Fund('International Growth Fund', 'VWIGX', '0.42%')],
  ),
  _Strategy(
    level: RiskLevel.aggressive, title: 'Aggressive', description: 'Maximum growth potential. Best for long time horizons (20+ years).', returns: '10–12% avg/yr', risk: 'Very High', color: Color(0xFFDC2626), bg: Color(0xFFFEF2F2),
    allocations: [_Alloc('US Stocks', 50, Color(0xFF10B981)), _Alloc('International', 30, Color(0xFF8B5CF6)), _Alloc('Bonds', 10, Color(0xFF0891B2)), _Alloc('Real Estate', 10, Color(0xFFF59E0B))],
    funds: [_Fund('Vanguard Total Stock Market', 'VTSAX', '0.04%'), _Fund('Vanguard Small-Cap Growth', 'VSGAX', '0.07%'), _Fund('Vanguard Emerging Markets', 'VEMAX', '0.14%')],
  ),
];

class InvestmentStrategyPage extends ConsumerStatefulWidget {
  const InvestmentStrategyPage({super.key});
  @override
  ConsumerState<InvestmentStrategyPage> createState() => _InvestmentStrategyPageState();
}

class _InvestmentStrategyPageState extends ConsumerState<InvestmentStrategyPage> {
  RiskLevel? _selected;
  int? _expanded;

  @override
  void initState() {
    super.initState();
    _selected = ref.read(enrollmentProvider).riskLevel;
  }

  @override
  Widget build(BuildContext context) {
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
          const Text('Choose Your Investment Strategy', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
          const SizedBox(height: 4),
          const Text('Select a strategy that matches your risk tolerance and time to retirement.', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.5)),
          const SizedBox(height: 20),
          ..._strategies.asMap().entries.map((e) {
            final i = e.key;
            final s = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _StrategyCard(
                strategy: s,
                isSelected: _selected == s.level,
                isExpanded: _expanded == i,
                onTap: () => setState(() {
                  _selected = s.level;
                  _expanded = _expanded == i ? null : i;
                }),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StrategyCard extends StatelessWidget {
  final _Strategy strategy;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback onTap;

  const _StrategyCard({required this.strategy, required this.isSelected, required this.isExpanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? strategy.color.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? strategy.color : const Color(0xFFE5E7EB), width: isSelected ? 2 : 1),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(color: strategy.bg, borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Text(strategy.title[0], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: strategy.color))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(strategy.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(color: strategy.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100)),
                              child: Text(strategy.risk, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: strategy.color)),
                            ),
                          ],
                        ),
                        Text(strategy.returns, style: TextStyle(fontSize: 12, color: strategy.color, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle, color: strategy.color, size: 20)
                  else
                    Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: const Color(0xFF9CA3AF), size: 20),
                ],
              ),
            ),
            if (isSelected || isExpanded) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(strategy.description, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), height: 1.4)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Allocation', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                    const SizedBox(height: 8),
                    ...strategy.allocations.map((a) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          SizedBox(width: 90, child: Text(a.label, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)))),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(value: a.pct / 100, minHeight: 6, backgroundColor: const Color(0xFFF3F4F6), valueColor: AlwaysStoppedAnimation(a.color)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${a.pct.toStringAsFixed(0)}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: a.color)),
                        ],
                      ),
                    )),
                    const SizedBox(height: 10),
                    const Text('Sample Funds', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                    const SizedBox(height: 8),
                    ...strategy.funds.map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: strategy.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                            child: Text(f.ticker, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: strategy.color)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(f.name, style: const TextStyle(fontSize: 11, color: Color(0xFF374151)), overflow: TextOverflow.ellipsis)),
                          Text(f.expense, style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF))),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}
