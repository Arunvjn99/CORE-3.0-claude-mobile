import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/flow_scaffold.dart';

class LoanConfigurationPage extends StatefulWidget {
  const LoanConfigurationPage({super.key});
  @override
  State<LoanConfigurationPage> createState() => _LoanConfigurationPageState();
}

class _LoanConfigurationPageState extends State<LoanConfigurationPage> {
  String _disbursement = 'eft';
  String _bankAccount = 'chase-1234';
  String _repaymentMethod = 'payroll';
  String _periodicPayment = '100.00';
  String _repaymentDate = '2026-05-30';
  bool _showAmortization = false;
  bool _showNewBankForm = false;

  final _accountCtrl = TextEditingController();
  final _routingCtrl = TextEditingController();
  String _accountType = 'checking';

  static const double _loanAmount = 5000;
  static const int _tenure = 3;
  static const double _rate = 5.5;
  double get _totalInterest => _loanAmount * _rate / 100 * _tenure;
  double get _totalPayback => _loanAmount + _totalInterest;
  int get _totalPayments => _tenure * 12;

  bool get _canContinue => _disbursement == 'check' || _bankAccount.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Loan Configuration',
      currentStep: 3,
      totalSteps: 6,
      primaryLabel: 'Continue to Fees',
      primaryEnabled: _canContinue,
      onPrimary: () => context.go(AppRoutes.loanFees),
      onBack: () => context.go(AppRoutes.loanSimulator),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Loan Configuration',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.lightTextPrimary),
          ),
          const SizedBox(height: 4),
          const Text(
            'Set up disbursement and repayment for your loan.',
            style: TextStyle(fontSize: 13, color: AppColors.lightTextSecondary, height: 1.5),
          ),
          const SizedBox(height: 4),
          Text(
            'Processing time: ~10 business days',
            style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.lightTextMuted),
          ),
          const SizedBox(height: 20),

          // Loan Summary Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                _SummaryCell(label: 'AMOUNT', value: '\$${_loanAmount.toStringAsFixed(0)}'),
                _divider(),
                _SummaryCell(label: 'TENURE', value: '$_tenure Years'),
                _divider(),
                _SummaryCell(label: 'RATE', value: '${_rate.toStringAsFixed(1)}%'),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.go(AppRoutes.loanSimulator),
                  child: Text('Edit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Payment Method Section
          const Text('PAYMENT METHOD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.lightTextSecondary, letterSpacing: 0.8)),
          const SizedBox(height: 12),
          _DisbursementOption(
            value: 'eft',
            groupValue: _disbursement,
            title: 'Electronic Funds Transfer (EFT)',
            subtitle: 'Direct deposit to your bank account',
            onChanged: (v) => setState(() => _disbursement = v),
          ),
          const SizedBox(height: 8),
          _DisbursementOption(
            value: 'check',
            groupValue: _disbursement,
            title: 'Mail check to address',
            subtitle: 'Physical check mailed to your address',
            onChanged: (v) => setState(() => _disbursement = v),
          ),

          if (_disbursement == 'eft') ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E8FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFD8B4FE).withValues(alpha: 0.5)),
              ),
              child: const Row(
                children: [
                  Text('⚡', style: TextStyle(fontSize: 14)),
                  SizedBox(width: 8),
                  Text('EFT recommended — funds arrive in 2–3 days', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF7C3AED))),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _bankAccount,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary),
                  items: const [
                    DropdownMenuItem(value: 'chase-1234', child: Text('Chase Bank - ****1234')),
                    DropdownMenuItem(value: 'bofa-5678', child: Text('Bank of America - ****5678')),
                    DropdownMenuItem(value: 'wells-9012', child: Text('Wells Fargo - ****9012')),
                    DropdownMenuItem(value: 'add-new', child: Text('+ Add New Bank Account')),
                  ],
                  onChanged: (v) => setState(() {
                    _bankAccount = v!;
                    _showNewBankForm = v == 'add-new';
                  }),
                ),
              ),
            ),
          ],

          if (_showNewBankForm && _disbursement == 'eft') ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [
                    Icon(Icons.account_balance, color: AppColors.success, size: 18),
                    SizedBox(width: 8),
                    Text('New Bank Account', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  ]),
                  const SizedBox(height: 14),
                  _FormField(label: 'Account Number', controller: _accountCtrl, hint: 'Enter account number'),
                  const SizedBox(height: 12),
                  _FormField(label: 'Routing Number', controller: _routingCtrl, hint: '9-digit routing number', maxLength: 9),
                  const SizedBox(height: 12),
                  const Text('Account Type', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Row(children: [
                    _TypeChip(label: 'Checking', selected: _accountType == 'checking', onTap: () => setState(() => _accountType = 'checking')),
                    const SizedBox(width: 8),
                    _TypeChip(label: 'Savings', selected: _accountType == 'savings', onTap: () => setState(() => _accountType = 'savings')),
                  ]),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Repayment Method Section
          const Text('REPAYMENT METHOD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.lightTextSecondary, letterSpacing: 0.8)),
          const SizedBox(height: 12),
          Row(
            children: [
              _RepaymentCard(emoji: '💳', title: 'Payroll', subtitle: 'From paycheck', value: 'payroll', groupValue: _repaymentMethod, onTap: () => setState(() => _repaymentMethod = 'payroll')),
              const SizedBox(width: 8),
              _RepaymentCard(emoji: '🏦', title: 'ACH', subtitle: 'Bank transfer', value: 'ach', groupValue: _repaymentMethod, onTap: () => setState(() => _repaymentMethod = 'ach')),
              const SizedBox(width: 8),
              _RepaymentCard(emoji: '↔', title: 'Manual', subtitle: 'You initiate', value: 'manual', groupValue: _repaymentMethod, onTap: () => setState(() => _repaymentMethod = 'manual')),
            ],
          ),
          const SizedBox(height: 16),

          // Payment & Date Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Periodic Payment', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.lightBorder)),
                      child: Row(
                        children: [
                          Container(
                            width: 38, height: 42,
                            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: const BorderRadius.horizontal(left: Radius.circular(10))),
                            child: const Icon(Icons.attach_money, color: AppColors.primary, size: 18),
                          ),
                          Expanded(
                            child: TextFormField(
                              initialValue: _periodicPayment,
                              keyboardType: TextInputType.number,
                              onChanged: (v) => setState(() => _periodicPayment = v),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('Minimum: \$0.80', style: TextStyle(fontSize: 10, color: AppColors.lightTextMuted)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('First Repayment', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.lightBorder)),
                      child: Row(
                        children: [
                          Container(
                            width: 38, height: 42,
                            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: const BorderRadius.horizontal(left: Radius.circular(10))),
                            child: const Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 16),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2026, 5, 30),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2027, 12, 31),
                                );
                                if (date != null) {
                                  setState(() => _repaymentDate = '${date.month}/${date.day}/${date.year}');
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Text(_repaymentDate, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Amortization Preview
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _showAmortization = !_showAmortization),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Amortization', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                              Text('Preview schedule and totals', style: TextStyle(fontSize: 11, color: AppColors.lightTextSecondary)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: AppColors.primary),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_showAmortization ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.primary, size: 16),
                              const SizedBox(width: 4),
                              Text(_showAmortization ? 'Hide' : 'Show', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_showAmortization) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.bar_chart, color: AppColors.primary, size: 14),
                          const SizedBox(width: 6),
                          const Text('Amortization preview', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                        ]),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _AmortStat(label: 'Total repayment', value: '\$${_totalPayback.toStringAsFixed(0)}'),
                            const SizedBox(width: 8),
                            _AmortStat(label: 'Total interest', value: '\$${_totalInterest.toStringAsFixed(0)}', highlight: true),
                            const SizedBox(width: 8),
                            _AmortStat(label: 'Payments', value: '$_totalPayments'),
                          ],
                        ),
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

  Widget _divider() => Container(width: 1, height: 28, color: AppColors.primary.withValues(alpha: 0.2), margin: const EdgeInsets.symmetric(horizontal: 10));
}

class _SummaryCell extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.lightTextSecondary, letterSpacing: 0.5)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.lightTextPrimary)),
      ],
    );
  }
}

class _DisbursementOption extends StatelessWidget {
  final String value;
  final String groupValue;
  final String title;
  final String subtitle;
  final ValueChanged<String> onChanged;
  const _DisbursementOption({required this.value, required this.groupValue, required this.title, required this.subtitle, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.primary : AppColors.lightBorder, width: selected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Radio<String>(value: value, groupValue: groupValue, onChanged: (v) => onChanged(v!), activeColor: AppColors.primary, materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, visualDensity: VisualDensity.compact),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 13, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: AppColors.lightTextPrimary)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.lightTextSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RepaymentCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String value;
  final String groupValue;
  final VoidCallback onTap;
  const _RepaymentCard({required this.emoji, required this.title, required this.subtitle, required this.value, required this.groupValue, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary.withValues(alpha: 0.06) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? AppColors.primary : AppColors.lightBorder, width: selected ? 2 : 1),
          ),
          child: Column(
            children: [
              if (selected) Align(alignment: Alignment.topRight, child: Padding(padding: const EdgeInsets.only(right: 6), child: Container(width: 16, height: 16, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle), child: const Icon(Icons.check, color: Colors.white, size: 10)))),
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
              Text(subtitle, style: const TextStyle(fontSize: 9, color: AppColors.lightTextSecondary), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final int? maxLength;
  const _FormField({required this.label, required this.controller, required this.hint, this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLength: maxLength,
          style: const TextStyle(fontSize: 13, fontFamily: 'monospace', fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.lightTextMuted, fontFamily: 'Inter'),
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.lightBorder)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          ),
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TypeChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? AppColors.primary : AppColors.lightBorder),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? AppColors.primary : AppColors.lightTextPrimary)),
      ),
    );
  }
}

class _AmortStat extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  const _AmortStat({required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.lightBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: AppColors.lightTextMuted)),
            const SizedBox(height: 2),
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: highlight ? AppColors.primary : AppColors.lightTextPrimary)),
          ],
        ),
      ),
    );
  }
}
