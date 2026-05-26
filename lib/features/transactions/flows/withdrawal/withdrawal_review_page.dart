import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class WithdrawalReviewPage extends StatefulWidget {
  const WithdrawalReviewPage({super.key});

  @override
  State<WithdrawalReviewPage> createState() => _WithdrawalReviewPageState();
}

class _WithdrawalReviewPageState extends State<WithdrawalReviewPage> {
  bool _agreed = false;
  bool _isLoading = false;
  bool _submitted = false;

  static const _amount = 3000;
  static const _federalTax = 600;
  static const _stateTax = 150;
  static const _earlyPenalty = 300;
  static const _processingFee = 25;
  static const _finalPayout = _amount - _federalTax - _stateTax - _earlyPenalty - _processingFee;

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
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.check_circle_outline, color: AppColors.success, size: 32),
                ),
                const SizedBox(height: 20),
                Text('Withdrawal Submitted',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(
                  'Your withdrawal request has been submitted successfully. You\'ll receive confirmation shortly.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                Text('Redirecting to dashboard...', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
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
      primaryLabel: 'Submit Withdrawal Request',
      primaryEnabled: _agreed,
      isLoading: _isLoading,
      onPrimary: _submit,
      onBack: () => context.go(AppRoutes.withdrawalPayment),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review and Submit',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Review your withdrawal details carefully before submitting.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),

          // Withdrawal details
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.attach_money, color: AppColors.primary, size: 16),
                  const SizedBox(width: 6),
                  Text('Withdrawal Details',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _DetailBox(label: 'Withdrawal Type', value: 'Hardship Withdrawal')),
                    const SizedBox(width: 12),
                    Expanded(child: _DetailBox(label: 'Payment Method', value: 'Electronic Funds Transfer')),
                  ],
                ),
                const SizedBox(height: 12),
                _DetailBox(label: 'Bank Account', value: 'Chase Bank - ****1234 (Checking)', fullWidth: true),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Payout breakdown
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.payments_outlined, color: AppColors.primary, size: 16),
                  const SizedBox(width: 6),
                  Text('Payout Breakdown',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Text('Withdrawal Amount', style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
                      const Spacer(),
                      const Text('\$$_amount', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _DeductionRow(label: 'Federal Tax Withholding (20%)', amount: _federalTax),
                _DeductionRow(label: 'State Tax Withholding (5%)', amount: _stateTax),
                _DeductionRow(label: 'Early Withdrawal Penalty (10%)', amount: _earlyPenalty),
                _DeductionRow(label: 'Processing Fee', amount: _processingFee),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Text('Final Payout', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      const Text('\$$_finalPayout', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.success)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Warning
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.warningBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber, size: 18, color: AppColors.warning),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'This withdrawal will permanently reduce your retirement savings and cannot be reversed once processed. Additional taxes may apply at year-end.',
                    style: TextStyle(fontSize: 12, color: AppColors.warning, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Agreement
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
                      const Text('Withdrawal Agreement',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
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
                                'I understand that this withdrawal will permanently reduce my retirement savings, may be subject to taxes and penalties, and cannot be reversed once processed. I have consulted with a financial advisor or understand the consequences of this withdrawal.',
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

class _DetailBox extends StatelessWidget {
  final String label;
  final String value;
  final bool fullWidth;

  const _DetailBox({required this.label, required this.value, this.fullWidth = false});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(),
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: scheme.onSurfaceVariant, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _DeductionRow extends StatelessWidget {
  final String label;
  final int amount;

  const _DeductionRow({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant))),
          Text('-\$$amount', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.danger)),
        ],
      ),
    );
  }
}
