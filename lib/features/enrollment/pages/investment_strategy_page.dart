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

class _StrategyData {
  final RiskLevel level;
  final String title;
  final String description;
  final String returns;
  final String risk;
  final Color color;
  final List<_Alloc> allocations;
  final List<_Fund> funds;
  const _StrategyData({
    required this.level, required this.title, required this.description,
    required this.returns, required this.risk, required this.color,
    required this.allocations, required this.funds,
  });
}

const _strategies = [
  _StrategyData(
    level: RiskLevel.conservative, title: 'Conservative', description: 'Capital preservation with steady income. Best for those near retirement.', returns: '4–6% avg/yr', risk: 'Low', color: Color(0xFF0891B2),
    allocations: [_Alloc('Bonds', 45, Color(0xFF0891B2)), _Alloc('US Stocks', 25, Color(0xFF10B981)), _Alloc('International', 15, Color(0xFF8B5CF6)), _Alloc('Real Estate', 15, Color(0xFFF59E0B))],
    funds: [_Fund('Vanguard Total Bond Market', 'VBTLX', '0.05%'), _Fund('Vanguard Total Stock Market', 'VTSAX', '0.04%'), _Fund('International Growth Fund', 'VWIGX', '0.42%')],
  ),
  _StrategyData(
    level: RiskLevel.balanced, title: 'Balanced', description: 'Equal focus on growth and stability. Good for mid-career investors.', returns: '6–8% avg/yr', risk: 'Moderate', color: Color(0xFF2563EB),
    allocations: [_Alloc('US Stocks', 40, Color(0xFF10B981)), _Alloc('Bonds', 25, Color(0xFF0891B2)), _Alloc('International', 20, Color(0xFF8B5CF6)), _Alloc('Real Estate', 15, Color(0xFFF59E0B))],
    funds: [_Fund('Vanguard Total Stock Market', 'VTSAX', '0.04%'), _Fund('Vanguard Total Bond Market', 'VBTLX', '0.05%'), _Fund('Vanguard Mid-Cap Index', 'VIMAX', '0.05%')],
  ),
  _StrategyData(
    level: RiskLevel.growth, title: 'Growth', description: 'Aggressive equity focus for long-term wealth accumulation.', returns: '8–10% avg/yr', risk: 'High', color: Color(0xFF7C3AED),
    allocations: [_Alloc('US Stocks', 50, Color(0xFF10B981)), _Alloc('International', 20, Color(0xFF8B5CF6)), _Alloc('Bonds', 20, Color(0xFF0891B2)), _Alloc('Real Estate', 10, Color(0xFFF59E0B))],
    funds: [_Fund('Vanguard Total Stock Market', 'VTSAX', '0.04%'), _Fund('Vanguard Growth Index', 'VIGAX', '0.05%'), _Fund('International Growth Fund', 'VWIGX', '0.42%')],
  ),
  _StrategyData(
    level: RiskLevel.aggressive, title: 'Aggressive', description: 'Maximum growth potential. Best for long time horizons (20+ years).', returns: '10–12% avg/yr', risk: 'Very High', color: Color(0xFFDC2626),
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
  // 'default' = Plan Default confirmed, 'custom' = custom selected, null = not yet chosen
  String? _mode; // 'default' | 'custom'
  RiskLevel _riskLevel = RiskLevel.balanced;
  bool _showRiskEditor = false;
  bool _useCustomPortfolio = false;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(enrollmentProvider);
    if (draft.riskLevel != null) {
      _riskLevel = draft.riskLevel!;
      _mode = 'default';
    }
  }

  _StrategyData get _currentStrategy =>
      _strategies.firstWhere((s) => s.level == _riskLevel);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FlowScaffold(
      title: 'Investment Strategy',
      currentStep: 5,
      totalSteps: 8,
      primaryLabel: 'Continue',
      primaryEnabled: _mode != null,
      onPrimary: () {
        ref.read(enrollmentProvider.notifier).setInvestment(riskLevel: _riskLevel);
        context.go(AppRoutes.enrollmentReadiness);
      },
      onBack: () => context.go(AppRoutes.enrollmentAutoIncrease),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose Your Investment Strategy', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: scheme.onSurface)),
          const SizedBox(height: 4),
          Text('Select how your retirement savings will be invested.', style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant, height: 1.5)),
          const SizedBox(height: 20),

          // ── Investment Style Card (always shown) ──
          _InvestmentStyleCard(
            strategy: _currentStrategy,
            showEditor: _showRiskEditor,
            onToggleEditor: () => setState(() => _showRiskEditor = !_showRiskEditor),
            onSelectRisk: (level) => setState(() {
              _riskLevel = level;
              _showRiskEditor = false;
              _mode = null;
              _useCustomPortfolio = false;
            }),
          ),
          const SizedBox(height: 16),

          // ── Plan Default card ──
          _PlanDefaultCard(
            strategy: _currentStrategy,
            isSelected: _mode == 'default' && !_useCustomPortfolio,
            onSelect: () => setState(() {
              _mode = 'default';
              _useCustomPortfolio = false;
            }),
          ),
          const SizedBox(height: 12),

          // ── Customize Portfolio card ──
          _CustomizeCard(
            isSelected: _useCustomPortfolio,
            onSelect: () => setState(() {
              _mode = 'custom';
              _useCustomPortfolio = true;
            }),
          ),
          const SizedBox(height: 16),

          // ── Advisor Card ──
          _AdvisorCard(),
        ],
      ),
    );
  }
}

// ── Investment Style Card ────────────────────────────────────────────────────
class _InvestmentStyleCard extends StatelessWidget {
  final _StrategyData strategy;
  final bool showEditor;
  final VoidCallback onToggleEditor;
  final ValueChanged<RiskLevel> onSelectRisk;

  const _InvestmentStyleCard({
    required this.strategy, required this.showEditor,
    required this.onToggleEditor, required this.onSelectRisk,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.4)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.speed, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('INVESTMENT STYLE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: scheme.onSurfaceVariant, letterSpacing: 0.5)),
                    Text(strategy.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: scheme.onSurface)),
                    Text(strategy.description, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onToggleEditor,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.edit_outlined, size: 13, color: AppColors.primary),
                      const SizedBox(width: 4),
                      const Text('Edit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (showEditor) ...[
            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            const SizedBox(height: 14),
            Row(
              children: _strategies.map((s) {
                final isSelected = s.level == strategy.level;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onSelectRisk(s.level),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: EdgeInsets.only(right: s.level != RiskLevel.aggressive ? 6 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? s.color.withValues(alpha: 0.1) : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected ? Border.all(color: s.color.withValues(alpha: 0.5), width: 2) : null,
                      ),
                      child: Column(
                        children: [
                          Text(s.title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: isSelected ? s.color : const Color(0xFF374151)), textAlign: TextAlign.center),
                          const SizedBox(height: 2),
                          Text(s.risk, style: TextStyle(fontSize: 9, color: isSelected ? s.color : const Color(0xFF9CA3AF)), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Plan Default Card ────────────────────────────────────────────────────────
class _PlanDefaultCard extends StatelessWidget {
  final _StrategyData strategy;
  final bool isSelected;
  final VoidCallback onSelect;

  const _PlanDefaultCard({required this.strategy, required this.isSelected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.5) : scheme.outline.withValues(alpha: 0.4),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(6)),
                child: const Text('RECOMMENDED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.5)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: strategy.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(strategy.returns, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: strategy.color)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('Plan Default Investment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: scheme.onSurface)),
          const SizedBox(height: 2),
          Text('Managed by your plan administrator · optimized for your risk profile', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
          const SizedBox(height: 14),

          // Allocation bars
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: scheme.surfaceContainerLowest, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: strategy.allocations.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: a.color, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    SizedBox(width: 100, child: Text(a.label, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant))),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(value: a.pct / 100, minHeight: 5, backgroundColor: scheme.surfaceContainerHigh, valueColor: AlwaysStoppedAnimation(a.color)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${a.pct.toStringAsFixed(0)}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: a.color)),
                  ],
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Why box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Why this strategy?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                const SizedBox(height: 4),
                Text(
                  'This ${strategy.title.toLowerCase()} portfolio balances risk and reward based on typical investors at your career stage.',
                  style: const TextStyle(fontSize: 11, color: AppColors.primary, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // CTA
          GestureDetector(
            onTap: onSelect,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                gradient: isSelected ? null : const LinearGradient(colors: [AppColors.primary, AppColors.primaryHover]),
                color: isSelected ? AppColors.primary : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isSelected) ...[
                    const Icon(Icons.check_circle, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    const Text('Plan Default Selected', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                  ] else ...[
                    const Text('Select Plan Default', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Customize Portfolio Card ─────────────────────────────────────────────────
class _CustomizeCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onSelect;

  const _CustomizeCard({required this.isSelected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF5F3FF), Color(0xFFEFF6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFFDDD6FE),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF2563EB)]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.settings_outlined, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFEDE9FE), Color(0xFFDBEAFE)]),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFDDD6FE)),
                ),
                child: const Text('ADVANCED USER', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF7C3AED), letterSpacing: 0.5)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Build Your Own Portfolio', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1F2937))),
          const SizedBox(height: 4),
          const Text('Pick your own fund mix and allocation percentages. Full control over your investment strategy.', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280), height: 1.4)),
          const SizedBox(height: 6),
          const Text('Best for: investors who want specific funds, factor-based strategies, or ESG investing.', style: TextStyle(fontSize: 12, color: Color(0xFF374151), fontWeight: FontWeight.w500, height: 1.4)),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onSelect,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF7C3AED) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFF8B5CF6),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isSelected) ...[
                    const Icon(Icons.check, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    const Text('Custom Portfolio Selected', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                  ] else ...[
                    const Text('Build My Portfolio', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF7C3AED))),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward, color: Color(0xFF7C3AED), size: 16),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Advisor Card ─────────────────────────────────────────────────────────────
class _AdvisorCard extends StatelessWidget {
  const _AdvisorCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFBEB), Color(0xFFFFF7ED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFEA580C)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.phone_outlined, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('EXPERT HELP', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFFB45309), letterSpacing: 0.5)),
                const SizedBox(height: 4),
                const Text('Talk to an Advisor', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1F2937))),
                const SizedBox(height: 4),
                const Text('Not sure which strategy fits your goals? Our financial advisors provide personalized guidance.', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280), height: 1.4)),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    _CheckItem('Free consultation'),
                    SizedBox(width: 16),
                    _CheckItem('Personalized plan'),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFF59E0B), width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Connect Now', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFB45309))),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, color: Color(0xFFB45309), size: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String label;
  const _CheckItem(this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check, color: AppColors.success, size: 14),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF374151))),
      ],
    );
  }
}
