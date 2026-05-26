import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/flow_scaffold.dart';

class LoanSimulatorPage extends StatefulWidget {
  const LoanSimulatorPage({super.key});
  @override
  State<LoanSimulatorPage> createState() => _LoanSimulatorPageState();
}

class _LoanSimulatorPageState extends State<LoanSimulatorPage> {
  double _amount = 10000;
  int _months = 24;

  String get _simpleMonthly => ('\$${(_amount / _months + _amount * 0.065 / 12).toStringAsFixed(2)}');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
          Text('Simulate Your Loan', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Adjust the amount and term to see your estimated payments.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 24),

          Text('Loan Amount', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Center(child: Text('\$${_amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: AppColors.primary))),
          Slider(value: _amount, min: 1000, max: 71447, divisions: 70, onChanged: (v) => setState(() => _amount = v)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$1,000', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
              Text('\$71,447', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 20),

          Text('Repayment Term', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Center(child: Text('$_months months', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.success))),
          Slider(value: _months.toDouble(), min: 12, max: 60, divisions: 4, activeColor: AppColors.success, onChanged: (v) => setState(() => _months = v.round())),

          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _Row('Monthly Payment', _simpleMonthly, AppColors.primary),
                const Divider(height: 16),
                _Row('Total Interest', '\$${(_amount * 0.065 * _months / 12).toStringAsFixed(2)}', AppColors.warning),
                const Divider(height: 16),
                _Row('Total Repayment', '\$${(_amount + _amount * 0.065 * _months / 12).toStringAsFixed(2)}', AppColors.primaryDark, bold: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool bold;

  const _Row(this.label, this.value, this.color, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: bold ? FontWeight.w800 : FontWeight.w700, color: color)),
      ],
    );
  }
}
