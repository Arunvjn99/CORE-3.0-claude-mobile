import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class WithdrawalPaymentPage extends StatefulWidget {
  const WithdrawalPaymentPage({super.key});

  @override
  State<WithdrawalPaymentPage> createState() => _WithdrawalPaymentPageState();
}

class _WithdrawalPaymentPageState extends State<WithdrawalPaymentPage> {
  String _method = 'eft';
  String _bankAccount = 'chase-1234';
  String _addressType = 'employee';
  bool _addBankOpen = false;

  final _accountController = TextEditingController();
  final _routingController = TextEditingController();
  String _accountType = 'checking';

  bool get _canContinue {
    if (_method == 'eft') return true;
    if (_method == 'check' && _addressType == 'employee') return true;
    return false;
  }

  @override
  void dispose() {
    _accountController.dispose();
    _routingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Payment Method',
      currentStep: 5,
      totalSteps: 6,
      primaryLabel: 'Continue to Review',
      primaryEnabled: _canContinue,
      onPrimary: () => context.go(AppRoutes.withdrawalReview),
      onBack: () => context.go(AppRoutes.withdrawalFees),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payment Method',
              style: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
          const SizedBox(height: 8),
          const Text('Choose how you want to receive your withdrawal funds.',
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.lightTextSecondary)),
          const SizedBox(height: 20),

          // Disbursement method
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
                const Text('Disbursement Method',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                const SizedBox(height: 12),
                _MethodOption(
                  value: 'eft', groupValue: _method, label: 'Electronic Funds Transfer (EFT)',
                  description: 'Funds typically arrive in 2-3 business days',
                  onChanged: (v) => setState(() => _method = v!),
                ),
                const SizedBox(height: 8),
                _MethodOption(
                  value: 'check', groupValue: _method, label: 'Mail Check',
                  description: 'Check will be mailed to your address (7-10 business days)',
                  onChanged: (v) => setState(() => _method = v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Bank account (EFT)
          if (_method == 'eft') ...[
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
                  const Text('Bank Account',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _bankAccount,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.account_balance)),
                    items: const [
                      DropdownMenuItem(value: 'chase-1234', child: Text('Chase Bank - ****1234 (Checking)')),
                      DropdownMenuItem(value: 'bofa-5678', child: Text('Bank of America - ****5678 (Savings)')),
                      DropdownMenuItem(value: 'add-new', child: Text('+ Add New Bank Account')),
                    ],
                    onChanged: (v) => setState(() { _bankAccount = v!; _addBankOpen = v == 'add-new'; }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Add new bank account
            if (_bankAccount == 'add-new')
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => setState(() => _addBankOpen = !_addBankOpen),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(color: AppColors.iconBgGreen, borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.account_balance, color: AppColors.success, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('New Bank Account Details',
                                      style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary)),
                                  const Text('Account number, routing number, and type',
                                      style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.lightTextSecondary)),
                                ],
                              ),
                            ),
                            AnimatedRotation(
                              turns: _addBankOpen ? 0.5 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: const Icon(Icons.keyboard_arrow_down, color: AppColors.lightTextSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_addBankOpen) ...[
                      Divider(height: 1, color: AppColors.lightBorder),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _accountController,
                              decoration: const InputDecoration(
                                labelText: 'Bank Account Number',
                                hintText: 'Enter account number',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _routingController,
                              decoration: const InputDecoration(
                                labelText: 'Routing Number',
                                hintText: '9-digit routing number',
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 9,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              value: _accountType,
                              decoration: const InputDecoration(labelText: 'Account Type'),
                              items: const [
                                DropdownMenuItem(value: 'checking', child: Text('Checking')),
                                DropdownMenuItem(value: 'savings', child: Text('Savings')),
                              ],
                              onChanged: (v) => setState(() => _accountType = v!),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.iconBgBlue,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                              ),
                              child: const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.info_outline, size: 14, color: AppColors.primary),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'A micro-deposit verification may be required. Two small deposits will be sent to your account within 1-2 business days for verification.',
                                      style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.primary, height: 1.4),
                                    ),
                                  ),
                                ],
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

          // Mailing address (Check)
          if (_method == 'check') ...[
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
                  const Text('Mailing Address',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                  const SizedBox(height: 12),
                  _MethodOption(
                    value: 'employee', groupValue: _addressType,
                    label: 'Use Employee Address on File',
                    description: '123 Main Street, Apt 4B\nNew York, NY 10001',
                    onChanged: (v) => setState(() => _addressType = v!),
                  ),
                  const SizedBox(height: 8),
                  _MethodOption(
                    value: 'custom', groupValue: _addressType,
                    label: 'Use Custom Address',
                    description: 'Enter a different mailing address',
                    onChanged: (v) => setState(() => _addressType = v!),
                  ),
                  if (_addressType == 'custom') ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Street Address'),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: TextFormField(decoration: const InputDecoration(labelText: 'City'))),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: 'State'),
                            inputFormatters: [LengthLimitingTextInputFormatter(2)],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'ZIP Code'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(5)],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MethodOption extends StatelessWidget {
  final String value;
  final String groupValue;
  final String label;
  final String description;
  final ValueChanged<String?> onChanged;

  const _MethodOption({
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
                  Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary)),
                  const SizedBox(height: 2),
                  Text(description, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.lightTextSecondary, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
