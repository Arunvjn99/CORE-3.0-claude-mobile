import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/flow_scaffold.dart';

class LoanFeesPage extends StatelessWidget {
  const LoanFeesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FlowScaffold(
      title: 'Fees & Charges',
      currentStep: 4,
      totalSteps: 6,
      primaryLabel: 'I Understand — Continue',
      onPrimary: () => context.go(AppRoutes.loanDocuments),
      onBack: () => context.go(AppRoutes.loanConfiguration),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Fees & Charges', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Review all fees before submitting.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 24),
          _FeeRow('Origination Fee', '\$75.00', 'One-time processing fee'),
          const Divider(height: 24),
          _FeeRow('Interest Rate', '6.50% APR', 'Prime + 1% fixed'),
          const Divider(height: 24),
          _FeeRow('Administrative Fee', '\$15.00/yr', 'Annual maintenance'),
          const Divider(height: 24),
          _FeeRow('Early Repayment', 'None', 'No prepayment penalty'),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.warningBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.warning.withValues(alpha: 0.3))),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_outlined, color: AppColors.warning, size: 20),
                SizedBox(width: 10),
                Expanded(child: Text('Loan repayments are made with after-tax dollars. Interest goes back into your account.', style: TextStyle(fontSize: 12, color: AppColors.warning, height: 1.5))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeeRow extends StatelessWidget {
  final String label;
  final String amount;
  final String note;
  const _FeeRow(this.label, this.amount, this.note);
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)), Text(note, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant))])),
        Text(amount, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
      ],
    );
  }
}
