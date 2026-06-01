import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../../../core/models/enrollment_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/flow_scaffold.dart';

class PlanSelectionPage extends ConsumerStatefulWidget {
  const PlanSelectionPage({super.key});

  @override
  ConsumerState<PlanSelectionPage> createState() => _PlanSelectionPageState();
}

class _PlanSelectionPageState extends ConsumerState<PlanSelectionPage> {
  PlanType? _selected;

  @override
  void initState() {
    super.initState();
    _selected = ref.read(enrollmentProvider).plan;
  }

  void _showAiSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(width: 36, height: 36, decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary, Color(0xFF7C3AED)]), shape: BoxShape.circle), child: const Icon(Icons.psychology, color: Colors.white, size: 18)),
              const SizedBox(width: 12),
              const Text('Ask Core AI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 16),
            const Text('Traditional 401(k) vs Roth 401(k)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
            const SizedBox(height: 8),
            const Text('Choose Traditional if you expect to be in a lower tax bracket at retirement — your contributions reduce taxes today.\n\nChoose Roth if you expect higher taxes later — you pay taxes now, but all growth and withdrawals are tax-free.\n\nMost participants under 40 benefit from Roth. Near retirement? Traditional often wins.', style: TextStyle(fontSize: 13, color: Color(0xFF374151), height: 1.6)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showCompareSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Plan Comparison', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            _CompareRow(feature: 'Tax Treatment', traditional: 'Pre-tax (reduce now)', roth: 'After-tax (tax-free later)'),
            _CompareRow(feature: 'Withdrawals', traditional: 'Taxed at retirement', roth: 'Tax-free if qualified'),
            _CompareRow(feature: 'RMDs at 73', traditional: 'Required', roth: 'Not required'),
            _CompareRow(feature: 'Best for', traditional: 'Higher tax bracket now', roth: 'Lower tax bracket now'),
            _CompareRow(feature: 'Employer Match', traditional: 'Yes', roth: 'Yes'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Choose Your Plan',
      currentStep: 1,
      totalSteps: 8,
      primaryLabel: 'Continue',
      primaryEnabled: _selected != null,
      showBack: false,
      onPrimary: () {
        ref.read(enrollmentProvider.notifier).setPlan(_selected!);
        context.go(AppRoutes.enrollmentContribution);
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select your retirement plan type',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Your employer offers these 401(k) options. Both offer tax advantages and employer matching.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 28),

          _PlanCard(
            type: PlanType.traditional,
            isSelected: _selected == PlanType.traditional,
            onTap: () => setState(() => _selected = PlanType.traditional),
          ),
          const SizedBox(height: 12),
          _PlanCard(
            type: PlanType.roth,
            isSelected: _selected == PlanType.roth,
            onTap: () => setState(() => _selected = PlanType.roth),
          ),
          const SizedBox(height: 20),

          // Ask AI + Compare Plans bar (matches desktop)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Not sure which plan is right for you?',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF111827)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Our AI assistant can help explain the differences.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showAiSheet(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.psychology_outlined, color: Colors.white, size: 16),
                              SizedBox(width: 6),
                              Text('Ask AI', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showCompareSheet(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.compare_arrows, color: AppColors.primary, size: 16),
                              SizedBox(width: 6),
                              Text('Compare Plans', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
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

          const SizedBox(height: 16),

          // Info box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.infoBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: AppColors.info, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Not sure which to choose? Consider your current tax bracket and expected tax situation at retirement.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.info,
                      height: 1.4,
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

class _PlanCard extends StatelessWidget {
  final PlanType type;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({required this.type, required this.isSelected, required this.onTap});

  bool get isTraditional => type == PlanType.traditional;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = isTraditional ? AppColors.primary : AppColors.success;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.07) : scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : scheme.outline.withValues(alpha: 0.6),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isTraditional) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
                ),
                child: const Text('Most Common Choice', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFD97706))),
              ),
            ],
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isTraditional ? Icons.account_balance : Icons.show_chart,
                    color: color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isTraditional ? 'Traditional 401(k)' : 'Roth 401(k)',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      Text(
                        isTraditional ? 'Pre-tax contributions' : 'After-tax contributions',
                        style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    child: const Icon(Icons.check, color: Colors.white, size: 14),
                  )
                else
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: scheme.outline),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 14),

            // Feature list
            ..._features.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, size: 14, color: color),
                  const SizedBox(width: 8),
                  Text(f, style: const TextStyle(fontSize: 12)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  List<String> get _features => isTraditional
      ? ['Reduce taxable income now', 'Pay taxes at withdrawal', 'Required distributions at 73']
      : ['No tax on qualified withdrawals', 'No required minimum distributions', 'Tax-free growth potential'];
}

class _CompareRow extends StatelessWidget {
  final String feature;
  final String traditional;
  final String roth;
  const _CompareRow({required this.feature, required this.traditional, required this.roth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(feature, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF))),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(8)), child: Text(traditional, style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)))),
              const SizedBox(width: 8),
              Expanded(child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(8)), child: Text(roth, style: const TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w500)))),
            ],
          ),
        ],
      ),
    );
  }
}
