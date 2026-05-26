import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class TransferDestinationPage extends StatefulWidget {
  const TransferDestinationPage({super.key});

  @override
  State<TransferDestinationPage> createState() => _TransferDestinationPageState();
}

class _TransferDestinationPageState extends State<TransferDestinationPage> {
  final _availableFunds = const [
    ('Small Cap Growth Fund', 'SCGF', 'High growth potential', AppColors.primary),
    ('Bond Index Fund', 'BIF', 'Stable fixed income', AppColors.success),
    ('Balanced Portfolio Fund', 'BPF', 'Mixed stocks and bonds', AppColors.chartPurple),
    ('Money Market Fund', 'MMF', 'Capital preservation', AppColors.info),
  ];

  final Map<String, double> _allocations = {};

  double get _totalAlloc => _allocations.values.fold(0, (s, v) => s + v);
  bool get _isValid => _allocations.isNotEmpty && (_totalAlloc - 100.0).abs() < 0.1;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FlowScaffold(
      title: 'Destination',
      currentStep: 3,
      totalSteps: 6,
      primaryLabel: 'Set Amount',
      primaryEnabled: _isValid,
      onPrimary: () => context.go(AppRoutes.transferAmount),
      onBack: () => context.go(AppRoutes.transferSource),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Destination Funds',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Choose where to move your funds and set the allocation percentage for each.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),

          // Allocation summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isValid
                  ? AppColors.successBg
                  : _totalAlloc > 100
                      ? AppColors.dangerBg
                      : AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isValid
                    ? AppColors.success.withValues(alpha: 0.3)
                    : _totalAlloc > 100
                        ? AppColors.danger.withValues(alpha: 0.3)
                        : AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _isValid ? Icons.check_circle : Icons.pie_chart_outline,
                  color: _isValid ? AppColors.success : _totalAlloc > 100 ? AppColors.danger : AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  'Total Allocation: ${_totalAlloc.toStringAsFixed(0)}% / 100%',
                  style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: _isValid ? AppColors.success : _totalAlloc > 100 ? AppColors.danger : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Available Destination Funds',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 14),
                ..._availableFunds.map((fund) {
                  final alloc = _allocations[fund.$1] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8, height: 8,
                              decoration: BoxDecoration(color: fund.$4, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(fund.$1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                  Text(fund.$3, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                                ],
                              ),
                            ),
                            Text('${alloc.toStringAsFixed(0)}%',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                          ],
                        ),
                        Slider(
                          value: alloc, min: 0, max: 100,
                          divisions: 20,
                          activeColor: fund.$4,
                          onChanged: (v) => setState(() => _allocations[fund.$1] = v),
                        ),
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
