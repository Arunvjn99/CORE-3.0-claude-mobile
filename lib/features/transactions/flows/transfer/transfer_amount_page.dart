import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class TransferAmountPage extends StatefulWidget {
  const TransferAmountPage({super.key});

  @override
  State<TransferAmountPage> createState() => _TransferAmountPageState();
}

class _TransferAmountPageState extends State<TransferAmountPage> {
  String _amountType = 'full';
  double _partialAmount = 5000;
  static const _sourceBalance = 12000;

  double get _transferAmount => _amountType == 'full' ? _sourceBalance.toDouble() : _partialAmount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FlowScaffold(
      title: 'Transfer Amount',
      currentStep: 4,
      totalSteps: 6,
      primaryLabel: 'View Impact',
      onPrimary: () => context.go(AppRoutes.transferImpact),
      onBack: () => context.go(AppRoutes.transferDestination),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Set Transfer Amount',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Specify how much you\'d like to transfer from your selected funds.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),

          // Summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Text('Transfer Amount', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                const SizedBox(height: 4),
                Text(
                  '\$${_transferAmount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.primary),
                ),
                Text(
                  'from Large Cap Equity Fund (LCEF)',
                  style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amount Type',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 14),
                _AmountOption(
                  value: 'full', groupValue: _amountType,
                  label: 'Full Balance Transfer',
                  description: 'Transfer the entire fund balance (\$$_sourceBalance)',
                  onChanged: (v) => setState(() => _amountType = v!),
                ),
                const SizedBox(height: 10),
                _AmountOption(
                  value: 'partial', groupValue: _amountType,
                  label: 'Partial Amount',
                  description: 'Choose a specific dollar amount to transfer',
                  onChanged: (v) => setState(() => _amountType = v!),
                ),
                if (_amountType == 'partial') ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Amount', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text('\$${_partialAmount.toInt()}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      Text('of \$$_sourceBalance available', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                    ],
                  ),
                  Slider(
                    value: _partialAmount,
                    min: 100,
                    max: _sourceBalance.toDouble(),
                    divisions: 119,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setState(() => _partialAmount = v),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$100 min', style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
                      Text('\$$_sourceBalance max', style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.access_time, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Transfers execute at the next market close (typically 4:00 PM ET). Prices are based on end-of-day NAV.',
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

class _AmountOption extends StatelessWidget {
  final String value, groupValue, label, description;
  final ValueChanged<String?> onChanged;

  const _AmountOption({
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
                  Text(description, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
