import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system/brand_assets.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/router/app_router.dart';

/// Pre-Enrollment Dashboard — matches Figma "dashboard" (2160:2112)
class PreEnrollmentDashboard extends ConsumerWidget {
  const PreEnrollmentDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value?.session?.user;
    final name = user?.userMetadata?['full_name']?.toString().split(' ').first ?? 'there';

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

          // ── Hero section ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good Morning, $name', style: const TextStyle(fontFamily: 'Lato', fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontFamily: 'Lato', fontSize: 30, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), height: 1.2, letterSpacing: -0.5),
                      children: [
                        TextSpan(text: "Let's build your "),
                        TextSpan(text: 'future', style: TextStyle(color: Color(0xFF2563EB))),
                        TextSpan(text: '\ntogether'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Secure your financial freedom by activating your company 401(k) plan today.',
                    style: TextStyle(fontFamily: 'Lato', fontSize: 14, color: Color(0xFF64748B), height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // Dashboard illustration card
                  _DashboardIllustration(),
                  const SizedBox(height: 28),

                  // CTA button
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.onboardingIntro),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF2563EB).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Start My Enrollment', style: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Feature chips row
                  Row(
                    children: [
                      _FeatureChip(icon: Icons.timer_outlined, label: 'Takes only 5 mins'),
                      const SizedBox(width: 12),
                      _FeatureChip(icon: Icons.verified_outlined, label: 'Secure enrollment'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _FeatureChip(icon: Icons.description_outlined, label: 'No paperwork'),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // ── Learning Center ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _LearningCard(onTap: () {}),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // ── CORE AI section ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _CoreAiSection(onTap: () => context.go(AppRoutes.aiAssistant)),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // ── Advisor card ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _AdvisorCard(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// ── Dashboard illustration ──────────────────────────────────────────────────
class _DashboardIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE0EAFF), Color(0xFFF0F4FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Mini dashboard card mockup
          Center(
            child: Transform.rotate(
              angle: -0.04,
              child: Container(
                width: 240,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 24, offset: const Offset(0, 8)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(6)),
                        child: const Icon(Icons.account_balance_outlined, size: 13, color: Color(0xFF2563EB)),
                      ),
                      const SizedBox(width: 6),
                      const Text('RETIREMENT HUB', style: TextStyle(fontFamily: 'Lato', fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
                    ]),
                    const SizedBox(height: 10),
                    const Text('Account Balance', style: TextStyle(fontFamily: 'Lato', fontSize: 9, color: Color(0xFF94A3B8))),
                    const Text('\$384,150.00', style: TextStyle(fontFamily: 'Lato', fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                    const SizedBox(height: 10),
                    Row(children: [
                      // Readiness score circle
                      Column(children: [
                        SizedBox(
                          width: 52, height: 52,
                          child: Stack(alignment: Alignment.center, children: [
                            CustomPaint(size: const Size(52, 52), painter: _ArcPainter(0.82)),
                            const Text('82%', style: TextStyle(fontFamily: 'Lato', fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                          ]),
                        ),
                        const SizedBox(height: 2),
                        const Text('On Track ✓', style: TextStyle(fontFamily: 'Lato', fontSize: 8, color: Color(0xFF10B981), fontWeight: FontWeight.w600)),
                      ]),
                      const SizedBox(width: 12),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Retirement\nReadiness Score', style: TextStyle(fontFamily: 'Lato', fontSize: 9, color: Color(0xFF64748B), height: 1.4)),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: const LinearProgressIndicator(
                              value: 0.82,
                              minHeight: 5,
                              backgroundColor: Color(0xFFE2E8F0),
                              valueColor: AlwaysStoppedAnimation(Color(0xFF10B981)),
                            ),
                          ),
                        ],
                      )),
                    ]),
                  ],
                ),
              ),
            ),
          ),

          // Floating arrow graphic (top right)
          Positioned(
            top: 16, right: 16,
            child: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.trending_up_rounded, color: Color(0xFF2563EB), size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  const _ArcPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(4, 4, size.width - 8, size.height - 8);
    paint.color = const Color(0xFFE2E8F0);
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi, false, paint);
    paint.color = const Color(0xFF10B981);
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, paint);
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.progress != progress;
}

// ── Feature chip ─────────────────────────────────────────────────────────────
class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 15, color: const Color(0xFF64748B)),
      const SizedBox(width: 5),
      Text(label, style: const TextStyle(fontFamily: 'Lato', fontSize: 13, color: Color(0xFF64748B))),
    ]);
  }
}

// ── Learning Center card ──────────────────────────────────────────────────────
class _LearningCard extends StatelessWidget {
  const _LearningCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.school_outlined, size: 26, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text('Retirement Learning Center', style: TextStyle(fontFamily: 'Lato', fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                  const SizedBox(width: 4),
                  const Icon(Icons.open_in_new, size: 14, color: Color(0xFF64748B)),
                ]),
                const SizedBox(height: 4),
                const Text(
                  "Everything you need to know about your 401(k), matching, and smart investing strategies.",
                  style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF64748B), height: 1.4),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onTap,
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('Explore Resources', style: TextStyle(fontFamily: 'Lato', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2563EB))),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF2563EB)),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── CORE AI section ───────────────────────────────────────────────────────────
class _CoreAiSection extends StatelessWidget {
  const _CoreAiSection({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E2D5A), Color(0xFF0F1A3D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.bolt, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('CORE AI', style: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
              Row(children: [
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                const SizedBox(width: 5),
                const Text('ONLINE', style: TextStyle(fontFamily: 'Lato', fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF10B981), letterSpacing: 0.5)),
              ]),
            ]),
          ]),
          const SizedBox(height: 16),
          const Text(
            'Need help with your plan? Ask me anything about your retirement benefits.',
            style: TextStyle(fontFamily: 'Lato', fontSize: 14, color: Colors.white70, height: 1.5),
          ),
          const SizedBox(height: 16),

          // Question chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _AiChip('What is employer match?'),
              _AiChip('Can I take a loan?'),
              _AiChip('How much should I contribute?'),
            ],
          ),
          const SizedBox(height: 20),

          // Ask button
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Ask CORE AI', style: TextStyle(fontFamily: 'Lato', fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AiChip extends StatelessWidget {
  const _AiChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(label, style: const TextStyle(fontFamily: 'Lato', fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
    );
  }
}

// ── Advisor card ──────────────────────────────────────────────────────────────
class _AdvisorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(children: [
                // Photo avatar
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)]),
                  ),
                  child: const Icon(Icons.person_rounded, color: Colors.white, size: 30),
                ),
                Positioned(
                  bottom: 2, right: 2,
                  child: Container(
                    width: 14, height: 14,
                    decoration: BoxDecoration(color: const Color(0xFF10B981), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                  ),
                ),
              ]),
              const SizedBox(width: 14),
              const Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Talk to a Retirement Advisor', style: TextStyle(fontFamily: 'Lato', fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                  SizedBox(height: 3),
                  Text('Get personalized guidance from a specialist.', style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF64748B), height: 1.4)),
                ],
              )),
            ],
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(12)),
                  alignment: Alignment.center,
                  child: const Text('Schedule', style: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  alignment: Alignment.center,
                  child: const Text('Message', style: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
