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
  SourceType? _source;

  @override
  void initState() {
    super.initState();
    _source = ref.read(enrollmentProvider).source;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FlowScaffold(
      title: 'Contribution Source',
      currentStep: 3,
      totalSteps: 8,
      primaryLabel: 'Continue',
      primaryEnabled: _source != null,
      onPrimary: () {
        ref.read(enrollmentProvider.notifier).setSource(_source!);
        context.go(AppRoutes.enrollmentAutoIncrease);
      },
      onBack: () => context.go(AppRoutes.enrollmentContribution),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How would you like to contribute?', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Choose the source for your 401(k) contributions.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 28),
          _SourceOption(
            type: SourceType.pretax,
            title: 'Pre-Tax (Traditional)',
            subtitle: 'Contributions are deducted before taxes',
            icon: Icons.shield_outlined,
            color: AppColors.primary,
            isSelected: _source == SourceType.pretax,
            onTap: () => setState(() => _source = SourceType.pretax),
          ),
          const SizedBox(height: 12),
          _SourceOption(
            type: SourceType.roth,
            title: 'Roth (After-Tax)',
            subtitle: 'Contributions made with after-tax dollars',
            icon: Icons.savings_outlined,
            color: AppColors.success,
            isSelected: _source == SourceType.roth,
            onTap: () => setState(() => _source = SourceType.roth),
          ),
          const SizedBox(height: 12),
          _SourceOption(
            type: SourceType.split,
            title: 'Split (Both)',
            subtitle: 'Divide between pre-tax and Roth',
            icon: Icons.call_split_outlined,
            color: AppColors.chartPurple,
            isSelected: _source == SourceType.split,
            onTap: () => setState(() => _source = SourceType.split),
          ),
        ],
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final SourceType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _SourceOption({
    required this.type, required this.title, required this.subtitle,
    required this.icon, required this.color, required this.isSelected, required this.onTap,
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
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
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
