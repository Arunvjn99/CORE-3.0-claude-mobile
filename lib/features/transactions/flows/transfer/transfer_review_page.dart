import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class TransferReviewPage extends StatefulWidget {
  const TransferReviewPage({super.key});

  @override
  State<TransferReviewPage> createState() => _TransferReviewPageState();
}

class _TransferReviewPageState extends State<TransferReviewPage> {
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
                Text('Transfer Submitted',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text('Your transfer request has been submitted and will be processed at the next market close.',
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
      currentStep: 6,
      totalSteps: 6,
      primaryLabel: 'Submit Transfer',
      primaryEnabled: _agreed,
      isLoading: _isLoading,
      onPrimary: _submit,
      onBack: () => context.go(AppRoutes.transferImpact),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review and Submit',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Confirm your transfer details before submitting.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.swap_horiz, color: AppColors.primary, size: 16),
                  const SizedBox(width: 6),
                  Text('Transfer Details', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 12),
                _DetailRow(label: 'Transfer Type', value: 'Existing Balance'),
                const SizedBox(height: 8),
                _DetailRow(label: 'From Fund', value: 'Large Cap Equity Fund (LCEF)'),
                const SizedBox(height: 8),
                _DetailRow(label: 'To Fund', value: 'Small Cap Growth Fund (SCGF)'),
                const SizedBox(height: 8),
                _DetailRow(label: 'Transfer Amount', value: '\$5,000'),
                const SizedBox(height: 8),
                _DetailRow(label: 'Execution', value: 'Next Market Close (4:00 PM ET)'),
                const SizedBox(height: 8),
                _DetailRow(label: 'Processing Fee', value: 'None'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Allocation change summary
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.pie_chart_outline, color: AppColors.primary, size: 16),
                  const SizedBox(width: 6),
                  Text('Allocation Change', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('LCEF', style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
                            const Text('40% → 23%',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.danger)),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.arrow_forward, size: 16, color: AppColors.primary),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.successBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('SCGF', style: const TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w600)),
                            const Text('0% → 17%',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.success)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
                      const Text('Transfer Agreement', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
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
                                'I authorize this fund transfer and understand that the transaction will be processed at the next market close. The actual transfer price may differ from the current NAV.',
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
