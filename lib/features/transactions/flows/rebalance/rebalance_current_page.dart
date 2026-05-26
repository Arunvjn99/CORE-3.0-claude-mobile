import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class RebalanceCurrentPage extends StatelessWidget {
  const RebalanceCurrentPage({super.key});

  static const _funds = [
    ('Large Cap Equity Fund', 'LCEF', 40.0, 12000, AppColors.primary, 12.4),
    ('International Growth Fund', 'IGRF', 25.0, 7500, AppColors.chartPurple, 8.7),
    ('Stable Value Bond Fund', 'SVBF', 20.0, 6000, AppColors.success, 3.2),
    ('Target Date 2050 Fund', 'TD50', 15.0, 4500, AppColors.chartOrange, 9.1),
  ];

  static const _targetAlloc = [
    ('Large Cap Equity Fund', 35.0, AppColors.primary),
    ('International Growth Fund', 25.0, AppColors.chartPurple),
    ('Stable Value Bond Fund', 25.0, AppColors.success),
    ('Target Date 2050 Fund', 15.0, AppColors.chartOrange),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FlowScaffold(
      title: 'Current Allocation',
      currentStep: 1,
      totalSteps: 4,
      primaryLabel: 'Adjust Allocation',
      onPrimary: () => context.go(AppRoutes.rebalanceAdjust),
      onBack: () => context.go(AppRoutes.transactions),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Current Allocation',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Review your current portfolio allocation and see where rebalancing is needed.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),

          // Portfolio summary
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TOTAL PORTFOLIO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: scheme.onSurfaceVariant, letterSpacing: 0.5)),
                          const Text('\$30,000', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.warningBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning_amber, size: 14, color: AppColors.warning),
                          SizedBox(width: 4),
                          Text('Rebalance Needed', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.warning)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Stacked bar chart representation
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Row(
                    children: _funds.map((f) => Expanded(
                      flex: f.$3.round(),
                      child: Container(height: 12, color: f.$5),
                    )).toList(),
                  ),
                ),
                const SizedBox(height: 10),

                // Legend
                Wrap(
                  spacing: 12, runSpacing: 6,
                  children: _funds.map((f) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: f.$5, shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text('${f.$1.split(' ')[0]} ${f.$3.toInt()}%', style: const TextStyle(fontSize: 10)),
                    ],
                  )).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Fund breakdown
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fund Breakdown',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 14),
                ..._funds.map((f) {
                  final target = _targetAlloc.firstWhere((t) => t.$1 == f.$1, orElse: () => (f.$1, f.$3, f.$5));
                  final drift = (f.$3 - target.$2).abs();
                  final isDrifted = drift >= 3;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(width: 10, height: 10,
                                decoration: BoxDecoration(color: f.$5, shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(f.$1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            ),
                            if (isDrifted)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.warningBg,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text('+${drift.toStringAsFixed(0)}% drift',
                                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.warning)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: f.$3 / 100,
                                  minHeight: 6,
                                  backgroundColor: f.$5.withValues(alpha: 0.15),
                                  valueColor: AlwaysStoppedAnimation(f.$5),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${f.$3.toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                  Text('→ ${target.$2.toInt()}%',
                                      style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text('\$${f.$4.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} · ${f.$6}% YTD',
                            style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
