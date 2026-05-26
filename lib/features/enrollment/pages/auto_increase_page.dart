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
  static const double _fixedProjection = 124621;
  static const double _autoProjection = 185943;
  static const double _difference = _autoProjection - _fixedProjection;

  String _fmt(double v) => '\$${(v / 1000).toStringAsFixed(0)}K';

  void _showSkipModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _SkipConfirmSheet(
        onSkip: () {
          Navigator.of(context).pop();
          ref.read(enrollmentProvider.notifier).setAutoIncrease(
            enabled: false,
            percent: null,
            max: null,
          );
          context.go(AppRoutes.enrollmentInvestment);
        },
        onEnable: () {
          Navigator.of(context).pop();
          context.go(AppRoutes.enrollmentAutoIncreaseSetup);
        },
        difference: _fmt(_difference),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      title: 'Auto Increase',
      currentStep: 4,
      totalSteps: 8,
      primaryLabel: 'Enable Auto Increase',
      primaryEnabled: true,
      onPrimary: () => context.go(AppRoutes.enrollmentAutoIncreaseSetup),
      onBack: () => context.go(AppRoutes.enrollmentSource),
      secondaryAction: TextButton(
        onPressed: _showSkipModal,
        child: const Text(
          'Skip for now',
          style: TextStyle(fontSize: 15, color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Boost your savings automatically',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF111827)),
          ),
          const SizedBox(height: 4),
          const Text(
            'Auto Increase raises your contribution rate 1% each year. See how much it adds up over time.',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.5),
          ),
          const SizedBox(height: 24),

          // Impact callout
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

          // Side-by-side comparison
          Row(
            children: [
              Expanded(child: _CompareCard(
                title: 'Fixed Rate',
                subtitle: 'Stay at current %\nno changes each year',
                projected: _fmt(_fixedProjection),
                icon: Icons.lock_outline,
                iconBg: const Color(0xFFF3F4F6),
                iconColor: const Color(0xFF6B7280),
                accentColor: const Color(0xFF6B7280),
                ctaLabel: 'Skip for now',
                ctaOutlined: true,
                onCta: _showSkipModal,
              )),
              const SizedBox(width: 12),
              Expanded(child: _CompareCard(
                title: 'Auto Increase',
                subtitle: '+1% each year\nuntil max rate',
                projected: _fmt(_autoProjection),
                icon: Icons.trending_up,
                iconBg: const Color(0xFFECFDF5),
                iconColor: AppColors.success,
                accentColor: AppColors.success,
                badge: 'Recommended',
                ctaLabel: 'Enable →',
                ctaOutlined: false,
                onCta: () => context.go(AppRoutes.enrollmentAutoIncreaseSetup),
              )),
            ],
          ),
          const SizedBox(height: 20),

          // Info row
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'You can change or disable Auto Increase at any time from your account settings.',
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

class _CompareCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String projected;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color accentColor;
  final String? badge;
  final String ctaLabel;
  final bool ctaOutlined;
  final VoidCallback onCta;

  const _CompareCard({
    required this.title, required this.subtitle, required this.projected,
    required this.icon, required this.iconBg, required this.iconColor,
    required this.accentColor, this.badge, required this.ctaLabel,
    required this.ctaOutlined, required this.onCta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ctaOutlined ? const Color(0xFFE5E7EB) : accentColor.withValues(alpha: 0.4), width: ctaOutlined ? 1 : 2),
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
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onCta,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: ctaOutlined ? Colors.transparent : accentColor,
                borderRadius: BorderRadius.circular(10),
                border: ctaOutlined ? Border.all(color: const Color(0xFFD1D5DB)) : null,
              ),
              child: Text(
                ctaLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: ctaOutlined ? const Color(0xFF6B7280) : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkipConfirmSheet extends StatelessWidget {
  final VoidCallback onSkip;
  final VoidCallback onEnable;
  final String difference;

  const _SkipConfirmSheet({required this.onSkip, required this.onEnable, required this.difference});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).padding.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 28),
          ),
          const SizedBox(height: 16),
          const Text('Skip Auto Increase?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
          const SizedBox(height: 8),
          Text(
            'You could miss out on $difference more at retirement. Auto Increase grows your savings automatically with small annual bumps.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.5),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: onEnable,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryHover]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text('Enable Auto Increase', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onSkip,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No thanks, skip for now', style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF))),
            ),
          ),
        ],
      ),
    );
  }
}
