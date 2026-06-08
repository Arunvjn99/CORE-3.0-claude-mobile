import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
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
          const Text('Tax Impact & Fees',
              style: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
          const SizedBox(height: 8),
          const Text('Review the taxes, penalties, and fees that will apply to your withdrawal.',
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.lightTextSecondary)),
          const SizedBox(height: 20),

          // Breakdown card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Withdrawal Breakdown',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                const SizedBox(height: 16),
                _BreakdownRow(label: 'Withdrawal Amount', sublabel: 'Total from selected sources',
                    value: '\$$_withdrawalAmount',
                    valueStyle: const TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                Divider(height: 24, color: AppColors.lightBorder),
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
                Divider(height: 24, color: AppColors.lightBorder),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Final Payout',
                              style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                          const Text('Amount you will receive',
                              style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.lightTextSecondary)),
                        ]),
                      ),
                      Text('\$$_finalPayout',
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.success)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Remaining balance card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: AppColors.iconBgBlue, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.trending_down, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Remaining Retirement Balance',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary)),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('\$$_remaining',
                              style: const TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                          const SizedBox(width: 6),
                          const Text('after withdrawal',
                              style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.lightTextSecondary)),
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
                          const Text('\$0', style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.lightTextSecondary)),
                          const Text('\$$_currentBalance (current)',
                              style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.lightTextSecondary)),
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
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () => setState(() => _taxSettingsOpen = !_taxSettingsOpen),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(color: AppColors.iconBgPurple, borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.settings, color: AppColors.chartPurple, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Tax Withholding Settings',
                                  style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary)),
                              const Text('Adjust federal and state withholding percentages',
                                  style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.lightTextSecondary)),
                            ],
                          ),
                        ),
                        AnimatedRotation(
                          turns: _taxSettingsOpen ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(Icons.keyboard_arrow_down, color: AppColors.lightTextSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_taxSettingsOpen) ...[
                  Divider(height: 1, color: AppColors.lightBorder),
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
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber, size: 16, color: AppColors.warning),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tax Notice: This withholding may not cover all tax liabilities. You may owe additional taxes when you file your return. The early withdrawal penalty may be waived for certain qualifying hardship circumstances. Consult with a tax professional for personalized advice.',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.warning, height: 1.4),
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
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.lightTextPrimary)),
              Text(sublabel, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.lightTextSecondary)),
            ],
          ),
        ),
        Text(value,
            style: valueStyle ?? TextStyle(
              fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600,
              color: isDeduction ? AppColors.danger : AppColors.lightTextPrimary,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary)),
                  Text(sublabel, style: const TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.lightTextSecondary)),
                ],
              ),
            ),
            Text('${value.toInt()}%',
                style: const TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
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
            Text(minLabel, style: const TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.lightTextSecondary)),
            Text(maxLabel, style: const TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.lightTextSecondary)),
          ],
        ),
      ],
    );
  }
}
