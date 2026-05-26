import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/company_theme_provider.dart';
import '../../../core/theme/app_colors.dart';

class PreEnrollmentDashboard extends ConsumerStatefulWidget {
  const PreEnrollmentDashboard({super.key});

  @override
  ConsumerState<PreEnrollmentDashboard> createState() =>
      _PreEnrollmentDashboardState();
}

class _PreEnrollmentDashboardState extends ConsumerState<PreEnrollmentDashboard>
    with TickerProviderStateMixin {
  late final AnimationController _heroCtrl;
  late final Animation<double> _heroAnim;

  @override
  void initState() {
    super.initState();
    _heroCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _heroAnim = CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOutCubic);
    _heroCtrl.forward();
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companyTheme = ref.watch(companyThemeProvider);
    final userAsync = ref.watch(userProfileProvider);
    final firstName = userAsync.valueOrNull?.firstName ?? '';

    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          // Gradient hero header
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _heroAnim,
              child: _HeroHeader(
                firstName: firstName,
                companyTheme: companyTheme,
                onStartEnrollment: () => context.push(AppRoutes.enrollmentPlan),
              ),
            ),
          ),

          // Body content
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Employer match spotlight
                _EmployerMatchCard(companyTheme: companyTheme),
                const SizedBox(height: 20),

                // Why enroll section
                const _SectionHeader(title: 'Why Enroll?', subtitle: 'Key benefits of your retirement plan'),
                const SizedBox(height: 14),
                const _BenefitsGrid(),
                const SizedBox(height: 24),

                // Available plans
                const _SectionHeader(title: 'Available Plans', subtitle: 'Choose the right plan for your goals'),
                const SizedBox(height: 14),
                _PlanCards(
                  onTap: () => context.push(AppRoutes.enrollmentPlan),
                ),
                const SizedBox(height: 28),

                // Final CTA
                _FinalCTA(
                  companyTheme: companyTheme,
                  onStart: () => context.push(AppRoutes.enrollmentPlan),
                ),
                const SizedBox(height: 24),

                // Learning Hub Card
                _LearningCard(
                  onLearnMore: () => context.push(AppRoutes.enrollmentPlan),
                ),
                const SizedBox(height: 20),

                // Core AI + Advisor bento cards
                _BentoCards(
                  onAiTap: () => context.go(AppRoutes.aiAssistant),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hero Header ────────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  final String firstName;
  final CompanyThemeData companyTheme;
  final VoidCallback onStartEnrollment;

  const _HeroHeader({
    required this.firstName,
    required this.companyTheme,
    required this.onStartEnrollment,
  });

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: companyTheme.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background orb
          Positioned(
            top: -40,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.07),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(24, topPad + 16, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstName.isNotEmpty ? 'Hello, $firstName 👋' : 'Hello there 👋',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Your plan is waiting',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _HeaderIconBtn(
                          icon: Icons.notifications_outlined,
                          onTap: () {},
                        ),
                        const SizedBox(width: 8),
                        _HeaderIconBtn(
                          icon: Icons.person_outline,
                          onTap: () => context.go(AppRoutes.profile),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Illustration + CTA row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFFBBF24),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Not Enrolled',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Start Your\nRetirement Journey',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Take 5 minutes to activate your\n401(k) and unlock employer matching.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: onStartEnrollment,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Start Enrollment',
                                    style: TextStyle(
                                      color: companyTheme.primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: companyTheme.primaryColor,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Illustration
                    SizedBox(
                      width: 120,
                      height: 140,
                      child: Lottie.network(
                        'https://lottie.host/4db68bbd-31f6-4cd8-84eb-189de081159a/IGmMCqhzpt.json',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.savings,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

// ─── Employer Match Card ─────────────────────────────────────────────────────
class _EmployerMatchCard extends StatelessWidget {
  final CompanyThemeData companyTheme;
  const _EmployerMatchCard({required this.companyTheme});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.card_giftcard, color: Color(0xFFF59E0B), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🎁 Free Money Available',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const Text(
                      'Your employer matches contributions',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Match visualization
          Row(
            children: [
              Expanded(
                child: _MatchBar(
                  label: 'You contribute',
                  value: '6%',
                  color: companyTheme.primaryColor,
                  fill: 0.6,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MatchBar(
                  label: 'Employer adds',
                  value: '3%',
                  color: AppColors.success,
                  fill: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.successBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: AppColors.success, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Enroll today to claim your 3% employer match — that\'s up to \$1,800/year FREE.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.successText,
                      fontWeight: FontWeight.w500,
                    ),
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

class _MatchBar extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final double fill;

  const _MatchBar({
    required this.label,
    required this.value,
    required this.color,
    required this.fill,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fill,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

// ─── Section Header ──────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}

// ─── Benefits Grid ───────────────────────────────────────────────────────────
class _BenefitsGrid extends StatelessWidget {
  const _BenefitsGrid();

  static const _benefits = [
    _Benefit('Tax Savings', 'Reduce taxable income now or in retirement', Icons.receipt_long_outlined, Color(0xFF2563EB), Color(0xFFEFF6FF)),
    _Benefit('Compound Growth', 'Watch your money multiply over decades', Icons.auto_graph, Color(0xFF10B981), Color(0xFFECFDF5)),
    _Benefit('Employer Match', 'Get up to 3% free from your employer', Icons.card_giftcard_outlined, Color(0xFFF59E0B), Color(0xFFFFFBEB)),
    _Benefit('Investment Choice', 'Choose from diversified fund options', Icons.pie_chart_outline, Color(0xFF8B5CF6), Color(0xFFF5F3FF)),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: _benefits.map((b) => _BenefitCard(benefit: b)).toList(),
    );
  }
}

class _Benefit {
  final String title;
  final String desc;
  final IconData icon;
  final Color color;
  final Color bg;
  const _Benefit(this.title, this.desc, this.icon, this.color, this.bg);
}

class _BenefitCard extends StatelessWidget {
  final _Benefit benefit;
  const _BenefitCard({required this.benefit});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: benefit.bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(benefit.icon, color: benefit.color, size: 20),
          ),
          const Spacer(),
          Text(
            benefit.title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            benefit.desc,
            style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant, height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─── Calculator Teaser ───────────────────────────────────────────────────────
class _CalculatorTeaser extends StatefulWidget {
  final CompanyThemeData companyTheme;
  final VoidCallback onTap;
  const _CalculatorTeaser({required this.companyTheme, required this.onTap});

  @override
  State<_CalculatorTeaser> createState() => _CalculatorTeaserState();
}

class _CalculatorTeaserState extends State<_CalculatorTeaser> {
  double _salaryK = 60;
  double _rate = 6;

  double get _monthly => (_salaryK * 1000 * _rate / 100) / 12;
  double get _employerMonthly => _monthly * 0.5;
  double get _total => _monthly + _employerMonthly;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.companyTheme.primaryColor.withValues(alpha: 0.08),
            widget.companyTheme.primaryColor.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.companyTheme.primaryColor.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calculate_outlined, color: widget.companyTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Quick Calculator',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: widget.companyTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Salary slider
          const Text('Annual Salary', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _salaryK,
                  min: 30,
                  max: 200,
                  divisions: 34,
                  activeColor: widget.companyTheme.primaryColor,
                  onChanged: (v) => setState(() => _salaryK = v),
                ),
              ),
              SizedBox(
                width: 70,
                child: Text(
                  '\$${_salaryK.toStringAsFixed(0)}K',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: widget.companyTheme.primaryColor,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),

          // Rate slider
          const Text('Contribution Rate', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _rate,
                  min: 1,
                  max: 20,
                  divisions: 19,
                  activeColor: AppColors.success,
                  onChanged: (v) => setState(() => _rate = v),
                ),
              ),
              SizedBox(
                width: 70,
                child: Text(
                  '${_rate.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          // Result
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    label: 'Your monthly',
                    value: '\$${_monthly.toStringAsFixed(0)}',
                    color: widget.companyTheme.primaryColor,
                  ),
                ),
                Container(width: 1, height: 36, color: const Color(0xFFE5E7EB)),
                Expanded(
                  child: _MiniStat(
                    label: 'Employer adds',
                    value: '\$${_employerMonthly.toStringAsFixed(0)}',
                    color: AppColors.success,
                  ),
                ),
                Container(width: 1, height: 36, color: const Color(0xFFE5E7EB)),
                Expanded(
                  child: _MiniStat(
                    label: 'Total saved',
                    value: '\$${_total.toStringAsFixed(0)}',
                    color: const Color(0xFF8B5CF6),
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

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)), textAlign: TextAlign.center),
      ],
    );
  }
}

// ─── Plan Cards ──────────────────────────────────────────────────────────────
class _PlanCards extends StatelessWidget {
  final VoidCallback onTap;
  const _PlanCards({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PlanTile(
          icon: Icons.account_balance_outlined,
          title: 'Traditional 401(k)',
          subtitle: 'Pre-tax contributions · Lower taxable income now',
          badge: 'Most Popular',
          badgeColor: AppColors.primary,
          onTap: onTap,
        ),
        const SizedBox(height: 10),
        _PlanTile(
          icon: Icons.show_chart,
          title: 'Roth 401(k)',
          subtitle: 'After-tax contributions · Tax-free withdrawals',
          badge: 'Tax-Free Growth',
          badgeColor: AppColors.success,
          onTap: onTap,
        ),
      ],
    );
  }
}

class _PlanTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final VoidCallback onTap;

  const _PlanTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: badgeColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: badgeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFD1D5DB), size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── Final CTA ───────────────────────────────────────────────────────────────
class _FinalCTA extends StatelessWidget {
  final CompanyThemeData companyTheme;
  final VoidCallback onStart;

  const _FinalCTA({required this.companyTheme, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: companyTheme.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: companyTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⚡ Ready to Begin?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enrollment takes about 5 minutes. Start now and secure your financial future.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onStart,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Begin Enrollment',
                    style: TextStyle(
                      color: companyTheme.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: companyTheme.primaryColor, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, color: Colors.white54, size: 14),
              const SizedBox(width: 5),
              Text(
                'Bank-grade encryption · ERISA compliant',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Learning Hub Card ───────────────────────────────────────────────────────
class _LearningCard extends StatelessWidget {
  final VoidCallback onLearnMore;
  const _LearningCard({required this.onLearnMore});

  static const _items = [
    'How 401(k) employer matching works',
    'Tax advantages of pre-tax vs Roth',
    'Investment strategies for every stage',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF5B8CEF), Color(0xFF3B6FE0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Glow orbs
          Positioned(top: -20, left: -20, child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.06)))),
          Positioned(bottom: -30, right: -30, child: Container(width: 160, height: 160, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF3B6FE0).withValues(alpha: 0.4)))),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Retirement\nLearning Hub', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white, height: 1.15)),
                const SizedBox(height: 6),
                Text('Everything you need to make smart retirement decisions.', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.75), height: 1.5)),
                const SizedBox(height: 16),
                ..._items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 20, height: 20,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), shape: BoxShape.circle),
                        child: const Icon(Icons.check, color: Colors.white, size: 12),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(item, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.9)))),
                    ],
                  ),
                )),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: onLearnMore,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Learn My Plan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                        SizedBox(width: 6),
                        Icon(Icons.chevron_right, color: Colors.white, size: 16),
                      ],
                    ),
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

// ─── Bento Cards (AI + Advisor) ──────────────────────────────────────────────
class _BentoCards extends StatefulWidget {
  final VoidCallback onAiTap;
  const _BentoCards({required this.onAiTap});

  @override
  State<_BentoCards> createState() => _BentoCardsState();
}

class _BentoCardsState extends State<_BentoCards> {
  static const _advisors = [
    _AdvisorChip('Sarah Jenkins', 'SJ', Color(0xFF60A5FA), Color(0xFF3B82F6)),
    _AdvisorChip('Alex Carter', 'AC', Color(0xFF34D399), Color(0xFF059669)),
    _AdvisorChip('Maya Patel', 'MP', Color(0xFFFBBF24), Color(0xFFD97706)),
    _AdvisorChip('James Liu', 'JL', Color(0xFFF472B6), Color(0xFFDB2777)),
  ];

  int _activeChip = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1800), (_) {
      if (mounted) setState(() => _activeChip = (_activeChip + 1) % _advisors.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        // Core AI card
        GestureDetector(
          onTap: widget.onAiTap,
          child: Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: scheme.outline.withValues(alpha: 0.4)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Column(
              children: [
                // Mockup
                Container(
                  decoration: BoxDecoration(color: scheme.surfaceContainerLowest, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // AI header chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: scheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: scheme.outline.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32, height: 32,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: [AppColors.primary, Color(0xFF7C3AED)]),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.psychology, color: Colors.white, size: 16),
                            ),
                            const SizedBox(width: 10),
                            Text('Core AI', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: scheme.onSurface)),
                            const Spacer(),
                            Container(
                              width: 8, height: 8,
                              decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 4),
                            Text('Online', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Chat bubbles
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14), bottomLeft: Radius.circular(14)),
                          ),
                          child: const Text('What is my loan eligibility?', style: TextStyle(fontSize: 12, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHigh,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14), bottomRight: Radius.circular(14)),
                          ),
                          child: Text('You may be eligible for up to \$15,000 based on your balance.', style: TextStyle(fontSize: 12, color: scheme.onSurface)),
                        ),
                      ),
                    ],
                  ),
                ),
                // Text + CTA
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ask Core AI', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: scheme.onSurface)),
                            Text('Get instant answers about your retirement plan.', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Chat', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right, color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Advisor card (dark)
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF1E2D4A), Color(0xFF0F172A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Glow
              Positioned(left: -30, top: 0, child: Container(width: 150, height: 150, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF3B82F6).withValues(alpha: 0.15)))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Advisor chips
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _advisors.asMap().entries.map((e) {
                        final i = e.key;
                        final a = e.value;
                        final isActive = i == _activeChip;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          margin: EdgeInsets.only(left: [0.0, 18.0, 32.0, 10.0][i], bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.white.withValues(alpha: 0.13) : Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: isActive ? Colors.white.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.09)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 24, height: 24,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [a.from, a.to]),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(child: Text(a.initials, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white))),
                              ),
                              const SizedBox(width: 8),
                              Text(a.name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.9))),
                              if (isActive) ...[
                                const SizedBox(width: 6),
                                Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
                              ],
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Talk to an Advisor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('Connect with a financial expert who can help personalize your retirement strategy.', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.55), height: 1.5)),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Text('Meet an Expert', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.7))),
                        const SizedBox(width: 4),
                        Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.7), size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AdvisorChip {
  final String name;
  final String initials;
  final Color from;
  final Color to;
  const _AdvisorChip(this.name, this.initials, this.from, this.to);
}
