import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system/brand_assets.dart';
import '../../../core/router/app_router.dart';

/// Login Welcome screen — matches Figma "Login" frame (2121:761)
/// Shows 3D fintech illustration, CORE logo, tagline, Log in + Sign up CTAs
class LoginWelcomePage extends StatelessWidget {
  const LoginWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Illustration takes upper portion
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 3D Fintech illustration (placeholder with a styled card)
                _FintechIllustration(),
              ],
            ),
          ),

          // Bottom section
          Padding(
            padding: EdgeInsets.fromLTRB(24, 32, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // CORE logo
                SvgPicture.asset(
                  BrandAssets.coreLogoSvg,
                  width: 100,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 16),

                // Headline
                const Text(
                  'Empower your oversight',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF292670),
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                // Subtitle
                const Text(
                  "Sign in to gain clear visibility into every plan's performance",
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF64748B),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),

          // Divider + buttons
          const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

          Padding(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + bottom),
            child: Row(
              children: [
                // Log in — outlined
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.push(AppRoutes.login),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Sign up — filled blue
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.push(AppRoutes.signup),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Copyright
          Padding(
            padding: EdgeInsets.only(bottom: 8 + bottom),
            child: const Text(
              '© Congruent Solutions, Inc. All Rights Reserved',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 11,
                color: Color(0xFF667085),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// 3D fintech illustration — styled card matching Figma
class _FintechIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFF),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.show_chart, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'RETIREMENT HUB',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(0xFF2563EB),
                      child: Text(
                        'SJ',
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'SARAH JENKINS',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Balance + Score row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Account Balance',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '£384,150.00',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Mini chart line
                          CustomPaint(
                            size: const Size(100, 30),
                            painter: _MiniChartPainter(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Retirement Readiness Score
                    Column(
                      children: [
                        const Text(
                          'Retirement\nReadiness Score',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 10,
                            color: Color(0xFF94A3B8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 72,
                          height: 72,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: 0.82,
                                strokeWidth: 6,
                                backgroundColor: const Color(0xFFE2E8F0),
                                valueColor: const AlwaysStoppedAnimation(Color(0xFF10B981)),
                              ),
                              const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '82%',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    '82/100',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 9,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle, size: 10, color: Color(0xFF10B981)),
                              SizedBox(width: 2),
                              Text(
                                'On Track',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF059669),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final points = [0.0, 0.6, 0.4, 0.7, 0.3, 0.8, 0.5, 0.2, 0.9, 0.0];
    for (int i = 0; i < points.length; i += 2) {
      final x = (i / (points.length - 2)) * size.width;
      final y = points[i + 1] * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
