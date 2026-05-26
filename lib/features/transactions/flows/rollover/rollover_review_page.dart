import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class RolloverReviewPage extends StatefulWidget {
  const RolloverReviewPage({super.key});

  @override
  State<RolloverReviewPage> createState() => _RolloverReviewPageState();
}

class _RolloverReviewPageState extends State<RolloverReviewPage> {
  bool _agreed = false;
  bool _isLoading = false;
  bool _submitted = false;

  void _submit() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() { _isLoading = false; _submitted = true; });
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;
    context.go(AppRoutes.transactions);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (_submitted) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(color: AppColors.successBg, shape: BoxShape.circle,
                      border: Border.all(color: AppColors.success.withValues(alpha: 0.3))),
                  child: const Icon(Icons.check_circle_outline, color: AppColors.success, size: 32),
                ),
                const SizedBox(height: 20),
                Text('Rollover Submitted',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text('Your rollover request has been submitted. Processing takes 5-10 business days after document verification.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                const SizedBox(height: 16),
                Text('Redirecting...', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
        ),
      );
    }

    return FlowScaffold(
      title: 'Review & Submit',
      currentStep: 5,
      totalSteps: 5,
      primaryLabel: 'Submit Rollover',
      primaryEnabled: _agreed,
      isLoading: _isLoading,
      onPrimary: _submit,
      onBack: () => context.go(AppRoutes.rolloverDocuments),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review and Submit',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Review your rollover details before final submission.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),

          // Rollover details
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.replay, color: AppColors.info, size: 16),
                  const SizedBox(width: 6),
                  Text('Rollover Details', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 12),
                _DetailRow(label: 'From Plan', value: 'Acme Corporation 401(k)'),
                const SizedBox(height: 8),
                _DetailRow(label: 'Rollover Type', value: 'Direct Rollover'),
                const SizedBox(height: 8),
                _DetailRow(label: 'Account Type', value: 'Traditional 401(k)'),
                const SizedBox(height: 8),
                _DetailRow(label: 'Rollover Amount', value: '\$45,000'),
                const SizedBox(height: 8),
                _DetailRow(label: 'Tax Withholding', value: 'None (Direct)'),
                const SizedBox(height: 8),
                _DetailRow(label: 'Estimated Processing', value: '5-10 business days'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Allocation
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Investment Allocation',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                ...[
                  ('Large Cap Equity Fund', 40.0, AppColors.primary),
                  ('International Growth Fund', 25.0, AppColors.chartPurple),
                  ('Stable Value Bond Fund', 20.0, AppColors.success),
                  ('Target Date 2050 Fund', 15.0, AppColors.chartOrange),
                ].map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(width: 8, height: 8, decoration: BoxDecoration(color: f.$3, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Expanded(child: Text(f.$1, style: const TextStyle(fontSize: 12))),
                          Text('${f.$2.toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: f.$2 / 100,
                                minHeight: 4,
                                backgroundColor: f.$3.withValues(alpha: 0.15),
                                valueColor: AlwaysStoppedAnimation(f.$3),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('\$${(45000 * f.$2 / 100).round()}',
                              style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ],
                  ),
                )).toList(),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Documents acknowledged
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                  const SizedBox(width: 6),
                  Text('Documents', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 10),
                ...[
                  'Distribution Statement — Acknowledged',
                  'Form 1099-R — Acknowledged',
                ].map((d) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check, size: 14, color: AppColors.success),
                      const SizedBox(width: 8),
                      Text(d, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 12),

          AppCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.shield_outlined, color: AppColors.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Rollover Agreement', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => setState(() => _agreed = !_agreed),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _agreed,
                              onChanged: (v) => setState(() => _agreed = v ?? false),
                              activeColor: AppColors.primary,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'I authorize this rollover from my previous plan. I understand the tax implications and certify that all information provided is accurate. I have read and understood the rollover documentation.',
                                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _DetailRow extends StatelessWidget {
  final String label, value;

  const _DetailRow({required this.label, required this.value});

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
