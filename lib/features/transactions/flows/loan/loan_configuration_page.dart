import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/flow_scaffold.dart';

class LoanConfigurationPage extends StatefulWidget {
  const LoanConfigurationPage({super.key});
  @override
  State<LoanConfigurationPage> createState() => _LoanConfigurationPageState();
}

class _LoanConfigurationPageState extends State<LoanConfigurationPage> {
  final _purposeCtrl = TextEditingController();
  String _disbursement = 'Direct Deposit';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FlowScaffold(
      title: 'Loan Details',
      currentStep: 3,
      totalSteps: 6,
      primaryLabel: 'Continue',
      primaryEnabled: _purposeCtrl.text.trim().isNotEmpty,
      onPrimary: () => context.go(AppRoutes.loanFees),
      onBack: () => context.go(AppRoutes.loanSimulator),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Loan Configuration', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Provide loan purpose and disbursement details.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 24),
          Text('Loan Purpose', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _purposeCtrl,
            maxLines: 3,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(hintText: 'Describe the purpose of your loan...'),
          ),
          const SizedBox(height: 20),
          Text('Disbursement Method', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...['Direct Deposit', 'Check by Mail'].map((opt) => RadioListTile(
            value: opt,
            groupValue: _disbursement,
            onChanged: (v) => setState(() => _disbursement = v!),
            title: Text(opt),
            contentPadding: EdgeInsets.zero,
          )),
        ],
      ),
    );
  }
}
