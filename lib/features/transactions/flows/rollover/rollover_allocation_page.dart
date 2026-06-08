import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class RolloverAllocationPage extends StatefulWidget {
  const RolloverAllocationPage({super.key});

  @override
  State<RolloverAllocationPage> createState() => _RolloverAllocationPageState();
}

class _RolloverAllocationPageState extends State<RolloverAllocationPage> {
  String _strategy = 'existing';

  final _customAlloc = <String, double>{
    'Large Cap Equity Fund': 40,
    'International Growth Fund': 25,
    'Stable Value Bond Fund': 20,
    'Target Date 2050 Fund': 15,
  };

  static const _colors = {
    'Large Cap Equity Fund': AppColors.primary,
    'International Growth Fund': AppColors.chartPurple,
    'Stable Value Bond Fund': AppColors.success,
    'Target Date 2050 Fund': AppColors.chartOrange,
  };

  double get _total => _customAlloc.values.fold(0, (s, v) => s + v);
  bool get _isValid => _strategy != 'custom' || (_total - 100.0).abs() < 0.1;

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Allocation',
      currentStep: 3,
      totalSteps: 5,
      primaryLabel: 'Upload Documents',
      primaryEnabled: _isValid,
      onPrimary: () => context.go(AppRoutes.rolloverDocuments),
      onBack: () => context.go(AppRoutes.rolloverValidation),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rollover Allocation',
              style: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
          const SizedBox(height: 8),
          const Text('Choose how the rolled-over funds (\$45,000) will be invested.',
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.lightTextSecondary)),
          const SizedBox(height: 20),

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
                const Text('Allocation Strategy',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                const SizedBox(height: 12),
                _StrategyOption(
                  value: 'existing', groupValue: _strategy,
                  label: 'Match Current Allocation',
                  description: 'Invest using your current fund allocation (40% LCEF, 25% IGRF, 20% SVBF, 15% TD50)',
                  onChanged: (v) => setState(() => _strategy = v!),
                ),
                const SizedBox(height: 8),
                _StrategyOption(
                  value: 'target-date', groupValue: _strategy,
                  label: 'Target Date Fund',
                  description: 'Invest entirely in Target Date 2050 Fund — auto-adjusts risk over time',
                  onChanged: (v) => setState(() => _strategy = v!),
                ),
                const SizedBox(height: 8),
                _StrategyOption(
                  value: 'custom', groupValue: _strategy,
                  label: 'Custom Allocation',
                  description: 'Set your own percentages across available funds',
                  onChanged: (v) => setState(() => _strategy = v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (_strategy == 'custom') ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: _isValid ? AppColors.successBg : AppColors.warningBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _isValid ? AppColors.success.withValues(alpha: 0.3) : AppColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(_isValid ? Icons.check_circle : Icons.pie_chart_outline,
                      size: 16, color: _isValid ? AppColors.success : AppColors.warning),
                  const SizedBox(width: 8),
                  Text('Total: ${_total.toStringAsFixed(0)}% / 100%',
                      style: TextStyle(
                        fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700,
                        color: _isValid ? AppColors.success : AppColors.warning,
                      )),
                  const Spacer(),
                  if (!_isValid)
                    TextButton(
                      onPressed: () {
                        final keys = _customAlloc.keys.toList();
                        final n = keys.length;
                        final base = 100 ~/ n;
                        final rem = 100 - base * n;
                        setState(() {
                          for (int i = 0; i < n; i++) {
                            _customAlloc[keys[i]] = (base + (i < rem ? 1 : 0)).toDouble();
                          }
                        });
                      },
                      child: const Text('Auto', style: TextStyle(fontFamily: 'Inter', fontSize: 12)),
                    ),
                ],
              ),
            ),

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
                  const Text('Custom Allocation',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary)),
                  const SizedBox(height: 14),
                  ..._customAlloc.entries.map((e) {
                    final color = _colors[e.key] ?? AppColors.primary;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                              const SizedBox(width: 8),
                              Expanded(child: Text(e.key,
                                  style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary))),
                              Text('${e.value.toInt()}%',
                                  style: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.lightTextPrimary)),
                            ],
                          ),
                          Slider(
                            value: e.value, min: 0, max: 100, divisions: 100,
                            activeColor: color,
                            onChanged: (v) => setState(() => _customAlloc[e.key] = v),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],

          if (_strategy == 'existing' || _strategy == 'target-date') ...[
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
                  if (_strategy == 'existing') ...[
                    ('Large Cap Equity Fund', 40.0, AppColors.primary),
                    ('International Growth Fund', 25.0, AppColors.chartPurple),
                    ('Stable Value Bond Fund', 20.0, AppColors.success),
                    ('Target Date 2050 Fund', 15.0, AppColors.chartOrange),
                  ].map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: f.$3, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(f.$1, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.lightTextPrimary))),
                        Text('${f.$2.toInt()}%', style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                      ],
                    ),
                  )).toList(),
                  if (_strategy == 'target-date')
                    Row(
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.chartOrange, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        const Expanded(child: Text('Target Date 2050 Fund',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.lightTextPrimary))),
                        const Text('100%', style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                      ],
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

class _StrategyOption extends StatelessWidget {
  final String value, groupValue, label, description;
  final ValueChanged<String?> onChanged;

  const _StrategyOption({
    required this.value, required this.groupValue,
    required this.label, required this.description, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.primary : AppColors.lightBorder, width: selected ? 1.5 : 1),
          color: selected ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value, groupValue: groupValue, onChanged: onChanged,
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary)),
                  Text(description, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.lightTextSecondary, height: 1.3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
