import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class RolloverPlanPage extends StatefulWidget {
  const RolloverPlanPage({super.key});

  @override
  State<RolloverPlanPage> createState() => _RolloverPlanPageState();
}

class _RolloverPlanPageState extends State<RolloverPlanPage> {
  String _rolloverType = 'direct';
  final _planNameController = TextEditingController();
  final _planIdController = TextEditingController();
  final _amountController = TextEditingController();

  bool get _canContinue =>
      _planNameController.text.isNotEmpty && _amountController.text.isNotEmpty;

  @override
  void dispose() {
    _planNameController.dispose();
    _planIdController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Plan Details',
      currentStep: 1,
      totalSteps: 5,
      primaryLabel: 'Validate Plan',
      primaryEnabled: _canContinue,
      onPrimary: () => context.go(AppRoutes.rolloverValidation),
      onBack: () => context.go(AppRoutes.transactions),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('External Plan Details',
              style: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
          const SizedBox(height: 8),
          const Text('Enter the details of the external retirement plan you\'d like to roll over.',
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.lightTextSecondary)),
          const SizedBox(height: 20),

          // Rollover type
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
                const Text('Rollover Type',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                const SizedBox(height: 12),
                _TypeOption(
                  value: 'direct', groupValue: _rolloverType,
                  label: 'Direct Rollover',
                  description: 'Funds transfer directly between institutions. No tax withholding.',
                  icon: Icons.swap_horiz,
                  color: AppColors.success,
                  onChanged: (v) => setState(() => _rolloverType = v!),
                ),
                const SizedBox(height: 8),
                _TypeOption(
                  value: 'indirect', groupValue: _rolloverType,
                  label: 'Indirect Rollover (60-Day)',
                  description: 'You receive the funds and must redeposit within 60 days. 20% withheld for taxes.',
                  icon: Icons.schedule,
                  color: AppColors.warning,
                  onChanged: (v) => setState(() => _rolloverType = v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (_rolloverType == 'indirect')
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.warningBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.warning_amber, size: 16, color: AppColors.warning),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'With an indirect rollover, your current plan will withhold 20% for taxes. You must deposit 100% of the original amount within 60 days to avoid taxes and penalties.',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.warning, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),

          // Plan info form
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
                const Text('Plan Information',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _planNameController,
                  decoration: const InputDecoration(
                    labelText: 'Previous Employer / Plan Name *',
                    hintText: 'e.g., Acme Corporation 401(k)',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _planIdController,
                  decoration: const InputDecoration(
                    labelText: 'Plan ID / Account Number (optional)',
                    hintText: 'Enter plan identifier',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Estimated Rollover Amount *',
                    hintText: '0.00',
                    prefixText: '\$',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: 'traditional-401k',
                  decoration: const InputDecoration(labelText: 'Account Type'),
                  items: const [
                    DropdownMenuItem(value: 'traditional-401k', child: Text('Traditional 401(k)')),
                    DropdownMenuItem(value: 'roth-401k', child: Text('Roth 401(k)')),
                    DropdownMenuItem(value: 'traditional-ira', child: Text('Traditional IRA')),
                    DropdownMenuItem(value: 'roth-ira', child: Text('Roth IRA')),
                    DropdownMenuItem(value: '403b', child: Text('403(b)')),
                    DropdownMenuItem(value: '457', child: Text('457(b)')),
                  ],
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.iconBgBlue,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Rollovers from traditional accounts to Roth accounts are taxable events. Rollovers between accounts of the same type (traditional to traditional, Roth to Roth) are generally tax-free.',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.primary, height: 1.4),
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

class _TypeOption extends StatelessWidget {
  final String value, groupValue, label, description;
  final IconData icon;
  final Color color;
  final ValueChanged<String?> onChanged;

  const _TypeOption({
    required this.value, required this.groupValue,
    required this.label, required this.description,
    required this.icon, required this.color, required this.onChanged,
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
          border: Border.all(color: selected ? color : AppColors.lightBorder, width: selected ? 1.5 : 1),
          color: selected ? color.withValues(alpha: 0.05) : Colors.white,
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value, groupValue: groupValue, onChanged: onChanged,
              activeColor: color,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 8),
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
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
