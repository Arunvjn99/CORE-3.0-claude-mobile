import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class RolloverValidationPage extends StatefulWidget {
  const RolloverValidationPage({super.key});

  @override
  State<RolloverValidationPage> createState() => _RolloverValidationPageState();
}

class _RolloverValidationPageState extends State<RolloverValidationPage> {
  bool _isValidating = false;
  bool _validated = false;

  Future<void> _validate() async {
    setState(() => _isValidating = true);
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;
    setState(() { _isValidating = false; _validated = true; });
  }

  @override
  Widget build(BuildContext context) {
    final checks = [
      ('Plan is eligible for rollover', _validated, 'Traditional 401(k) plans are eligible'),
      ('No outstanding loans', _validated, 'No active loans detected on this plan'),
      ('Vesting requirement met', _validated, '100% vested balance confirmed'),
      ('Plan accepts incoming rollovers', _validated, 'Your current plan accepts rollovers'),
    ];

    return FlowScaffold(
      title: 'Validation',
      currentStep: 2,
      totalSteps: 5,
      primaryLabel: 'Set Allocation',
      primaryEnabled: _validated,
      onPrimary: () => context.go(AppRoutes.rolloverAllocation),
      onBack: () => context.go(AppRoutes.rollover),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Plan Validation',
              style: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
          const SizedBox(height: 8),
          const Text('We\'ll verify your external plan details before processing the rollover.',
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.lightTextSecondary)),
          const SizedBox(height: 20),

          // External plan summary
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
                const Text('External Plan Summary',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                const SizedBox(height: 12),
                _SummaryRow(label: 'Plan Name', value: 'Acme Corporation 401(k)'),
                const SizedBox(height: 8),
                _SummaryRow(label: 'Account Type', value: 'Traditional 401(k)'),
                const SizedBox(height: 8),
                _SummaryRow(label: 'Rollover Type', value: 'Direct Rollover'),
                const SizedBox(height: 8),
                _SummaryRow(label: 'Estimated Amount', value: '\$45,000'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Validation checks
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
                Row(
                  children: [
                    const Text('Eligibility Checks',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                    const Spacer(),
                    if (!_validated && !_isValidating)
                      ElevatedButton.icon(
                        onPressed: _validate,
                        icon: const Icon(Icons.verified, size: 16),
                        label: const Text('Validate', style: TextStyle(fontFamily: 'Inter', fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          backgroundColor: AppColors.darkButton,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    if (_isValidating)
                      const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                ...checks.map((check) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: check.$2
                              ? AppColors.iconBgGreen
                              : _isValidating
                                  ? AppColors.iconBgBlue
                                  : AppColors.lightShell,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: _isValidating
                              ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2))
                              : Icon(
                                  check.$2 ? Icons.check : Icons.radio_button_unchecked,
                                  size: 16,
                                  color: check.$2 ? AppColors.success : AppColors.lightTextSecondary,
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(check.$1,
                                style: TextStyle(
                                  fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600,
                                  color: check.$2 ? AppColors.lightTextPrimary : AppColors.lightTextSecondary,
                                )),
                            Text(check.$3,
                                style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.lightTextSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          if (_validated) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.successBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified, color: AppColors.success, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your plan has been validated and is eligible for rollover. You may proceed to set up your allocation.',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.success, height: 1.4),
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

class _SummaryRow extends StatelessWidget {
  final String label, value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.lightTextSecondary))),
        Text(value, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
      ],
    );
  }
}
