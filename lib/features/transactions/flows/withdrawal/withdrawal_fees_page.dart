import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class WithdrawalFeesPage extends StatefulWidget {
  const WithdrawalFeesPage({super.key});

  @override
  State<WithdrawalFeesPage> createState() => _WithdrawalFeesPageState();
}

class _WithdrawalFeesPageState extends State<WithdrawalFeesPage> {
  double _federal = 20;
  double _state = 5;
  bool _taxSettingsOpen = false;

  static const _withdrawalAmount = 3000;
  static const _currentBalance = 30000;
  static const _isEarly = true;
  static const _redemptionFee = 25;

  int get _federalTax => (_withdrawalAmount * _federal / 100).round();
  int get _stateTax => (_withdrawalAmount * _state / 100).round();
  int get _earlyPenalty => _isEarly ? (_withdrawalAmount * 0.1).round() : 0;
  int get _totalDeductions => _federalTax + _stateTax + _earlyPenalty + _redemptionFee;
  int get _finalPayout => _withdrawalAmount - _totalDeductions;
  int get _remaining => _currentBalance - _withdrawalAmount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FlowScaffold(
      title: 'Fees & Taxes',
      currentStep: 4,
      totalSteps: 6,
      primaryLabel: 'Continue to Payment Method',
      onPrimary: () => context.go(AppRoutes.withdrawalPayment),
      onBack: () => context.go(AppRoutes.withdrawalSource),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tax Impact & Fees',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Review the taxes, penalties, and fees that will apply to your withdrawal.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),

          // Breakdown card
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Withdrawal Breakdown',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                _BreakdownRow(label: 'Withdrawal Amount', sublabel: 'Total from selected sources',
                    value: '\$$_withdrawalAmount', valueStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                Divider(height: 24, color: scheme.outline.withValues(alpha: 0.3)),
                _BreakdownRow(label: 'Federal Tax Withholding (${_federal.toInt()}%)',
                    sublabel: 'Mandatory minimum withholding', value: '-\$$_federalTax', isDeduction: true),
                const SizedBox(height: 10),
                _BreakdownRow(label: 'State Tax Withholding (${_state.toInt()}%)',
                    sublabel: 'Based on your state of residence', value: '-\$$_stateTax', isDeduction: true),
                if (_isEarly) ...[
                  const SizedBox(height: 10),
                  _BreakdownRow(label: 'Early Withdrawal Penalty (10%)',
                      sublabel: 'Under age 59½ penalty', value: '-\$$_earlyPenalty', isDeduction: true),
                ],
                const SizedBox(height: 10),
                _BreakdownRow(label: 'Redemption Fee',
                    sublabel: 'Investment liquidation fee', value: '-\$$_redemptionFee', isDeduction: true),
                Divider(height: 24, color: scheme.outline.withValues(alpha: 0.3)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Final Payout', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                          Text('Amount you will receive', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                        ]),
                      ),
                      Text('\$$_finalPayout',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.success)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Remaining balance card
          AppCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.trending_down, color: AppColors.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Remaining Retirement Balance',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('\$$_remaining',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                          const SizedBox(width: 6),
                          Text('after withdrawal',
                              style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _remaining / _currentBalance,
                          minHeight: 8,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('\$0', style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
                          Text('\$$_currentBalance (current)', style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Tax settings (collapsible)
          AppCard(
            noPadding: true,
            child: Column(
              children: [
                InkWell(
                  onTap: () => setState(() => _taxSettingsOpen = !_taxSettingsOpen),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.chartPurple.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.settings, color: AppColors.chartPurple, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Tax Withholding Settings',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              Text('Adjust federal and state withholding percentages',
                                  style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        AnimatedRotation(
                          turns: _taxSettingsOpen ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(Icons.keyboard_arrow_down, color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_taxSettingsOpen) ...[
                  Divider(height: 1, color: scheme.outline.withValues(alpha: 0.3)),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TaxSlider(
                          label: 'Federal Withholding',
                          sublabel: 'Minimum 10% required',
                          value: _federal,
                          min: 10, max: 37,
                          onChanged: (v) => setState(() => _federal = v),
                          minLabel: '10% min', maxLabel: '37% max',
                        ),
                        const SizedBox(height: 20),
                        _TaxSlider(
                          label: 'State Withholding',
                          sublabel: 'Varies by state (NY shown)',
                          value: _state,
                          min: 0, max: 13,
                          onChanged: (v) => setState(() => _state = v),
                          minLabel: '0%', maxLabel: '13% max',
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Tax notice
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
                const Icon(Icons.warning_amber, size: 16, color: AppColors.warning),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Tax Notice: This withholding may not cover all tax liabilities. You may owe additional taxes when you file your return. The early withdrawal penalty may be waived for certain qualifying hardship circumstances. Consult with a tax professional for personalized advice.',
                    style: TextStyle(fontSize: 12, color: AppColors.warning, height: 1.4),
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

class _BreakdownRow extends StatelessWidget {
  final String label;
  final String sublabel;
  final String value;
  final bool isDeduction;
  final TextStyle? valueStyle;

  const _BreakdownRow({
    required this.label, required this.sublabel, required this.value,
    this.isDeduction = false, this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 13)),
              Text(sublabel, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
            ],
          ),
        ),
        Text(value,
            style: valueStyle ?? TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600,
              color: isDeduction ? AppColors.danger : null,
            )),
      ],
    );
  }
}

class _TaxSlider extends StatelessWidget {
  final String label;
  final String sublabel;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final String minLabel;
  final String maxLabel;

  const _TaxSlider({
    required this.label, required this.sublabel, required this.value,
    required this.min, required this.max, required this.onChanged,
    required this.minLabel, required this.maxLabel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  Text(sublabel, style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
            Text('${value.toInt()}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ],
        ),
        Slider(
          value: value, min: min, max: max, divisions: (max - min).round(),
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(minLabel, style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
            Text(maxLabel, style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
          ],
        ),
      ],
    );
  }
}
