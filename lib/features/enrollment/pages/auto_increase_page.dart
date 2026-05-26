import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/flow_scaffold.dart';

class AutoIncreasePage extends ConsumerStatefulWidget {
  const AutoIncreasePage({super.key});
  @override
  ConsumerState<AutoIncreasePage> createState() => _AutoIncreasePageState();
}

class _AutoIncreasePageState extends ConsumerState<AutoIncreasePage> {
  bool _enabled = false;
  double _percent = 1.0;
  double _max = 15.0;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(enrollmentProvider);
    _enabled = draft.autoIncreaseEnabled;
    _percent = draft.autoIncreasePercent ?? 1.0;
    _max = draft.autoIncreaseMax ?? 15.0;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FlowScaffold(
      title: 'Auto Increase',
      currentStep: 4,
      totalSteps: 8,
      primaryLabel: 'Continue',
      onPrimary: () {
        ref.read(enrollmentProvider.notifier).setAutoIncrease(
          enabled: _enabled,
          percent: _enabled ? _percent : null,
          max: _enabled ? _max : null,
        );
        context.go(AppRoutes.enrollmentInvestment);
      },
      onBack: () => context.go(AppRoutes.enrollmentSource),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Auto Increase', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Automatically increase your contribution rate each year to grow your savings faster.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 24),

          // Toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: scheme.outline.withValues(alpha: 0.6)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.trending_up, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Enable Auto Increase', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      Text('Increase contribution annually', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Switch(value: _enabled, onChanged: (v) => setState(() => _enabled = v)),
              ],
            ),
          ),

          if (_enabled) ...[
            const SizedBox(height: 24),
            Text('Increase by', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '${_percent.toStringAsFixed(0)}% per year',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ),
            Slider(
              value: _percent,
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (v) => setState(() => _percent = v),
            ),
            const SizedBox(height: 20),
            Text('Up to a maximum of', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '${_max.toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.success),
              ),
            ),
            Slider(
              value: _max,
              min: 6,
              max: 25,
              divisions: 19,
              activeColor: AppColors.success,
              onChanged: (v) => setState(() => _max = v),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.successBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'With auto increase enabled, your contribution will grow from your current rate to ${_max.round()}% over time.',
                style: const TextStyle(fontSize: 12, color: AppColors.success, height: 1.4),
              ),
            ),
          ],

          if (!_enabled) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: AppColors.warning, size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Studies show participants who enable auto increase save significantly more by retirement.',
                      style: TextStyle(fontSize: 12, height: 1.4),
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
