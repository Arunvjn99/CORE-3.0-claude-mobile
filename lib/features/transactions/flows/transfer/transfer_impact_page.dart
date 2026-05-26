import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class TransferImpactPage extends StatelessWidget {
  const TransferImpactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    const transferAmount = 5000;
    const fromFund = 'Large Cap Equity Fund';
    const toFund = 'Small Cap Growth Fund';

    final beforeAlloc = [
      ('Large Cap Equity Fund', 40.0, AppColors.primary),
      ('International Growth Fund', 25.0, AppColors.chartPurple),
      ('Stable Value Bond Fund', 20.0, AppColors.success),
      ('Target Date 2050 Fund', 15.0, AppColors.chartOrange),
    ];

    final afterAlloc = [
      ('Large Cap Equity Fund', 23.0, AppColors.primary),
      ('Small Cap Growth Fund', 17.0, AppColors.info),
      ('International Growth Fund', 25.0, AppColors.chartPurple),
      ('Stable Value Bond Fund', 20.0, AppColors.success),
      ('Target Date 2050 Fund', 15.0, AppColors.chartOrange),
    ];

    return FlowScaffold(
      title: 'Impact Summary',
      currentStep: 5,
      totalSteps: 6,
      primaryLabel: 'Review Transfer',
      onPrimary: () => context.go(AppRoutes.transferReview),
      onBack: () => context.go(AppRoutes.transferAmount),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Transfer Impact',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Review how this transfer will affect your portfolio allocation.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),

          // Transfer summary arrow
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('FROM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: scheme.onSurfaceVariant, letterSpacing: 0.5)),
                      const SizedBox(height: 4),
                      const Text(fromFund, textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      Text('\$$transferAmount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.danger)),
                    ],
                  ),
                ),
                Container(
                  width: 36, height: 36,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('TO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: scheme.onSurfaceVariant, letterSpacing: 0.5)),
                      const SizedBox(height: 4),
                      const Text(toFund, textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      Text('\$$transferAmount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.success)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Before / After allocations
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Portfolio Allocation Change',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BEFORE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: scheme.onSurfaceVariant, letterSpacing: 0.5)),
                          const SizedBox(height: 8),
                          ...beforeAlloc.map((f) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                Container(width: 8, height: 8,
                                    decoration: BoxDecoration(color: f.$3, shape: BoxShape.circle)),
                                const SizedBox(width: 6),
                                Expanded(child: Text(f.$1, style: const TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis)),
                                const SizedBox(width: 4),
                                Text('${f.$2.toInt()}%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.arrow_forward, color: AppColors.primary, size: 20),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AFTER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.5)),
                          const SizedBox(height: 8),
                          ...afterAlloc.map((f) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                Container(width: 8, height: 8,
                                    decoration: BoxDecoration(color: f.$3, shape: BoxShape.circle)),
                                const SizedBox(width: 6),
                                Expanded(child: Text(f.$1, style: const TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis)),
                                const SizedBox(width: 4),
                                Text('${f.$2.toInt()}%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.warningBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.access_time, size: 16, color: AppColors.warning),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'This transfer will be executed at the next market close. Actual allocation percentages may vary slightly due to market price changes.',
                    style: TextStyle(fontSize: 12, color: AppColors.warning, height: 1.4),
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
