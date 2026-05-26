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
          const SizedBox(height: 24),

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
