import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/flow_scaffold.dart';

class AutoIncreasePage extends ConsumerStatefulWidget {
  const AutoIncreasePage({super.key});
  @override
  ConsumerState<AutoIncreasePage> createState() => _AutoIncreasePageState();
}

class _AutoIncreasePageState extends ConsumerState<AutoIncreasePage> {
  bool? _selected;
  double _annualIncrease = 1.0;
  double _maxRate = 15.0;

  static const double _fixedProjection = 124621;
  static const double _autoProjection = 185943;
  static const double _difference = _autoProjection - _fixedProjection;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(enrollmentProvider);
    _annualIncrease = draft.autoIncreasePercent ?? 1.0;
    _maxRate = draft.autoIncreaseMax ?? 15.0;
    if (draft.autoIncreaseEnabled) {
      _selected = true;
    } else if (draft.autoIncreasePercent != null) {
      _selected = false;
    }
  }

  String _fmt(double v) => '\$${(v / 1000).toStringAsFixed(0)}K';

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Auto Increase',
      currentStep: 4,
      totalSteps: 8,
      primaryLabel: 'Continue',
      primaryEnabled: _selected != null,
      onPrimary: () {
        ref.read(enrollmentProvider.notifier).setAutoIncrease(
          enabled: _selected == true,
          percent: _selected == true ? _annualIncrease : null,
          max: _selected == true ? _maxRate : null,
        );
        context.go(AppRoutes.enrollmentInvestment);
      },
      onBack: () => context.go(AppRoutes.enrollmentSource),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Boost your savings automatically',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF111827)),
          ),
          const SizedBox(height: 4),
          const Text(
            'Auto Increase raises your contribution rate 1% each year. See how much it adds up.',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.5),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _OptionCard(
                  title: 'Fixed Rate',
                  subtitle: 'Stay at current %\nno changes each year',
                  projected: _fmt(_fixedProjection),
                  icon: Icons.lock_outline,
                  iconBg: const Color(0xFFF3F4F6),
                  iconColor: const Color(0xFF6B7280),
                  isSelected: _selected == false,
                  onTap: () => setState(() => _selected = false),
                  accentColor: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _OptionCard(
                  title: 'Auto Increase',
                  subtitle: '+1% each year\nuntil max rate',
                  projected: _fmt(_autoProjection),
                  icon: Icons.trending_up,
                  iconBg: const Color(0xFFECFDF5),
                  iconColor: AppColors.success,
                  isSelected: _selected == true,
                  onTap: () => setState(() => _selected = true),
                  accentColor: AppColors.success,
                  badge: 'Recommended',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_selected == true) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.successBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt, color: AppColors.success, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '+${_fmt(_difference)} more over 30 years',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.successText),
                        ),
                        const Text(
                          'Small annual increases compound into a massive retirement boost.',
                          style: TextStyle(fontSize: 12, color: AppColors.successText, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Configure', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Annual increase', style: TextStyle(fontSize: 13, color: Color(0xFF374151))),
                      Row(
                        children: [
                          _MiniStepBtn(icon: Icons.remove, onTap: () => setState(() => _annualIncrease = (_annualIncrease - 0.5).clamp(0.5, 5.0))),
                          const SizedBox(width: 12),
                          Text('${_annualIncrease.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
                          const SizedBox(width: 12),
                          _MiniStepBtn(icon: Icons.add, onTap: () => setState(() => _annualIncrease = (_annualIncrease + 0.5).clamp(0.5, 5.0))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Max rate cap', style: TextStyle(fontSize: 13, color: Color(0xFF374151))),
                      Row(
                        children: [
                          _MiniStepBtn(icon: Icons.remove, onTap: () => setState(() => _maxRate = (_maxRate - 1).clamp(6.0, 25.0))),
                          const SizedBox(width: 12),
                          Text('${_maxRate.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
                          const SizedBox(width: 12),
                          _MiniStepBtn(icon: Icons.add, onTap: () => setState(() => _maxRate = (_maxRate + 1).clamp(6.0, 25.0))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else if (_selected == false) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.warning, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'You could have ${_fmt(_difference)} more at retirement with Auto Increase. You can change this later.',
                      style: const TextStyle(fontSize: 12, color: AppColors.warning, height: 1.4),
                    ),
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

class _OptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String projected;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accentColor;
  final String? badge;

  const _OptionCard({
    required this.title, required this.subtitle, required this.projected,
    required this.icon, required this.iconBg, required this.iconColor,
    required this.isSelected, required this.onTap, required this.accentColor,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? accentColor : const Color(0xFFE5E7EB), width: isSelected ? 2 : 1),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
                child: Text(badge!, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: accentColor)),
              ),
              const SizedBox(height: 8),
            ],
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
            const SizedBox(height: 3),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280), height: 1.4)),
            const SizedBox(height: 12),
            Text('30yr projection', style: TextStyle(fontSize: 9, color: accentColor, fontWeight: FontWeight.w600, letterSpacing: 0.3)),
            Text(projected, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: accentColor)),
            if (isSelected) ...[
              const SizedBox(height: 6),
              Icon(Icons.check_circle, color: accentColor, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

class _MiniStepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _MiniStepBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }
}
