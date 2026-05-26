import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/flow_scaffold.dart';

class LoanDocumentsPage extends StatefulWidget {
  const LoanDocumentsPage({super.key});
  @override
  State<LoanDocumentsPage> createState() => _LoanDocumentsPageState();
}

class _LoanDocumentsPageState extends State<LoanDocumentsPage> {
  final Map<String, bool> _checked = {
    'Loan Agreement': false,
    'Promissory Note': false,
    'Repayment Schedule': false,
  };

  bool get _allChecked => _checked.values.every((v) => v);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FlowScaffold(
      title: 'Documents',
      currentStep: 5,
      totalSteps: 6,
      primaryLabel: 'Continue',
      primaryEnabled: _allChecked,
      onPrimary: () => context.go(AppRoutes.loanReview),
      onBack: () => context.go(AppRoutes.loanFees),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Required Documents', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Review and acknowledge each document to proceed.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 24),
          ..._checked.keys.map((doc) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _checked[doc]! ? AppColors.successBg : scheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _checked[doc]! ? AppColors.success.withValues(alpha: 0.4) : scheme.outline.withValues(alpha: 0.6)),
              ),
              child: Row(
                children: [
                  Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.description_outlined, color: AppColors.primary, size: 20)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(doc, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)), Text('Tap to review', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant))])),
                  Checkbox(value: _checked[doc], onChanged: (v) => setState(() => _checked[doc] = v!), activeColor: AppColors.success),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
