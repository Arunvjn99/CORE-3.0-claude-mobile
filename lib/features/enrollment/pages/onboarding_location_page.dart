import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../widgets/onboarding_widgets.dart';

/// Onboarding wizard step 1: "Where do you imagine retiring?"
/// Matches Figma frame "Enroll Wizard" (2226:3861)
class OnboardingLocationPage extends StatefulWidget {
  const OnboardingLocationPage({super.key});

  @override
  State<OnboardingLocationPage> createState() => _OnboardingLocationPageState();
}

class _OnboardingLocationPageState extends State<OnboardingLocationPage> {
  String? _selected = 'Arizona';
  final _searchCtrl = TextEditingController();

  static const _suggestedStates = [
    'Arizona', 'Florida', 'Texas', 'North Carolina', 'Tennessee',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Top bar ─────────────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF0F172A)),
                    onPressed: () => context.go(AppRoutes.loginWelcome),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.enrollmentPlan),
                    child: const Text(
                      'Save & exit',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Where do you imagine retiring?',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Search bar
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        const Icon(Icons.search, size: 20, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Theme(
                            data: ThemeData(
                              brightness: Brightness.light,
                              inputDecorationTheme: const InputDecorationTheme(
                                filled: true,
                                fillColor: Color(0xFFF8FAFC),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                            child: TextField(
                              controller: _searchCtrl,
                              decoration: const InputDecoration(
                                hintText: 'Search cities or states',
                                hintStyle: TextStyle(fontFamily: 'Lato', fontSize: 14, color: Color(0xFF94A3B8)),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 8),
                                filled: true,
                                fillColor: Color(0xFFF8FAFC),
                              ),
                              style: const TextStyle(fontFamily: 'Lato', fontSize: 14, color: Color(0xFF0F172A)),
                              cursorColor: const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Suggested Locations',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // State chips
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _suggestedStates.map((s) {
                      final isSelected = _selected == s;
                      return GestureDetector(
                        onTap: () => setState(() => _selected = s),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF2563EB) : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Text(
                            s,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Info card
                  OnboardingInfoCard(
                    text: 'Everything you need to know about your 401(k), matching, and smart investing strategies.',
                  ),
                ],
              ),
            ),
          ),

          // ── Sticky bottom button ────────────────────────────────────
          OnboardingStickyButton(
            label: 'Next',
            bottom: bottom,
            onTap: () => context.push(AppRoutes.onboardingSavings),
          ),
        ],
      ),
    );
  }
}

