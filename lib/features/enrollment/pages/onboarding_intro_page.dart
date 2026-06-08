import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';

/// Onboarding intro — "Let's tailor your retirement plan"
/// Matches Figma frame 2226:3529
class OnboardingIntroPage extends StatelessWidget {
  const OnboardingIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Top row: back button + Skip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.preEnrollmentDashboard),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.shield_outlined, size: 20, color: Color(0xFF2563EB)),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.enrollmentPlan),
                    child: const Text(
                      'Skip',
                      style: TextStyle(fontFamily: 'Lato', fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Wave emoji
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E7FF),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('👋', style: TextStyle(fontSize: 36)),
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Hi Arun',
                          style: TextStyle(fontFamily: 'Lato', fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Let's tailor your retirement plan.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Lato', fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), height: 1.2),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Answer a few quick questions and we'll recommend the right retirement strategy for you.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Lato', fontSize: 16, color: Color(0xFF64748B), height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Feature list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  _FeatureRow(
                    icon: Icons.access_time_rounded,
                    label: 'Takes less than 3 minutes',
                    color: const Color(0xFF2563EB),
                  ),
                  const SizedBox(height: 16),
                  _FeatureRow(
                    icon: Icons.lock_outline_rounded,
                    label: 'Secure and private',
                    color: const Color(0xFF2563EB),
                  ),
                  const SizedBox(height: 16),
                  _FeatureRow(
                    icon: Icons.auto_awesome_rounded,
                    label: 'AI-powered recommendations',
                    color: const Color(0xFF2563EB),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // AI FAB style button
            Padding(
              padding: const EdgeInsets.only(right: 24, bottom: 32),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.onboardingLocation),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF2563EB),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 26),
                  ),
                ),
              ),
            ),

            const Text(
              '© Congruent Solutions, Inc. All Rights Reserved',
              style: TextStyle(fontFamily: 'Lato', fontSize: 11, color: Color(0xFF94A3B8)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontFamily: 'Lato', fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
          ),
        ],
      ),
    );
  }
}
