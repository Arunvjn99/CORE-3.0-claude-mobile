import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../widgets/onboarding_widgets.dart';

/// Onboarding wizard step 2: "Do you already have retirement savings?"
/// Matches Figma frame "Enroll Wizard" (2230:3966)
class OnboardingSavingsPage extends StatefulWidget {
  const OnboardingSavingsPage({super.key});

  @override
  State<OnboardingSavingsPage> createState() => _OnboardingSavingsPageState();
}

class _OnboardingSavingsPageState extends State<OnboardingSavingsPage> {
  int _savings = 12000;
  static const _retirementAge = 62;
  static const _currentAge = 36;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final yearsRemaining = _retirementAge - _currentAge;

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
                    'Do you already have retirement savings?',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Big dollar amount input
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              '\$',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _formatAmount(_savings),
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _savings == 0 ? 'I am just getting started' : 'Current savings',
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 13,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: const Color(0xFF2563EB),
                            inactiveTrackColor: const Color(0xFFE2E8F0),
                            thumbColor: const Color(0xFF2563EB),
                            overlayColor: const Color(0x202563EB),
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                          ),
                          child: Slider(
                            value: _savings.toDouble(),
                            min: 0,
                            max: 500000,
                            divisions: 500,
                            onChanged: (v) => setState(() => _savings = v.round()),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // YOUR SNAPSHOT card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'YOUR SNAPSHOT',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF64748B),
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _SnapshotItem(
                                label: 'Retirement Age',
                                value: '$_retirementAge',
                              ),
                            ),
                            Expanded(
                              child: _SnapshotItem(
                                label: 'Years Remaining',
                                value: '$yearsRemaining',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _SnapshotItem(
                          label: 'Current Savings',
                          value: '\$${_formatAmount(_savings)}',
                          valueColor: const Color(0xFF2563EB),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  OnboardingInfoCard(text: 'Everything you need to know about your 401(k), matching, and smart investing strategies.'),
                ],
              ),
            ),
          ),

          OnboardingStickyButton(
            label: 'Next',
            bottom: bottom,
            onTap: () => context.push(AppRoutes.onboardingRisk),
          ),
        ],
      ),
    );
  }

  String _formatAmount(int amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)},${(amount % 1000).toString().padLeft(3, '0')}';
    }
    return amount.toString();
  }
}

class _SnapshotItem extends StatelessWidget {
  const _SnapshotItem({required this.label, required this.value, this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Lato',
            fontSize: 13,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: valueColor ?? const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
