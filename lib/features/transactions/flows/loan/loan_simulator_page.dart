import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/design_system/theme/brand_tokens.dart';
import '../../../../core/widgets/flow_scaffold.dart';

class LoanSimulatorPage extends StatefulWidget {
  const LoanSimulatorPage({super.key});

  @override
  State<LoanSimulatorPage> createState() => _LoanSimulatorPageState();
}

class _LoanSimulatorPageState extends State<LoanSimulatorPage> {
  double _amount = 10000;
  int _months = 24;

  double get _interestRate => 0.065;
  double get _monthlyPayment => _amount / _months + _amount * _interestRate / 12;
  double get _totalInterest => _amount * _interestRate * _months / 12;
  double get _totalRepayment => _amount + _totalInterest;

  String _fmt(double v) => '\$${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final tokens = context.brandTokens;

    return FlowScaffold(
      title: 'Loan Simulator',
      currentStep: 2,
      totalSteps: 6,
      primaryLabel: 'Continue with This Loan',
      onPrimary: () => context.go(AppRoutes.loanConfiguration),
      onBack: () => context.go(AppRoutes.loan),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Simulate your loan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: tokens.brandNavy,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Adjust the amount and term to see your estimated payments',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.lightTextSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),

          // Amount card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: tokens.heroGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: tokens.cardElevation,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loan Amount',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: tokens.brandNavy.withValues(alpha: 0.7),
                    letterSpacing: 0.5,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '\$${_amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: tokens.brandPrimary,
                    letterSpacing: -1.2,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 20),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: tokens.brandPrimary,
                    inactiveTrackColor: tokens.brandPrimary.withValues(alpha: 0.2),
                    thumbColor: tokens.brandPrimary,
                    overlayColor: tokens.brandPrimary.withValues(alpha: 0.1),
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                  ),
                  child: Slider(
                    value: _amount,
                    min: 1000,
                    max: 71447,
                    divisions: 70,
                    onChanged: (v) => setState(() => _amount = v),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$1,000',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.lightTextMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '\$71,447',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.lightTextMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Term card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: tokens.cardElevation,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Repayment Term',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: tokens.brandNavy.withValues(alpha: 0.7),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$_months months',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: AppColors.success,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 20),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: AppColors.success,
                    inactiveTrackColor: AppColors.success.withValues(alpha: 0.2),
                    thumbColor: AppColors.success,
                    overlayColor: AppColors.success.withValues(alpha: 0.1),
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                  ),
                  child: Slider(
                    value: _months.toDouble(),
                    min: 12,
                    max: 60,
                    divisions: 4,
                    onChanged: (v) => setState(() => _months = v.round()),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '12 months',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.lightTextMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '60 months',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.lightTextMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Summary card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: tokens.cardElevation,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: tokens.brandNavy,
                  ),
                ),
                const SizedBox(height: 16),
                _SummaryRow(
                  label: 'Monthly Payment',
                  value: _fmt(_monthlyPayment),
                  color: tokens.brandPrimary,
                  icon: Icons.calendar_today_outlined,
                  isHighlighted: true,
                ),
                const SizedBox(height: 12),
                Divider(color: AppColors.lightBorderLight),
                const SizedBox(height: 12),
                _SummaryRow(
                  label: 'Total Interest',
                  value: _fmt(_totalInterest),
                  color: AppColors.warning,
                  icon: Icons.trending_up_outlined,
                ),
                const SizedBox(height: 12),
                Divider(color: AppColors.lightBorderLight),
                const SizedBox(height: 12),
                _SummaryRow(
                  label: 'Total Repayment',
                  value: _fmt(_totalRepayment),
                  color: tokens.brandNavy,
                  icon: Icons.account_balance_wallet_outlined,
                  isBold: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Info callout
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.infoBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.info, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This is an estimate. Your actual interest rate may vary.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.infoText,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final bool isBold;
  final bool isHighlighted;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    this.isBold = false,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.lightTextSecondary,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlighted ? 20 : (isBold ? 18 : 16),
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
