import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';

/// Shared enrollment flow scaffold matching Figma design.
/// Shows sticky header: back | ENROLLMENT/StepName | Save&Exit pill
/// + progress bar with Step X of Y + XX% Complete
class EnrollmentScaffold extends StatelessWidget {
  const EnrollmentScaffold({
    super.key,
    required this.stepName,
    required this.stepNumber,
    required this.totalSteps,
    required this.child,
    required this.bottomButton,
    this.scrollController,
  });

  final String stepName;
  final int stepNumber;
  final int totalSteps;
  final Widget child;
  final Widget bottomButton;
  final ScrollController? scrollController;

  double get _progress => stepNumber / totalSteps;
  int get _percentComplete => (_progress * 100).round();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Sticky header ─────────────────────────────────────────────
          _EnrollmentHeader(
            stepName: stepName,
            stepNumber: stepNumber,
            totalSteps: totalSteps,
            percentComplete: _percentComplete,
            progress: _progress,
          ),

          // ── Scrollable content ────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: child,
            ),
          ),

          // ── Sticky bottom button ──────────────────────────────────────
          _StickyFooter(button: bottomButton),
        ],
      ),
    );
  }
}

class _EnrollmentHeader extends StatelessWidget {
  const _EnrollmentHeader({
    required this.stepName,
    required this.stepNumber,
    required this.totalSteps,
    required this.percentComplete,
    required this.progress,
  });

  final String stepName;
  final int stepNumber;
  final int totalSteps;
  final int percentComplete;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          border: const Border(
            bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Row: back | ENROLLMENT\nStepName | Save&Exit
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: [
                    // Back button
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF0F172A)),
                        onPressed: () => context.pop(),
                      ),
                    ),

                    // Center: ENROLLMENT + step name
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'ENROLLMENT',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF64748B),
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            stepName,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F172A),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Save & Exit pill
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.preEnrollmentDashboard),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Save & Exit',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Step count + percent
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step $stepNumber of $totalSteps',
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      '$percentComplete% Complete',
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // Progress bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF2563EB)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StickyFooter extends StatelessWidget {
  const _StickyFooter({required this.button});
  final Widget button;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00FFFFFF), Colors.white, Colors.white],
          stops: [0, 0.25, 1],
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          button,
          const SizedBox(height: 8),
          const Text(
            '© Congruent Solutions, Inc. All Rights Reserved',
            style: TextStyle(fontFamily: 'Lato', fontSize: 11, color: Color(0xFF667085)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Standard blue CTA button used in enrollment flow
class EnrollmentButton extends StatelessWidget {
  const EnrollmentButton({super.key, required this.label, required this.onTap, this.loading = false});

  final String label;
  final VoidCallback onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF2563EB),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: loading
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

/// Section heading used across enrollment pages
class EnrollmentHeading extends StatelessWidget {
  const EnrollmentHeading({super.key, required this.title, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Lato',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
            height: 1.2,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}

/// CORE AI Insight card used in enrollment pages
class CoreAiInsightCard extends StatelessWidget {
  const CoreAiInsightCard({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.auto_awesome_outlined, size: 16, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CORE AI Insight',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    height: 1.5,
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
