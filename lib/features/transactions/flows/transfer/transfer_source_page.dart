import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class TransferSourcePage extends StatefulWidget {
  const TransferSourcePage({super.key});

  @override
  State<TransferSourcePage> createState() => _TransferSourcePageState();
}

class _TransferSourcePageState extends State<TransferSourcePage> {
  final _funds = [
    _Fund('lcef', 'Large Cap Equity Fund', 'LCEF', 12000, 40, 12.4, AppColors.primary),
    _Fund('igrf', 'International Growth Fund', 'IGRF', 7500, 25, 8.7, AppColors.chartPurple),
    _Fund('svbf', 'Stable Value Bond Fund', 'SVBF', 6000, 20, 3.2, AppColors.success),
    _Fund('td50', 'Target Date 2050 Fund', 'TD50', 4500, 15, 9.1, AppColors.chartOrange),
  ];

  Set<String> _selected = {};

  int get _totalSelected => _funds.where((f) => _selected.contains(f.id)).fold(0, (s, f) => s + f.balance);

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Source Funds',
      currentStep: 2,
      totalSteps: 6,
      primaryLabel: 'Select Destination',
      primaryEnabled: _selected.isNotEmpty,
      onPrimary: () => context.go(AppRoutes.transferDestination),
      onBack: () => context.go(AppRoutes.transfer),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Source Funds',
              style: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
          const SizedBox(height: 8),
          const Text('Choose which investment funds you\'d like to transfer money from.',
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.lightTextSecondary)),
          const SizedBox(height: 20),

          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('SELECTED FOR TRANSFER',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.lightTextSecondary, letterSpacing: 0.5)),
                      Text('${_selected.length} fund${_selected.length == 1 ? '' : 's'}',
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.lightTextPrimary)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('AVAILABLE BALANCE',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.lightTextSecondary, letterSpacing: 0.5)),
                    Text('\$${_totalSelected.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.lightTextPrimary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Fund list
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
                const Text('Your Investment Funds',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                const SizedBox(height: 14),
                ..._funds.map((fund) {
                  final isSelected = _selected.contains(fund.id);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        if (isSelected) _selected.remove(fund.id);
                        else _selected.add(fund.id);
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected ? fund.color.withValues(alpha: 0.05) : AppColors.lightShell,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? fund.color : AppColors.lightBorder,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isSelected,
                              onChanged: (_) {
                                setState(() {
                                  if (isSelected) _selected.remove(fund.id);
                                  else _selected.add(fund.id);
                                });
                              },
                              activeColor: fund.color,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                            const SizedBox(width: 8),
                            Container(width: 10, height: 10, decoration: BoxDecoration(color: fund.color, shape: BoxShape.circle)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: Text(fund.name,
                                          style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary))),
                                      Text(fund.ticker,
                                          style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: AppColors.lightTextSecondary)),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Text('${fund.allocation}% of portfolio',
                                          style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.lightTextSecondary)),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.trending_up, size: 12, color: AppColors.success),
                                      Text('+${fund.ytdReturn}% YTD',
                                          style: const TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text('\$${fund.balance.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                                style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                          ],
                        ),
                      ),
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

class _Fund {
  final String id, name, ticker;
  final int balance, allocation;
  final double ytdReturn;
  final Color color;

  const _Fund(this.id, this.name, this.ticker, this.balance, this.allocation, this.ytdReturn, this.color);
}
