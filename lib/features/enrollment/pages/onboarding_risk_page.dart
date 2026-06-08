import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../widgets/onboarding_widgets.dart';

/// Onboarding wizard step 3: "How comfortable are you with investment risk?"
/// Matches Figma frame "Enroll Wizard" (2230:4166) — Conservative/Balanced/Growth/Aggressive
class OnboardingRiskPage extends StatefulWidget {
  const OnboardingRiskPage({super.key});

  @override
  State<OnboardingRiskPage> createState() => _OnboardingRiskPageState();
}

class _OnboardingRiskPageState extends State<OnboardingRiskPage> {
  String _selected = 'Balanced';

  static const _options = [
    _RiskOption(
      title: 'Conservative',
      description: 'Focus on stability and capital preservation.',
      icon: Icons.shield_outlined,
    ),
    _RiskOption(
      title: 'Balanced',
      description: 'Equal mix of growth and safe-haven assets.',
      icon: Icons.balance_outlined,
    ),
    _RiskOption(
      title: 'Growth',
      description: 'Higher potential for returns with moderate risk.',
      icon: Icons.trending_up_outlined,
    ),
    _RiskOption(
      title: 'Aggressive',
      description: 'Maximize long-term growth through higher risk.',
      icon: Icons.bolt_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF0F172A)),
                    onPressed: () => context.pop(),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.enrollmentPlan),
                    child: const Text(
                      'Save & exit',
                      style: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How comfortable are you with investment risk?',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Risk option cards
                  ...(_options.map((opt) => _RiskCard(
                    option: opt,
                    isSelected: _selected == opt.title,
                    onTap: () => setState(() => _selected = opt.title),
                  ))),

                  const SizedBox(height: 20),

                  OnboardingInfoCard(text: 'Everything you need to know about your 401(k), matching, and smart investing strategies.'),
                ],
              ),
            ),
          ),

          OnboardingStickyButton(
            label: 'View My Plans',
            bottom: bottom,
            onTap: () => context.push(AppRoutes.enrollmentPlan),
          ),
        ],
      ),
    );
  }
}

class _RiskOption {
  const _RiskOption({required this.title, required this.description, required this.icon});
  final String title;
  final String description;
  final IconData icon;
}

class _RiskCard extends StatelessWidget {
  const _RiskCard({required this.option, required this.isSelected, required this.onTap});
  final _RiskOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                option.icon,
                size: 22,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    option.description,
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 13,
                      color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF2563EB), size: 22),
          ],
        ),
      ),
    );
  }
}
