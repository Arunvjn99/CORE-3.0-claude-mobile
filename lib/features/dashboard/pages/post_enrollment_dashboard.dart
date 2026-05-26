import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/company_theme_provider.dart';
import '../../../core/theme/app_colors.dart';

class PostEnrollmentDashboard extends ConsumerStatefulWidget {
  const PostEnrollmentDashboard({super.key});

  @override
  ConsumerState<PostEnrollmentDashboard> createState() =>
      _PostEnrollmentDashboardState();
}

class _PostEnrollmentDashboardState
    extends ConsumerState<PostEnrollmentDashboard>
    with TickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  late final Animation<double> _entryAnim;

  String _greeting() {
    final h = DateTime.now().hour;
    if (h >= 5 && h < 12) return 'Good morning';
    if (h >= 12 && h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _entryAnim =
        CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic);
    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companyTheme = ref.watch(companyThemeProvider);
    final userAsync = ref.watch(userProfileProvider);
    final firstName = userAsync.valueOrNull?.firstName ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _DashboardHeader(
                greeting: _greeting(),
                firstName: firstName,
                companyTheme: companyTheme,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _BalanceCard(companyTheme: companyTheme),
                  const SizedBox(height: 16),
                  const _QuickStats(),
                  const SizedBox(height: 24),
                  _PerformanceChart(companyTheme: companyTheme),
                  const SizedBox(height: 24),
                  const _SectionTitle('Quick Actions'),
                  const SizedBox(height: 14),
                  _QuickActionsGrid(),
                  const SizedBox(height: 24),
                  const _SectionTitle("This Year's Summary"),
                  const SizedBox(height: 14),
                  const _ContributionSummary(),
                  const SizedBox(height: 24),
                  const _SectionTitle('Investment Allocation'),
                  const SizedBox(height: 14),
                  _AllocationCard(companyTheme: companyTheme),
                  const SizedBox(height: 24),
                  const _SectionTitle('Recent Transactions'),
                  const SizedBox(height: 14),
                  const _RecentTransactions(),
                  const SizedBox(height: 24),
                  _CoreAIBanner(onTap: () => context.go(AppRoutes.aiAssistant)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final String greeting;
  final String firstName;
  final CompanyThemeData companyTheme;

  const _DashboardHeader({
    required this.greeting,
    required this.firstName,
    required this.companyTheme,
  });

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      height: 130 + topPad,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: companyTheme.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withValues(alpha: 0.07), Colors.transparent],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24, topPad + 16, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstName.isNotEmpty
                          ? '$greeting, $firstName 👋'
                          : '$greeting 👋',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your plan is on track 🚀',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _IconBtn(icon: Icons.notifications_outlined, onTap: () {}),
                    const SizedBox(width: 8),
                    _IconBtn(
                      icon: Icons.person_outline,
                      onTap: () => context.go(AppRoutes.profile),
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

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

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

class _BalanceCard extends StatelessWidget {
  final CompanyThemeData companyTheme;
  const _BalanceCard({required this.companyTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Account Balance',
                        style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                    SizedBox(height: 4),
                    Text(
                      '\$30,420.50',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF111827),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.successBg,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_upward, color: AppColors.success, size: 14),
                    SizedBox(width: 3),
                    Text('+8.2%',
                        style: TextStyle(
                            color: AppColors.success,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text('YTD return +\$2,302 · Enrolled',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Retirement goal progress',
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                  Text('3.0%',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: companyTheme.primaryColor)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.03,
                  backgroundColor: companyTheme.primaryColor.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(companyTheme.primaryColor),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('\$0',
                      style: TextStyle(fontSize: 10, color: Color(0xFFD1D5DB))),
                  Text('Goal: \$1,000,000',
                      style: TextStyle(fontSize: 10, color: companyTheme.primaryColor)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatCard(
            label: 'YTD Contributions',
            value: '\$2,700',
            icon: Icons.savings_outlined,
            color: AppColors.primary,
            bg: Color(0xFFEFF6FF),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Employer Match',
            value: '\$1,350',
            icon: Icons.card_giftcard_outlined,
            color: AppColors.success,
            bg: Color(0xFFECFDF5),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Vested Balance',
            value: '\$24,200',
            icon: Icons.account_balance_outlined,
            color: Color(0xFF8B5CF6),
            bg: Color(0xFFF5F3FF),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color bg;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
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
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 17),
          ),
          const SizedBox(height: 10),
          Text(value,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  fontSize: 10, color: Color(0xFF6B7280), height: 1.3)),
        ],
      ),
    );
  }
}

class _PerformanceChart extends StatefulWidget {
  final CompanyThemeData companyTheme;
  const _PerformanceChart({required this.companyTheme});

  @override
  State<_PerformanceChart> createState() => _PerformanceChartState();
}

class _PerformanceChartState extends State<_PerformanceChart> {
  int _selected = 2;
  static const _labels = ['1M', '3M', '1Y', '3Y', 'All'];

  List<FlSpot> get _spots {
    switch (_selected) {
      case 0:
        return [
          const FlSpot(0, 29.5), const FlSpot(1, 29.8),
          const FlSpot(2, 29.6), const FlSpot(3, 30.0), const FlSpot(4, 30.4),
        ];
      case 1:
        return [
          const FlSpot(0, 28.0), const FlSpot(1, 28.8),
          const FlSpot(2, 29.0), const FlSpot(3, 29.5), const FlSpot(4, 30.4),
        ];
      case 3:
        return [
          const FlSpot(0, 16.0), const FlSpot(1, 19.0), const FlSpot(2, 22.0),
          const FlSpot(3, 25.0), const FlSpot(4, 28.0), const FlSpot(5, 30.4),
        ];
      default:
        return [
          const FlSpot(0, 24.0), const FlSpot(1, 25.5), const FlSpot(2, 26.0),
          const FlSpot(3, 27.5), const FlSpot(4, 27.0), const FlSpot(5, 28.5),
          const FlSpot(6, 29.0), const FlSpot(7, 29.8), const FlSpot(8, 29.5),
          const FlSpot(9, 30.2), const FlSpot(10, 30.0), const FlSpot(11, 30.4),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Portfolio Performance',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827))),
                  SizedBox(height: 2),
                  Text('+\$6,420 total gain',
                      style: TextStyle(fontSize: 12, color: AppColors.success)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.successBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('+8.2% YTD',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(_labels.length, (i) {
              final sel = i == _selected;
              return GestureDetector(
                onTap: () => setState(() => _selected = i),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: sel ? widget.companyTheme.primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _labels[i],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: sel ? Colors.white : const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) => spots
                        .map((s) => LineTooltipItem(
                              '\$${s.y.toStringAsFixed(1)}K',
                              const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                            ))
                        .toList(),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: _spots,
                    isCurved: true,
                    color: widget.companyTheme.primaryColor,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          widget.companyTheme.primaryColor.withValues(alpha: 0.2),
                          widget.companyTheme.primaryColor.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF111827)),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  static const _actions = [
    _Action('Loan', Icons.account_balance_wallet_outlined, Color(0xFF2563EB),
        Color(0xFFEFF6FF), AppRoutes.loan),
    _Action('Withdrawal', Icons.payments_outlined, Color(0xFFF59E0B),
        Color(0xFFFFFBEB), AppRoutes.withdrawal),
    _Action('Transfer', Icons.swap_horiz, Color(0xFF10B981), Color(0xFFECFDF5),
        AppRoutes.transfer),
    _Action('Rebalance', Icons.tune, Color(0xFF8B5CF6), Color(0xFFF5F3FF),
        AppRoutes.rebalance),
    _Action('Rollover', Icons.sync, Color(0xFFEF4444), Color(0xFFFEF2F2),
        AppRoutes.rollover),
    _Action('Investments', Icons.pie_chart_outline, Color(0xFF0D9488),
        Color(0xFFF0FDFA), AppRoutes.investments),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.0,
      children: _actions
          .map((a) => _ActionTile(action: a, onTap: () => context.push(a.route)))
          .toList(),
    );
  }
}

class _Action {
  final String label;
  final IconData icon;
  final Color color;
  final Color bg;
  final String route;
  const _Action(this.label, this.icon, this.color, this.bg, this.route);
}

class _ActionTile extends StatelessWidget {
  final _Action action;
  final VoidCallback onTap;
  const _ActionTile({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: action.bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(action.icon, color: action.color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(action.label,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151))),
          ],
        ),
      ),
    );
  }
}

class _ContributionSummary extends StatelessWidget {
  const _ContributionSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _ContribRow(
            label: 'Your Contributions',
            value: '\$2,700',
            sublabel: '\$225/month · 6%',
            color: AppColors.primary,
          ),
          const Divider(height: 24),
          _ContribRow(
            label: 'Employer Match',
            value: '\$1,350',
            sublabel: '\$112.50/month · 3%',
            color: AppColors.success,
          ),
          const Divider(height: 24),
          _ContribRow(
            label: 'Total Saved in 2025',
            value: '\$4,050',
            sublabel: '2025 limit: \$23,500',
            color: const Color(0xFF8B5CF6),
            isBold: true,
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 4050 / 23500,
              backgroundColor: Color(0xFFF3F4F6),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('17.2% of annual limit used',
                  style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
              Text('\$19,450 remaining',
                  style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContribRow extends StatelessWidget {
  final String label;
  final String value;
  final String sublabel;
  final Color color;
  final bool isBold;

  const _ContribRow({
    required this.label,
    required this.value,
    required this.sublabel,
    required this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                    color: const Color(0xFF374151))),
            Text(sublabel,
                style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
          ],
        ),
        Text(value,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w800, color: color)),
      ],
    );
  }
}

class _AllocationCard extends StatelessWidget {
  final CompanyThemeData companyTheme;
  const _AllocationCard({required this.companyTheme});

  @override
  Widget build(BuildContext context) {
    final allocations = [
      _AllocItem('US Stocks', 0.45, AppColors.primary),
      _AllocItem('Intl Stocks', 0.25, AppColors.success),
      _AllocItem('Bonds', 0.20, const Color(0xFF8B5CF6)),
      _AllocItem('Real Estate', 0.10, const Color(0xFFF59E0B)),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 28,
                sections: allocations
                    .map((a) => PieChartSectionData(
                          value: a.percent * 100,
                          color: a.color,
                          radius: 20,
                          showTitle: false,
                        ))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: allocations
                  .map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: a.color,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(a.label,
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xFF374151))),
                            ),
                            Text('${(a.percent * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: a.color)),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AllocItem {
  final String label;
  final double percent;
  final Color color;
  const _AllocItem(this.label, this.percent, this.color);
}

class _RecentTransactions extends StatelessWidget {
  const _RecentTransactions();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        children: [
          _TxRow(
            icon: Icons.arrow_downward,
            label: 'Employee Contribution',
            sublabel: 'Nov 30, 2025',
            amount: '+\$225.00',
            isPositive: true,
          ),
          Divider(height: 1, indent: 20, endIndent: 20),
          _TxRow(
            icon: Icons.card_giftcard_outlined,
            label: 'Employer Match',
            sublabel: 'Nov 30, 2025',
            amount: '+\$112.50',
            isPositive: true,
          ),
          Divider(height: 1, indent: 20, endIndent: 20),
          _TxRow(
            icon: Icons.sync,
            label: 'Fund Rebalancing',
            sublabel: 'Nov 15, 2025',
            amount: '\$0.00',
            isPositive: null,
          ),
        ],
      ),
    );
  }
}

class _TxRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final String amount;
  final bool? isPositive;

  const _TxRow({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.amount,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final amtColor = isPositive == null
        ? const Color(0xFF6B7280)
        : isPositive!
            ? AppColors.success
            : AppColors.danger;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF6B7280)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151))),
                Text(sublabel,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
          Text(amount,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700, color: amtColor)),
        ],
      ),
    );
  }
}

class _CoreAIBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _CoreAIBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: const Icon(Icons.psychology, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ask CORE AI',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: 3),
                  Text('Get personalized retirement advice instantly',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }
}
