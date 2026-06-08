import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_colors.dart';

/// 3-Screen Walkthrough — Illustrated feature introduction
/// Screens: Dashboard Overview · CORE AI Chat · Easy Enrollment
///
/// FIX NOTE: Each slide is immediately visible (no zero-opacity start).
/// The slide-in animation begins from offset (not opacity) so content
/// is always rendered — no blank first frame.
class WalkthroughPage extends StatefulWidget {
  const WalkthroughPage({super.key});

  @override
  State<WalkthroughPage> createState() => _WalkthroughPageState();
}

class _WalkthroughPageState extends State<WalkthroughPage> {
  final _pageCtrl = PageController();
  int _page = 0;

  Future<void> _done() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) context.go('/login');
  }

  void _next() {
    if (_page < 2) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _done();
    }
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final topPad = MediaQuery.of(context).padding.top;
    final isLast = _page == 2;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // ── Top bar: dots + skip ─────────────────────────────────
            SizedBox(
              height: topPad + 56,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, topPad + 12, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(3, (i) {
                        final active = i == _page;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 6),
                          width: active ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.lightTextPrimary
                                : AppColors.lightBorder,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    if (!isLast)
                      GestureDetector(
                        onTap: _done,
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 32),
                  ],
                ),
              ),
            ),

            // ── Pages ─────────────────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (i) => setState(() => _page = i),
                children: const [
                  _SlideOne(),
                  _SlideTwo(),
                  _SlideThree(),
                ],
              ),
            ),

            // ── CTA buttons ───────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, bottomPad + 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _WalkButton(
                    label: isLast ? 'Get Started' : 'Continue',
                    filled: true,
                    onTap: _next,
                  ),
                  if (!isLast) ...[
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: _done,
                      child: const Text(
                        'Already have an account? Sign in',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SLIDE SHELLS — Each uses LayoutBuilder to know actual available height
// Content is ALWAYS visible (no fade-in from 0 on first frame)
// ═══════════════════════════════════════════════════════════════════════════

class _SlideOne extends StatelessWidget {
  const _SlideOne();

  @override
  Widget build(BuildContext context) {
    return _SlideLayout(
      accentColor: const Color(0xFF4F46E5),
      badge: '📊  RETIREMENT TRACKING',
      title: 'Your future,\nat a glance',
      subtitle:
          'See your balance, readiness score, and portfolio — beautifully clear.',
      illustration: const _DashboardCard(),
    );
  }
}

class _SlideTwo extends StatelessWidget {
  const _SlideTwo();

  @override
  Widget build(BuildContext context) {
    return _SlideLayout(
      accentColor: const Color(0xFF7C3AED),
      badge: '🤖  CORE AI ASSISTANT',
      title: 'Ask anything,\nget answers instantly',
      subtitle:
          'CORE AI gives personalized advice on loans, investments, and retirement.',
      illustration: const _AiCard(),
    );
  }
}

class _SlideThree extends StatelessWidget {
  const _SlideThree();

  @override
  Widget build(BuildContext context) {
    return _SlideLayout(
      accentColor: const Color(0xFF059669),
      badge: '⚡  QUICK ENROLLMENT',
      title: 'Enrolled in just\n5 minutes',
      subtitle:
          'Three simple steps. Activate your plan and claim your employer match.',
      illustration: const _EnrollCard(),
    );
  }
}

// ─── Shared slide layout ─────────────────────────────────────────────────
class _SlideLayout extends StatelessWidget {
  final Color accentColor;
  final String badge;
  final String title;
  final String subtitle;
  final Widget illustration;

  const _SlideLayout({
    required this.accentColor,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalH = constraints.maxHeight;
        // Give 58% to illustration, 42% to text
        final illustH = totalH * 0.58;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Illustration — fixed height from layout
            SizedBox(
              height: illustH,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: illustration,
              ),
            ),

            // Text area — takes remaining space
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 16, 28, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Heading
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.lightTextPrimary,
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.lightTextSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ILLUSTRATION 1 — Dashboard card
// ═══════════════════════════════════════════════════════════════════════════
class _DashboardCard extends StatelessWidget {
  const _DashboardCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            color: const Color(0xFF4F46E5),
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Portfolio',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.white70),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.trending_up, size: 11, color: Colors.white),
                          SizedBox(width: 4),
                          Text('+7.2% YTD',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('\$142,893',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5)),
                const Text('Total Balance',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: Colors.white60)),
              ],
            ),
          ),
          // Readiness bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Retirement Readiness',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.lightTextPrimary)),
                    const Text('68%',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF4F46E5))),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.68,
                    backgroundColor: Color(0xFFE0E7FF),
                    valueColor:
                        AlwaysStoppedAnimation(Color(0xFF4F46E5)),
                    minHeight: 7,
                  ),
                ),
                const SizedBox(height: 12),
                // Mini bar chart
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Bar('Jan', 24, const Color(0xFFE0E7FF)),
                    _Bar('Feb', 32, const Color(0xFFE0E7FF)),
                    _Bar('Mar', 26, const Color(0xFFE0E7FF)),
                    _Bar('Apr', 38, const Color(0xFFE0E7FF)),
                    _Bar('May', 30, const Color(0xFFE0E7FF)),
                    _Bar('Jun', 44, const Color(0xFF4F46E5)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _Pill('US Equity 55%', const Color(0xFF4F46E5)),
                    const SizedBox(width: 6),
                    _Pill('Intl 25%', const Color(0xFF7C3AED)),
                    const SizedBox(width: 6),
                    _Pill('Bonds 20%', const Color(0xFF06B6D4)),
                  ],
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final double height;
  final Color color;
  const _Bar(this.label, this.height, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: height,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(5)),
        ),
        const SizedBox(height: 3),
        Text(label,
            style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 8,
                color: AppColors.lightTextMuted)),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  const _Pill(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: color)),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ILLUSTRATION 2 — CORE AI chat
// ═══════════════════════════════════════════════════════════════════════════
class _AiCard extends StatelessWidget {
  const _AiCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AI Header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome,
                      size: 18, color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CORE AI',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                      Text('Your retirement advisor',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              color: Colors.white70)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    children: [
                      Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                              color: Color(0xFF4ADE80),
                              shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      const Text('Online',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Chat messages
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // User bubble
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 220),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 9),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4F46E5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                        bottomLeft: Radius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Should I enroll in the 401(k) now?',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.white,
                          height: 1.4),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // AI bubble
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 230),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F3FF),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      ),
                      border: Border.all(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.15)),
                    ),
                    child: const Text(
                      'Absolutely! Enroll now to claim your employer\'s 3% match — that\'s \$1,800/year FREE. 🎉',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.lightTextPrimary,
                          height: 1.4),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Action chip
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bolt, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Text('Start enrollment →',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Input bar mock
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: AppColors.lightBorder),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text('Ask CORE AI anything…',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: AppColors.lightTextMuted)),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                            color: Color(0xFF4F46E5),
                            shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_upward_rounded,
                            size: 14, color: Colors.white),
                      ),
                    ],
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

// ═══════════════════════════════════════════════════════════════════════════
// ILLUSTRATION 3 — Enrollment steps
// ═══════════════════════════════════════════════════════════════════════════
class _EnrollCard extends StatelessWidget {
  const _EnrollCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF059669).withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            color: const Color(0xFF059669),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.rocket_launch_rounded,
                      size: 18, color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quick Enrollment',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                      Text('3 steps · About 5 minutes',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              color: Colors.white70)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.timer_rounded, size: 11, color: Colors.white),
                      SizedBox(width: 4),
                      Text('5 min',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Steps
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Step(1, 'Choose Your Plan', 'Traditional or Roth 401(k)',
                    done: true),
                _Connector(done: true),
                _Step(2, 'Set Contribution', '6% of salary = \$300/mo',
                    done: true),
                _Connector(done: false),
                _Step(3, 'Review & Submit', 'Confirm and activate plan',
                    done: false, active: true),
                const SizedBox(height: 12),

                // Match reveal
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFF059669).withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.card_giftcard_rounded,
                            size: 18, color: Color(0xFF059669)),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('🎉 Employer adds 3% FREE',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.lightTextPrimary)),
                            SizedBox(height: 1),
                            Text('Up to \$1,800/year in free money',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    color: AppColors.lightTextSecondary)),
                          ],
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
    );
  }
}

class _Step extends StatelessWidget {
  final int n;
  final String title;
  final String sub;
  final bool done;
  final bool active;
  const _Step(this.n, this.title, this.sub,
      {required this.done, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: done
                ? const Color(0xFF059669)
                : active
                    ? const Color(0xFF059669).withValues(alpha: 0.1)
                    : const Color(0xFFF3F4F6),
            shape: BoxShape.circle,
            border: active
                ? Border.all(color: const Color(0xFF059669), width: 1.5)
                : null,
          ),
          child: done
              ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
              : Center(
                  child: Text('$n',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: active
                              ? const Color(0xFF059669)
                              : AppColors.lightTextMuted))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: done || active
                          ? AppColors.lightTextPrimary
                          : AppColors.lightTextMuted)),
              Text(sub,
                  style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: AppColors.lightTextSecondary)),
            ],
          ),
        ),
        if (done)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Text('Done',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF059669))),
          ),
      ],
    );
  }
}

class _Connector extends StatelessWidget {
  final bool done;
  const _Connector({required this.done});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Container(
        width: 2,
        height: 14,
        color: done ? const Color(0xFF059669) : AppColors.lightBorder,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CTA BUTTON
// ═══════════════════════════════════════════════════════════════════════════
class _WalkButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;
  const _WalkButton(
      {required this.label, required this.filled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        width: double.infinity,
        decoration: BoxDecoration(
          color: filled ? AppColors.lightTextPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: filled
              ? null
              : Border.all(color: AppColors.lightBorder, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: filled ? Colors.white : AppColors.lightTextPrimary,
          ),
        ),
      ),
    );
  }
}
