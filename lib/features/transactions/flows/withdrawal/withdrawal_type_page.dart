import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/design_system/theme/brand_tokens.dart';
import '../../../../core/widgets/flow_scaffold.dart';

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
      description: 'For immediate and heavy financial needs such as medical expenses, preventing eviction, or funeral expenses.',
      warning: 'May be subject to 10% early withdrawal penalty',
      warnColor: AppColors.warning,
      icon: Icons.medical_services_outlined,
    ),
    (
      id: 'in-service',
      label: 'In-Service Withdrawal',
      description: 'Available for participants who have reached age 59½ while still employed. No early withdrawal penalty applies.',
      warning: 'Only available if you are age 59½ or older',
      warnColor: Color(0xFF2563EB),
      icon: Icons.work_outline,
    ),
    (
      id: 'termination',
      label: 'Termination Withdrawal',
      description: 'Full or partial distribution available after separation from service. You may also roll over funds to another plan or IRA.',
      warning: 'Requires proof of separation from employment',
      warnColor: Color(0xFF475569),
      icon: Icons.exit_to_app_outlined,
    ),
    (
      id: 'rmd',
      label: 'Required Minimum Distribution',
      description: 'Mandatory distribution required by law beginning at age 73. Failure to take RMDs may result in a 25% excise tax.',
      warning: 'Calculated based on your balance and life expectancy',
      warnColor: AppColors.success,
      icon: Icons.calendar_today_outlined,
    ),
    (
      id: 'one-time',
      label: 'One-Time Withdrawal',
      description: 'Standard withdrawal for any purpose. Taxes and penalties may apply depending on your age and account type.',
      warning: 'Tax withholding applies',
      warnColor: Color(0xFF2563EB),
      icon: Icons.request_quote_outlined,
    ),
    (
      id: 'full-balance',
      label: 'Full Balance Withdrawal',
      description: 'Withdraw your entire vested account balance. This will close your retirement account with this plan.',
      warning: 'Warning: This action cannot be undone',
      warnColor: AppColors.danger,
      icon: Icons.inventory_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = context.brandTokens;

    return FlowScaffold(
      title: 'Withdrawal Type',
      currentStep: 2,
      totalSteps: 6,
      primaryLabel: 'Continue',
      primaryEnabled: _selected != null,
      onPrimary: () => context.go(AppRoutes.withdrawalSource),
      onBack: () => context.go(AppRoutes.withdrawal),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select withdrawal type',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: tokens.brandNavy,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose the type that matches your situation. Each has different requirements and tax implications.',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.lightTextSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          ..._types.map((type) {
            final isSelected = _selected == type.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => setState(() => _selected = type.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isSelected ? type.warnColor.withValues(alpha: 0.06) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? type.warnColor : AppColors.lightBorder,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: type.warnColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              type.icon,
                              color: type.warnColor,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              type.label,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: tokens.brandNavy,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: type.warnColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              ),
                            )
                          else
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.lightBorder),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        type.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.lightTextSecondary,
                          height: 1.5,
                        ),
                      ),
                      if (type.warning.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: type.warnColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 14,
                                color: type.warnColor,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  type.warning,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: type.warnColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
