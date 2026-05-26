import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class WithdrawalTypePage extends StatefulWidget {
  const WithdrawalTypePage({super.key});

  @override
  State<WithdrawalTypePage> createState() => _WithdrawalTypePageState();
}

class _WithdrawalTypePageState extends State<WithdrawalTypePage> {
  String? _selected;

  static const _types = [
    (
      id: 'hardship',
      label: 'Hardship Withdrawal',
      description: 'For immediate and heavy financial needs such as medical expenses, preventing eviction, or funeral expenses. Documentation required.',
      warning: 'May be subject to 10% early withdrawal penalty if under age 59½',
      warnColor: AppColors.warning,
    ),
    (
      id: 'in-service',
      label: 'In-Service Withdrawal',
      description: 'Available for participants who have reached age 59½ while still employed. No early withdrawal penalty applies.',
      warning: 'Only available if you are age 59½ or older',
      warnColor: AppColors.primary,
    ),
    (
      id: 'termination',
      label: 'Termination Withdrawal',
      description: 'Full or partial distribution available after separation from service. You may also roll over funds to another plan or IRA.',
      warning: 'Requires proof of separation from employment',
      warnColor: AppColors.chartGray,
    ),
    (
      id: 'rmd',
      label: 'Required Minimum Distribution (RMD)',
      description: 'Mandatory distribution required by law beginning at age 73. Failure to take RMDs may result in a 25% excise tax on the shortfall.',
      warning: 'Calculated based on your account balance and life expectancy',
      warnColor: AppColors.success,
    ),
    (
      id: 'one-time',
      label: 'One-Time Withdrawal',
      description: 'Standard withdrawal for any purpose. Taxes and penalties may apply depending on your age and account type.',
      warning: '',
      warnColor: AppColors.primary,
    ),
    (
      id: 'full-balance',
      label: 'Full Balance Withdrawal',
      description: 'Withdraw your entire vested account balance. This will close your retirement account with this plan.',
      warning: 'Warning: This action cannot be undone',
      warnColor: AppColors.danger,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FlowScaffold(
      title: 'Withdrawal Type',
      currentStep: 2,
      totalSteps: 6,
      primaryLabel: 'Continue to Source Selection',
      primaryEnabled: _selected != null,
      onPrimary: () => context.go(AppRoutes.withdrawalSource),
      onBack: () => context.go(AppRoutes.withdrawal),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Withdrawal Type',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Choose the type of withdrawal. Each type has different eligibility requirements and tax implications.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),
          ..._types.map((type) {
            final isSelected = _selected == type.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => setState(() => _selected = type.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.06) : scheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : scheme.outline,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Radio<String>(
                        value: type.id,
                        groupValue: _selected,
                        onChanged: (v) => setState(() => _selected = v),
                        activeColor: AppColors.primary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(type.label,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(type.description,
                                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant, height: 1.4)),
                            if (type.warning.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.warning_amber, size: 12, color: type.warnColor),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(type.warning,
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: type.warnColor)),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (_selected == 'rmd') ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.successBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 16, color: AppColors.success),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('RMD Calculation',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.success)),
                        const SizedBox(height: 4),
                        const Text(
                          'Your estimated RMD for 2026 is \$1,125 based on your account balance of \$30,000 and the IRS Uniform Lifetime Table. Must be distributed by December 31, 2026.',
                          style: TextStyle(fontSize: 12, color: AppColors.success, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
