import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';

class TransactionCenterPage extends StatelessWidget {
  TransactionCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: AppBar(title: const Text('Transactions')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('What would you like to do?', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: const Color(0xFF111827))),
              const SizedBox(height: 4),
              Text('Manage loans, withdrawals, transfers, and more.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 16),

              ..._transactions.map((tx) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _TransactionTile(
                  icon: tx.$1,
                  title: tx.$2,
                  subtitle: tx.$3,
                  badge: tx.$4,
                  color: tx.$5,
                  route: tx.$6,
                ),
              )),

              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Transactions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const Text('Last 90 days', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                ],
              ),
              const SizedBox(height: 12),
              AppCard(
                noPadding: true,
                child: Column(
                  children: _recentTx.asMap().entries.map((e) {
                    final i = e.key;
                    final tx = e.value;
                    return Column(
                      children: [
                        if (i > 0) const Divider(height: 1),
                        ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: tx.$3.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(tx.$2, color: tx.$3, size: 20),
                          ),
                          title: Text(tx.$1, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          subtitle: Text(tx.$4, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(tx.$5, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: tx.$6)),
                              Text(tx.$7, style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: prefer_const_constructors_in_immutables
  final _transactions = [
    (Icons.account_balance_outlined, 'Take a Loan', 'Borrow from your balance', null, AppColors.primary, AppRoutes.loan),
    (Icons.payments_outlined, 'Withdraw Money', 'Access your funds early', 'Eligibility Check', AppColors.success, AppRoutes.withdrawal),
    (Icons.swap_horiz, 'Transfer Funds', 'Move funds between plans', null, AppColors.chartPurple, AppRoutes.transfer),
    (Icons.tune, 'Rebalance', 'Adjust your investment mix', null, AppColors.chartOrange, AppRoutes.rebalance),
    (Icons.replay, 'Roll Over', 'Transfer from external plan', null, AppColors.info, AppRoutes.rollover),
  ];

  final _recentTx = [
    ('Monthly Contribution', Icons.arrow_downward, AppColors.success, 'Payroll deduction', '+\$450.00', AppColors.success, 'Oct 31'),
    ('Employer Match', Icons.business, AppColors.primary, 'Safe Harbor match', '+\$225.00', AppColors.success, 'Oct 31'),
    ('Portfolio Rebalance', Icons.refresh, AppColors.chartGray, 'Auto quarterly', 'Completed', AppColors.chartGray, 'Oct 1'),
    ('Loan Payment', Icons.credit_card, AppColors.danger, 'LOAN-2024-001', '-\$148.00', AppColors.danger, 'Oct 15'),
  ];
}

class _TransactionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badge;
  final Color color;
  final String route;

  const _TransactionTile({
    required this.icon, required this.title, required this.subtitle,
    required this.badge, required this.color, required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppCard(
      onTap: () => context.push(route),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    if (badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.warningBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(badge!, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.warning)),
                      ),
                    ],
                  ],
                ),
                Text(subtitle, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
