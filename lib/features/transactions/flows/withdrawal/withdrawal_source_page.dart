import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class WithdrawalSourcePage extends StatefulWidget {
  const WithdrawalSourcePage({super.key});

  @override
  State<WithdrawalSourcePage> createState() => _WithdrawalSourcePageState();
}

class _WithdrawalSourcePageState extends State<WithdrawalSourcePage> {
  double _pretax = 2000;
  double _roth = 500;
  double _employer = 0;
  double _aftertax = 500;
  bool _advancedOpen = false;
  String _grossNet = 'gross';

  double get _total => _pretax + _roth + _employer + _aftertax;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FlowScaffold(
      title: 'Source of Funds',
      currentStep: 3,
      totalSteps: 6,
      primaryLabel: 'Continue to Fees',
      primaryEnabled: _total > 0,
      onPrimary: () => context.go(AppRoutes.withdrawalFees),
      onBack: () => context.go(AppRoutes.withdrawalType),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Withdrawal Source',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Choose where your funds come from. Different sources have different tax implications.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),

          // Total summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Text('Total Withdrawal Amount',
                    style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                const SizedBox(height: 4),
                Text('\$${_total.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.primary)),
                Text(_grossNet == 'gross' ? 'Gross amount' : 'Net amount',
                    style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Source sliders
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contribution Sources',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 20),
                _SourceSlider(
                  label: 'Pre-Tax Contributions',
                  sublabel: 'Traditional 401(k) deferrals',
                  taxNote: 'Subject to ordinary income tax',
                  value: _pretax,
                  max: 3500,
                  onChanged: (v) => setState(() => _pretax = v),
                ),
                const SizedBox(height: 20),
                _SourceSlider(
                  label: 'Roth Contributions',
                  sublabel: 'After-tax Roth 401(k) deferrals',
                  taxNote: 'Tax-free if qualified distribution',
                  value: _roth,
                  max: 1200,
                  onChanged: (v) => setState(() => _roth = v),
                ),
                const SizedBox(height: 20),
                _SourceSlider(
                  label: 'Employer Contributions',
                  sublabel: 'Matching and profit sharing',
                  taxNote: 'Subject to ordinary income tax',
                  value: _employer,
                  max: 2000,
                  onChanged: (v) => setState(() => _employer = v),
                ),
                const SizedBox(height: 20),
                _SourceSlider(
                  label: 'After-Tax Contributions',
                  sublabel: 'Non-Roth after-tax deferrals',
                  taxNote: 'Only earnings portion is taxable',
                  value: _aftertax,
                  max: 800,
                  onChanged: (v) => setState(() => _aftertax = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Advanced settings (collapsible)
          AppCard(
            noPadding: true,
            child: Column(
              children: [
                InkWell(
                  onTap: () => setState(() => _advancedOpen = !_advancedOpen),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.chartPurple.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.tune, color: AppColors.chartPurple, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Advanced Settings',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              Text('Gross vs Net election and other options',
                                  style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        AnimatedRotation(
                          turns: _advancedOpen ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(Icons.keyboard_arrow_down, color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_advancedOpen) ...[
                  Divider(height: 1, color: scheme.outline.withValues(alpha: 0.3)),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Gross vs Net Election',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        _RadioOption(
                          value: 'gross', groupValue: _grossNet,
                          label: 'Gross Amount',
                          description: 'The total amount withdrawn before taxes and fees are deducted. You\'ll receive less than this amount.',
                          onChanged: (v) => setState(() => _grossNet = v!),
                        ),
                        const SizedBox(height: 8),
                        _RadioOption(
                          value: 'net', groupValue: _grossNet,
                          label: 'Net Amount',
                          description: 'The amount you want to receive after taxes and fees. A larger gross amount will be withdrawn.',
                          onChanged: (v) => setState(() => _grossNet = v!),
                        ),
                        if (_grossNet == 'net') ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.info_outline, size: 14, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Estimated gross: \$${(_total / 0.85).round()} to deliver \$${_total.toInt()} net after taxes and fees.',
                                    style: const TextStyle(fontSize: 11, color: AppColors.primary, height: 1.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceSlider extends StatelessWidget {
  final String label;
  final String sublabel;
  final String taxNote;
  final double value;
  final double max;
  final ValueChanged<double> onChanged;

  const _SourceSlider({
    required this.label, required this.sublabel, required this.taxNote,
    required this.value, required this.max, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  Text(sublabel, style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${value.toInt()}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                Text('of \$${max.toInt()} available', style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
              ],
            ),
          ],
        ),
        Slider(
          value: value, min: 0, max: max, divisions: (max / 100).round(),
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
        Row(
          children: [
            const Icon(Icons.info_outline, size: 12, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(taxNote, style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
          ],
        ),
      ],
    );
  }
}

class _RadioOption extends StatelessWidget {
  final String value;
  final String groupValue;
  final String label;
  final String description;
  final ValueChanged<String?> onChanged;

  const _RadioOption({
    required this.value, required this.groupValue,
    required this.label, required this.description, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? AppColors.primary : scheme.outline),
          color: selected ? AppColors.primary.withValues(alpha: 0.05) : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(description, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
