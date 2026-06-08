import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/flow_scaffold.dart';

class LoanFeesPage extends StatelessWidget {
  const LoanFeesPage({super.key});

  static const double _loanAmount = 5000;
  static const double _transactionFee = 50;
  static const double _tpaFee = 25;
  static const double _eftFee = 10;
  static const double _redemptionFee = 15;
  static double get _totalFees => _transactionFee + _tpaFee + _eftFee + _redemptionFee;
  static double get _netAmount => _loanAmount - _totalFees;

  static const _fees = [
    ('Transaction Fee', 'One-time processing fee', _transactionFee),
    ('TPA Fee', 'Third-party administrator fee', _tpaFee),
    ('EFT Fee', 'Electronic funds transfer fee', _eftFee),
    ('Redemption Fee', 'Investment liquidation fee', _redemptionFee),
  ];

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Fees & Charges',
      currentStep: 4,
      totalSteps: 6,
      primaryLabel: 'Continue to Documents',
      onPrimary: () => context.go(AppRoutes.loanDocuments),
      onBack: () => context.go(AppRoutes.loanConfiguration),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fees and Charges',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.lightTextPrimary),
          ),
          const SizedBox(height: 4),
          const Text(
            'Review all fees associated with your loan request. Fees are deducted from the gross loan amount.',
            style: TextStyle(fontSize: 13, color: AppColors.lightTextSecondary, height: 1.5),
          ),
          const SizedBox(height: 24),

          // Fee Breakdown Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                  child: const Text('Fee Breakdown', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
                const Divider(height: 1),

                // Gross Loan Amount
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gross Loan Amount', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          Text('Total amount requested', style: TextStyle(fontSize: 11, color: AppColors.lightTextSecondary)),
                        ],
                      ),
                      Text('\$${_loanAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                const Divider(height: 1, indent: 18, endIndent: 18),

                // Individual Fees
                ...List.generate(_fees.length, (i) {
                  final fee = _fees[i];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(fee.$1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                Text(fee.$2, style: const TextStyle(fontSize: 10, color: AppColors.lightTextSecondary)),
                              ],
                            ),
                            Text('-\$${fee.$3.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.lightTextSecondary)),
                          ],
                        ),
                      ),
                      if (i < _fees.length - 1) const Divider(height: 1, indent: 18, endIndent: 18),
                    ],
                  );
                }),
                const Divider(height: 1),

                // Total Fees
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Fees', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      Text('-\$${_totalFees.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.danger)),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Net Loan Amount
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Net Loan Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          Text('Amount you will receive', style: TextStyle(fontSize: 11, color: AppColors.lightTextSecondary)),
                        ],
                      ),
                      Text(
                        '\$${_netAmount.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Info Note
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.infoBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: AppColors.info, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 12, color: AppColors.info, height: 1.5),
                      children: [
                        const TextSpan(text: 'Note: ', style: TextStyle(fontWeight: FontWeight.w700)),
                        TextSpan(text: 'All fees will be deducted from your loan amount. Monthly payments are based on the gross amount of \$${_loanAmount.toStringAsFixed(0)}, but you will receive \$${_netAmount.toStringAsFixed(0)}.'),
                      ],
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
