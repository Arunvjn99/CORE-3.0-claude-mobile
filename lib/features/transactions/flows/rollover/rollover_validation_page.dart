import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class RolloverValidationPage extends StatefulWidget {
  const RolloverValidationPage({super.key});

  @override
  State<RolloverValidationPage> createState() => _RolloverValidationPageState();
}

class _RolloverValidationPageState extends State<RolloverValidationPage> {
  bool _isValidating = false;
  bool _validated = false;

  Future<void> _validate() async {
    setState(() => _isValidating = true);
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;
    setState(() { _isValidating = false; _validated = true; });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final checks = [
      ('Plan is eligible for rollover', _validated, 'Traditional 401(k) plans are eligible'),
      ('No outstanding loans', _validated, 'No active loans detected on this plan'),
      ('Vesting requirement met', _validated, '100% vested balance confirmed'),
      ('Plan accepts incoming rollovers', _validated, 'Your current plan accepts rollovers'),
    ];

    return FlowScaffold(
      title: 'Validation',
      currentStep: 2,
      totalSteps: 5,
      primaryLabel: 'Set Allocation',
      primaryEnabled: _validated,
      onPrimary: () => context.go(AppRoutes.rolloverAllocation),
      onBack: () => context.go(AppRoutes.rollover),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Plan Validation',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('We\'ll verify your external plan details before processing the rollover.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),

          // External plan summary
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('External Plan Summary',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                _SummaryRow(label: 'Plan Name', value: 'Acme Corporation 401(k)'),
                const SizedBox(height: 8),
                _SummaryRow(label: 'Account Type', value: 'Traditional 401(k)'),
                const SizedBox(height: 8),
                _SummaryRow(label: 'Rollover Type', value: 'Direct Rollover'),
                const SizedBox(height: 8),
                _SummaryRow(label: 'Estimated Amount', value: '\$45,000'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Validation checks
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Eligibility Checks',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const Spacer(),
                    if (!_validated && !_isValidating)
                      ElevatedButton.icon(
                        onPressed: _validate,
                        icon: const Icon(Icons.verified, size: 16),
                        label: const Text('Validate', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    if (_isValidating)
                      const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                ...checks.map((check) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          color: check.$2
                              ? AppColors.successBg
                              : _isValidating
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : scheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: _isValidating
                              ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2))
                              : Icon(
                                  check.$2 ? Icons.check : Icons.radio_button_unchecked,
                                  size: 16,
                                  color: check.$2 ? AppColors.success : scheme.onSurfaceVariant,
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(check.$1,
                                style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600,
                                  color: check.$2 ? scheme.onSurface : scheme.onSurfaceVariant,
                                )),
                            Text(check.$3,
                                style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          if (_validated) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.successBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.verified, color: AppColors.success, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your plan has been validated and is eligible for rollover. You may proceed to set up your allocation.',
                      style: TextStyle(fontSize: 12, color: AppColors.success, height: 1.4),
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

class _SummaryRow extends StatelessWidget {
  final String label, value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: Text(label, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant))),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
