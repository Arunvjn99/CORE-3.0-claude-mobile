import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class RebalanceReviewPage extends StatefulWidget {
  const RebalanceReviewPage({super.key});

  @override
  State<RebalanceReviewPage> createState() => _RebalanceReviewPageState();
}

class _RebalanceReviewPageState extends State<RebalanceReviewPage> {
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
                Text('Rebalance Submitted',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text('Your rebalance request has been submitted and trades will execute at the next market close.',
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
      title: 'Review & Confirm',
      currentStep: 4,
      totalSteps: 4,
      primaryLabel: 'Submit Rebalance',
      primaryEnabled: _agreed,
      isLoading: _isLoading,
      onPrimary: _submit,
      onBack: () => context.go(AppRoutes.rebalanceTrades),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review & Confirm',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Review your rebalancing order before confirming.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),

          // Order details
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.tune, color: AppColors.primary, size: 16),
                  const SizedBox(width: 6),
                  Text('Rebalance Order', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 12),
                _Row(label: 'Rebalance Type', value: 'Manual (Custom Target)'),
                const SizedBox(height: 8),
                _Row(label: 'Total Portfolio Value', value: '\$30,000'),
                const SizedBox(height: 8),
                _Row(label: 'Number of Trades', value: '2 (1 sell, 1 buy)'),
                const SizedBox(height: 8),
                _Row(label: 'Execution', value: 'Next Market Close'),
                const SizedBox(height: 8),
                _Row(label: 'Transaction Fees', value: 'None'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Allocation change
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('New Target Allocation', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                ...[
                  ('Large Cap Equity Fund', 35.0, AppColors.primary),
                  ('International Growth Fund', 25.0, AppColors.chartPurple),
                  ('Stable Value Bond Fund', 25.0, AppColors.success),
                  ('Target Date 2050 Fund', 15.0, AppColors.chartOrange),
                ].map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: f.$3, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(f.$1, style: const TextStyle(fontSize: 12))),
                      Text('${f.$2.toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  ),
                )).toList(),
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
                      const Text('Rebalance Agreement', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
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
                                'I authorize this portfolio rebalance. I understand that trades will execute at the next market close and final allocation percentages may vary slightly due to market movements.',
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

class _Row extends StatelessWidget {
  final String label, value;

  const _Row({required this.label, required this.value});

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
