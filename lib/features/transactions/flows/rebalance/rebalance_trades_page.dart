import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class RebalanceTradesPage extends StatelessWidget {
  const RebalanceTradesPage({super.key});

  static const _sells = [
    ('Large Cap Equity Fund', 'LCEF', 1500, AppColors.danger),
  ];

  static const _buys = [
    ('Stable Value Bond Fund', 'SVBF', 1500, AppColors.success),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FlowScaffold(
      title: 'Trade Preview',
      currentStep: 3,
      totalSteps: 4,
      primaryLabel: 'Review & Confirm',
      onPrimary: () => context.go(AppRoutes.rebalanceReview),
      onBack: () => context.go(AppRoutes.rebalanceAdjust),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trade Preview',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('These trades will be executed to reach your target allocation.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),

          // Summary chips
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.dangerBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.trending_down, color: AppColors.danger, size: 20),
                      const SizedBox(height: 4),
                      Text('${_sells.length} Sell', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.danger)),
                      Text('\$${_sells.fold(0, (s, t) => s + t.$3)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.danger)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.trending_up, color: AppColors.success, size: 20),
                      const SizedBox(height: 4),
                      Text('${_buys.length} Buy', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success)),
                      Text('\$${_buys.fold(0, (s, t) => s + t.$3)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.success)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Sell orders
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.arrow_upward, color: AppColors.danger, size: 16),
                  const SizedBox(width: 6),
                  Text('Sell Orders', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 12),
                ..._sells.map((t) => _TradeRow(name: t.$1, ticker: t.$2, amount: t.$3, color: t.$4, isSell: true)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Buy orders
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.arrow_downward, color: AppColors.success, size: 16),
                  const SizedBox(width: 6),
                  Text('Buy Orders', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 12),
                ..._buys.map((t) => _TradeRow(name: t.$1, ticker: t.$2, amount: t.$3, color: t.$4, isSell: false)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'All trades execute at the next market close (4:00 PM ET). No transaction fees apply to rebalancing within your plan. Prices are based on end-of-day NAV.',
                    style: TextStyle(fontSize: 12, color: AppColors.primary, height: 1.4),
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

class _TradeRow extends StatelessWidget {
  final String name, ticker;
  final int amount;
  final Color color;
  final bool isSell;

  const _TradeRow({required this.name, required this.ticker, required this.amount, required this.color, required this.isSell});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(isSell ? Icons.remove : Icons.add, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(ticker, style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          Text('${isSell ? '-' : '+'}\$$amount',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }
}
