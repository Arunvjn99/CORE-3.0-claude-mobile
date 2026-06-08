import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system/brand_assets.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/router/app_router.dart';

/// Post-Enrollment Dashboard — matches Figma "Post enrollement page" (2244:6403)
class PostEnrollmentDashboard extends ConsumerWidget {
  const PostEnrollmentDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value?.session?.user;
    final name = user?.userMetadata?['full_name']?.toString().split(' ').first ?? 'Arun';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // ── App Bar ────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 1,
            shadowColor: const Color(0x1A000000),
            automaticallyImplyLeading: false,
            title: SvgPicture.asset(BrandAssets.coreLogoSvg, height: 22),
            actions: [
              IconButton(
                icon: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.notifications_outlined, size: 18, color: Color(0xFF64748B)),
                ),
                onPressed: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.profile),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF475569), Color(0xFF334155)]),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_rounded, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          // ── Greeting + Balance card ────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good Morning, $name 👋', style: const TextStyle(fontFamily: 'Lato', fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  const Text('Dashboard', style: TextStyle(fontFamily: 'Lato', fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                  const SizedBox(height: 16),

                  // Balance card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Text('TOTAL RETIREMENT BALANCE', style: TextStyle(fontFamily: 'Lato', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(30)),
                            child: const Text('On Track', style: TextStyle(fontFamily: 'Lato', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF059669))),
                          ),
                        ]),
                        const SizedBox(height: 6),
                        Row(children: [
                          const Text('\$142,893', style: TextStyle(fontFamily: 'Lato', fontSize: 30, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                            child: const Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.arrow_upward_rounded, size: 12, color: Color(0xFF059669)),
                              Text('+4.2%', style: TextStyle(fontFamily: 'Lato', fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF059669))),
                            ]),
                          ),
                        ]),
                        const SizedBox(height: 16),

                        // Trend chart
                        SizedBox(height: 70, child: CustomPaint(size: const Size(double.infinity, 70), painter: _TrendPainter())),

                        const SizedBox(height: 12),
                        const Row(children: [
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Projected Retirement', style: TextStyle(fontFamily: 'Lato', fontSize: 11, color: Color(0xFF94A3B8))),
                            Text('2054', style: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                          ])),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Text('Vested Balance', style: TextStyle(fontFamily: 'Lato', fontSize: 11, color: Color(0xFF94A3B8))),
                            Text('85% (\$121,459)', style: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                          ])),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // ── Retirement Readiness card ────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    // Score circle
                    SizedBox(
                      width: 72, height: 72,
                      child: Stack(alignment: Alignment.center, children: [
                        CustomPaint(size: const Size(72, 72), painter: _ScoreArcPainter(0.80, Colors.white30, Colors.white)),
                        const Column(mainAxisSize: MainAxisSize.min, children: [
                          Text('80', style: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                          Text('HEALTH', style: TextStyle(fontFamily: 'Lato', fontSize: 7, fontWeight: FontWeight.w700, color: Colors.white60, letterSpacing: 0.3)),
                        ]),
                      ]),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Retirement Readiness', style: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                        const SizedBox(height: 4),
                        const Text("You're projected to replace 82% of your income.", style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: Colors.white70, height: 1.4)),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.enrollmentReadiness),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                            child: const Text('Launch Simulator', style: TextStyle(fontFamily: 'Lato', fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Recommended Actions ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Text('Recommended Actions', style: TextStyle(fontFamily: 'Lato', fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(6)),
                      child: const Text('4 New', style: TextStyle(fontFamily: 'Lato', fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF2563EB))),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _ActionRow(
                    icon: Icons.person_add_outlined,
                    iconBg: const Color(0xFFFFF7ED),
                    iconColor: const Color(0xFFEA580C),
                    badge: 'HIGH PRIORITY',
                    badgeColor: const Color(0xFFEA580C),
                    title: 'Add Beneficiary',
                    subtitle: 'Ensure your assets are protected.',
                  ),
                  const SizedBox(height: 10),
                  _ActionRow(
                    icon: Icons.show_chart_rounded,
                    iconBg: const Color(0xFFF5F3FF),
                    iconColor: const Color(0xFF7C3AED),
                    badge: 'STRATEGY',
                    badgeColor: const Color(0xFF7C3AED),
                    title: 'Review Risk Tolerance',
                    subtitle: 'Annual check-in recommended.',
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Learning Center ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.school_outlined, size: 24, color: Color(0xFF2563EB)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Row(children: [
                        Text('Retirement Learning Center', style: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                        SizedBox(width: 4),
                        Icon(Icons.open_in_new, size: 12, color: Color(0xFF64748B)),
                      ]),
                      const SizedBox(height: 3),
                      const Text("Everything you need to know about your 401(k), matching, and smart investing strategies.", style: TextStyle(fontFamily: 'Lato', fontSize: 11, color: Color(0xFF64748B), height: 1.4)),
                      const SizedBox(height: 6),
                      const Row(children: [
                        Text('Explore Resources', style: TextStyle(fontFamily: 'Lato', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2563EB))),
                        SizedBox(width: 3),
                        Icon(Icons.arrow_forward_rounded, size: 12, color: Color(0xFF2563EB)),
                      ]),
                    ])),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Monthly Contributions ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Text('Monthly Contributions', style: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                    const Spacer(),
                    const Text('View History', style: TextStyle(fontFamily: 'Lato', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2563EB))),
                  ]),
                  const SizedBox(height: 16),
                  _ContribRow(label: 'Employee Contribution', amount: '\$1,250', pct: '10%', barColor: const Color(0xFF2563EB), barFraction: 0.72),
                  const SizedBox(height: 12),
                  _ContribRow(label: 'Employer Match', amount: '\$500', pct: '4%', barColor: const Color(0xFF10B981), barFraction: 0.29),
                  const Divider(height: 24, color: Color(0xFFE2E8F0)),
                  Row(children: [
                    const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Total Monthly', style: TextStyle(fontFamily: 'Lato', fontSize: 13, color: Color(0xFF64748B))),
                      Text('\$1,750', style: TextStyle(fontFamily: 'Lato', fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                    ]),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(8)),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.arrow_upward_rounded, size: 12, color: Color(0xFF059669)),
                        Text('+12% vs last year', style: TextStyle(fontFamily: 'Lato', fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF059669))),
                      ]),
                    ),
                  ]),
                ]),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Portfolio Overview ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Row(children: [
                    Text('Portfolio Overview', style: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                    Spacer(),
                    Text('Moderate-Aggressive', style: TextStyle(fontFamily: 'Lato', fontSize: 11, color: Color(0xFF64748B))),
                  ]),
                  const SizedBox(height: 16),
                  Row(children: [
                    SizedBox(
                      width: 110, height: 110,
                      child: CustomPaint(
                        painter: _DonutPainter(const [
                          _DonutSlice(Color(0xFF2563EB), 0.60),
                          _DonutSlice(Color(0xFF10B981), 0.20),
                          _DonutSlice(Color(0xFF8B5CF6), 0.15),
                          _DonutSlice(Color(0xFFF59E0B), 0.05),
                        ]),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(child: Column(children: const [
                      _LegendRow('US Stocks', '60%', Color(0xFF2563EB)),
                      SizedBox(height: 8),
                      _LegendRow('Intl Stocks', '20%', Color(0xFF10B981)),
                      SizedBox(height: 8),
                      _LegendRow('Bonds', '15%', Color(0xFF8B5CF6)),
                      SizedBox(height: 8),
                      _LegendRow('Cash', '5%', Color(0xFFF59E0B)),
                    ])),
                  ]),
                  const SizedBox(height: 16),
                  Center(child: GestureDetector(
                    onTap: () => context.go(AppRoutes.investments),
                    child: const Text('Full Portfolio Details', style: TextStyle(fontFamily: 'Lato', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2563EB))),
                  )),
                ]),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Recent Activity ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [
                  Text('Recent Activity', style: TextStyle(fontFamily: 'Lato', fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                  Spacer(),
                  Text('View All', style: TextStyle(fontFamily: 'Lato', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2563EB))),
                ]),
                const SizedBox(height: 12),
                _ActivityRow(
                  icon: Icons.arrow_downward_rounded,
                  iconBg: const Color(0xFFDCFCE7),
                  iconColor: const Color(0xFF059669),
                  title: 'Monthly Contribution',
                  subtitle: 'Processed successfully',
                  amount: '+\$1,750.00',
                  amountColor: const Color(0xFF059669),
                  date: 'Jun 15',
                ),
                const SizedBox(height: 10),
                _ActivityRow(
                  icon: Icons.sync_rounded,
                  iconBg: const Color(0xFFEFF6FF),
                  iconColor: const Color(0xFF2563EB),
                  title: 'Portfolio Rebalance',
                  subtitle: 'Quarterly adjustment completed',
                  amount: '',
                  amountColor: Colors.transparent,
                  date: 'Jun 02',
                ),
              ]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Active Loan ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Row(children: [
                    Text('Active Loan', style: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                    Spacer(),
                    Text('Home Purchase', style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF64748B))),
                  ]),
                  const SizedBox(height: 14),
                  const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Outstanding Balance', style: TextStyle(fontFamily: 'Lato', fontSize: 11, color: Color(0xFF64748B))),
                      Text('\$12,450.00', style: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                    ]),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('Next Payment', style: TextStyle(fontFamily: 'Lato', fontSize: 11, color: Color(0xFF64748B))),
                      Text('Jul 01 • \$420.00', style: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                    ]),
                  ]),
                  const SizedBox(height: 14),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: const LinearProgressIndicator(
                      value: 18550 / 31000,
                      minHeight: 8,
                      backgroundColor: Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation(Color(0xFF2563EB)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('PAID: \$18,550', style: TextStyle(fontFamily: 'Lato', fontSize: 10, color: Color(0xFF64748B))),
                    Text('TOTAL: \$31,000', style: TextStyle(fontFamily: 'Lato', fontSize: 10, color: Color(0xFF64748B))),
                  ]),
                  const SizedBox(height: 12),
                  Center(child: const Text('Loan & Payment Details', style: TextStyle(fontFamily: 'Lato', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2563EB)))),
                ]),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Advisor card ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Column(children: [
                  Row(children: [
                    Stack(children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)]),
                        ),
                        child: const Icon(Icons.person_rounded, size: 30, color: Colors.white),
                      ),
                      Positioned(
                        bottom: 2, right: 2,
                        child: Container(width: 14, height: 14, decoration: BoxDecoration(color: const Color(0xFF10B981), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))),
                      ),
                    ]),
                    const SizedBox(width: 14),
                    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Sarah Jenkins, CFP®', style: TextStyle(fontFamily: 'Lato', fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                      SizedBox(height: 2),
                      Text('Dedicated Retirement Specialist', style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF64748B))),
                      SizedBox(height: 4),
                      Row(children: [
                        Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                        Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                        Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                        Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                        Icon(Icons.star_half_rounded, size: 13, color: Color(0xFFF59E0B)),
                        SizedBox(width: 4),
                        Text('4.9 (120+ reviews)', style: TextStyle(fontFamily: 'Lato', fontSize: 11, color: Color(0xFF64748B))),
                      ]),
                    ])),
                  ]),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(12)),
                        alignment: Alignment.center,
                        child: const Text('Schedule Call', style: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                        alignment: Alignment.center,
                        child: const Text('Message', style: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                      ),
                    )),
                  ]),
                ]),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Complete Enrollment CTA ───────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () => context.push(AppRoutes.enrollmentReview),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 6))],
                  ),
                  alignment: Alignment.center,
                  child: const Text('Complete Enrollment', style: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text('© Congruent Solutions, Inc. All Rights Reserved', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Lato', fontSize: 11, color: Color(0xFF94A3B8))),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

// ── Trend painter ─────────────────────────────────────────────────────────────
class _TrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pts = [0.45, 0.5, 0.43, 0.55, 0.48, 0.60, 0.55, 0.68, 0.62, 0.72, 0.68, 0.80, 0.75, 0.88, 0.82, 1.0];
    final w = size.width;
    final h = size.height;
    final path = Path();
    for (int i = 0; i < pts.length; i++) {
      final x = (i / (pts.length - 1)) * w;
      final y = h - pts[i] * h;
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }

    // Fill
    final fill = Path.from(path);
    fill.lineTo(w, h); fill.lineTo(0, h); fill.close();
    canvas.drawPath(fill, Paint()..shader = LinearGradient(colors: [const Color(0xFF2563EB).withValues(alpha: 0.15), const Color(0xFF2563EB).withValues(alpha: 0)], begin: Alignment.topCenter, end: Alignment.bottomCenter).createShader(Rect.fromLTWH(0, 0, w, h)));

    // Line
    canvas.drawPath(path, Paint()..color = const Color(0xFF2563EB)..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round);
  }

  @override
  bool shouldRepaint(_TrendPainter _) => false;
}

// ── Score arc painter ─────────────────────────────────────────────────────────
class _ScoreArcPainter extends CustomPainter {
  final double progress;
  final Color track, fill;
  const _ScoreArcPainter(this.progress, this.track, this.fill);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 6..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final rect = Rect.fromLTWH(5, 5, size.width - 10, size.height - 10);
    paint.color = track;
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi, false, paint);
    paint.color = fill;
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, paint);
  }

  @override
  bool shouldRepaint(_ScoreArcPainter old) => old.progress != progress;
}

// ── Donut painter ─────────────────────────────────────────────────────────────
class _DonutSlice {
  final Color color;
  final double fraction;
  const _DonutSlice(this.color, this.fraction);
}

class _DonutPainter extends CustomPainter {
  final List<_DonutSlice> slices;
  const _DonutPainter(this.slices);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 20;
    double start = -math.pi / 2;
    for (final s in slices) {
      paint.color = s.color;
      final sweep = 2 * math.pi * s.fraction;
      canvas.drawArc(rect.deflate(10), start, sweep - 0.04, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) => false;
}

// ── Legend row ────────────────────────────────────────────────────────────────
class _LegendRow extends StatelessWidget {
  const _LegendRow(this.label, this.pct, this.color);
  final String label, pct;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 8),
      Expanded(child: Text(label, style: const TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF64748B)))),
      Text(pct, style: const TextStyle(fontFamily: 'Lato', fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
    ]);
  }
}

// ── Action row ────────────────────────────────────────────────────────────────
class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon, required this.iconBg, required this.iconColor,
    required this.badge, required this.badgeColor,
    required this.title, required this.subtitle,
  });
  final IconData icon;
  final Color iconBg, iconColor, badgeColor;
  final String badge, title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 22, color: iconColor)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
              child: Text(badge, style: TextStyle(fontFamily: 'Lato', fontSize: 9, fontWeight: FontWeight.w700, color: badgeColor, letterSpacing: 0.3)),
            ),
          ]),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
          Text(subtitle, style: const TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF64748B))),
        ])),
        const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 20),
      ]),
    );
  }
}

// ── Contribution row ──────────────────────────────────────────────────────────
class _ContribRow extends StatelessWidget {
  const _ContribRow({required this.label, required this.amount, required this.pct, required this.barColor, required this.barFraction});
  final String label, amount, pct;
  final Color barColor;
  final double barFraction;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(label, style: const TextStyle(fontFamily: 'Lato', fontSize: 13, color: Color(0xFF64748B)))),
        Text('$amount', style: const TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
        const SizedBox(width: 4),
        Text('($pct)', style: const TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF64748B))),
      ]),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: barFraction,
          minHeight: 6,
          backgroundColor: const Color(0xFFE2E8F0),
          valueColor: AlwaysStoppedAnimation(barColor),
        ),
      ),
    ]);
  }
}

// ── Activity row ──────────────────────────────────────────────────────────────
class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.icon, required this.iconBg, required this.iconColor,
    required this.title, required this.subtitle, required this.amount, required this.amountColor, required this.date,
  });
  final IconData icon;
  final Color iconBg, iconColor, amountColor;
  final String title, subtitle, amount, date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 20, color: iconColor)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
          Text(subtitle, style: const TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF64748B))),
          if (amount.isNotEmpty)
            Text(amount, style: TextStyle(fontFamily: 'Lato', fontSize: 13, fontWeight: FontWeight.w700, color: amountColor)),
        ])),
        Text(date, style: const TextStyle(fontFamily: 'Lato', fontSize: 11, color: Color(0xFF94A3B8))),
      ]),
    );
  }
}
