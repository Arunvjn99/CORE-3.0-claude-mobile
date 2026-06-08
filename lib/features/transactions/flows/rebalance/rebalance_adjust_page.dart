import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class RebalanceAdjustPage extends StatefulWidget {
  const RebalanceAdjustPage({super.key});

  @override
  State<RebalanceAdjustPage> createState() => _RebalanceAdjustPageState();
}

class _RebalanceAdjustPageState extends State<RebalanceAdjustPage> {
  final _allocations = <String, double>{
    'Large Cap Equity Fund': 35,
    'International Growth Fund': 25,
    'Stable Value Bond Fund': 25,
    'Target Date 2050 Fund': 15,
  };

  static const _colors = {
    'Large Cap Equity Fund': AppColors.primary,
    'International Growth Fund': AppColors.chartPurple,
    'Stable Value Bond Fund': AppColors.success,
    'Target Date 2050 Fund': AppColors.chartOrange,
  };

  double get _total => _allocations.values.fold(0, (s, v) => s + v);
  bool get _isValid => (_total - 100.0).abs() < 0.1;

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Adjust Allocation',
      currentStep: 2,
      totalSteps: 4,
      primaryLabel: 'Preview Trades',
      primaryEnabled: _isValid,
      onPrimary: () => context.go(AppRoutes.rebalanceTrades),
      onBack: () => context.go(AppRoutes.rebalance),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Adjust Allocation',
              style: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
          const SizedBox(height: 8),
          const Text('Set your target allocation percentages. They must add up to 100%.',
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.lightTextSecondary)),
          const SizedBox(height: 20),

          // Total indicator
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _isValid ? AppColors.successBg : _total > 100 ? AppColors.dangerBg : AppColors.warningBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isValid
                    ? AppColors.success.withValues(alpha: 0.3)
                    : _total > 100
                        ? AppColors.danger.withValues(alpha: 0.3)
                        : AppColors.warning.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _isValid ? Icons.check_circle : Icons.pie_chart_outline,
                  size: 18,
                  color: _isValid ? AppColors.success : _total > 100 ? AppColors.danger : AppColors.warning,
                ),
                const SizedBox(width: 10),
                Text(
                  'Total: ${_total.toStringAsFixed(0)}% / 100%',
                  style: TextStyle(
                    fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700,
                    color: _isValid ? AppColors.success : _total > 100 ? AppColors.danger : AppColors.warning,
                  ),
                ),
                const Spacer(),
                if (!_isValid)
                  TextButton(
                    onPressed: _autoBalance,
                    child: const Text('Auto-balance', style: TextStyle(fontFamily: 'Inter', fontSize: 12)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Allocation sliders
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
                const Text('Target Allocation',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                const SizedBox(height: 16),
                ..._allocations.entries.map((e) {
                  final color = _colors[e.key] ?? AppColors.primary;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            Expanded(child: Text(e.key,
                                style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary))),
                            Text('${e.value.toInt()}%',
                                style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.lightTextPrimary)),
                          ],
                        ),
                        Slider(
                          value: e.value, min: 0, max: 100, divisions: 100,
                          activeColor: color,
                          onChanged: (v) => setState(() => _allocations[e.key] = v),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Visual bar
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
                const Text('Allocation Preview',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary)),
                const SizedBox(height: 12),
                if (_total > 0)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Row(
                      children: _allocations.entries.where((e) => e.value > 0).map((e) => Expanded(
                        flex: e.value.round(),
                        child: Container(height: 16, color: _colors[e.key] ?? AppColors.primary),
                      )).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _autoBalance() {
    final keys = _allocations.keys.toList();
    final n = keys.length;
    final base = 100 ~/ n;
    final rem = 100 - base * n;
    setState(() {
      for (int i = 0; i < n; i++) {
        _allocations[keys[i]] = (base + (i < rem ? 1 : 0)).toDouble();
      }
    });
  }
}
