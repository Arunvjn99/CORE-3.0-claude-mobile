import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/flow_scaffold.dart';

class TransferTypePage extends StatefulWidget {
  const TransferTypePage({super.key});

  @override
  State<TransferTypePage> createState() => _TransferTypePageState();
}

class _TransferTypePageState extends State<TransferTypePage> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Transfer Type',
      currentStep: 1,
      totalSteps: 6,
      primaryLabel: 'Continue',
      primaryEnabled: _selected != null,
      onPrimary: () => context.go(AppRoutes.transferSource),
      onBack: () => context.go(AppRoutes.transactions),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Transfer Type',
              style: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
          const SizedBox(height: 8),
          const Text('Choose whether to transfer existing investments or redirect future contributions.',
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.lightTextSecondary)),
          const SizedBox(height: 20),

          _TypeCard(
            id: 'existing',
            icon: Icons.swap_horiz,
            title: 'Transfer Existing Balance',
            description: 'Move money between your current investment funds. Trades execute at market close.',
            details: const [
              'Reallocate existing investments',
              'No fees or penalties',
              'Executed at next market close',
            ],
            color: AppColors.primary,
            selected: _selected == 'existing',
            onTap: () => setState(() => _selected = 'existing'),
          ),
          const SizedBox(height: 12),
          _TypeCard(
            id: 'future',
            icon: Icons.schedule,
            title: 'Transfer Future Contributions',
            description: 'Change how your future paycheck contributions are invested across funds.',
            details: const [
              'Applies to all future contributions',
              'Takes effect next pay period',
              'Doesn\'t affect existing balance',
            ],
            color: AppColors.chartPurple,
            selected: _selected == 'future',
            onTap: () => setState(() => _selected = 'future'),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.iconBgBlue,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Transfers within your 401(k) plan are tax-free and have no impact on your contribution limits. To change both existing balance and future contributions, initiate two separate transfers.',
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

class _TypeCard extends StatelessWidget {
  final String id;
  final IconData icon;
  final String title;
  final String description;
  final List<String> details;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _TypeCard({
    required this.id, required this.icon, required this.title,
    required this.description, required this.details,
    required this.color, required this.selected, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? color : AppColors.lightBorder,
            width: selected ? 1.5 : 1,
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: selected ? color.withValues(alpha: 0.12) : AppColors.lightShell,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: selected ? color : AppColors.lightTextSecondary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.lightTextSecondary, height: 1.4)),
                  const SizedBox(height: 10),
                  ...details.map((d) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 5, height: 5,
                          margin: const EdgeInsets.only(right: 8, top: 1),
                          decoration: BoxDecoration(
                            color: selected ? color : AppColors.lightTextSecondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(child: Text(d,
                            style: TextStyle(fontFamily: 'Inter', fontSize: 12,
                                color: selected ? AppColors.lightTextPrimary : AppColors.lightTextSecondary))),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
