import 'package:flutter/material.dart';

/// Shared widgets for the onboarding wizard screens

class OnboardingInfoCard extends StatelessWidget {
  const OnboardingInfoCard({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.auto_awesome_outlined, size: 18, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 13,
                color: Color(0xFF64748B),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingStickyButton extends StatelessWidget {
  const OnboardingStickyButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.bottom,
  });
  final String label;
  final VoidCallback onTap;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00FFFFFF), Colors.white, Colors.white],
          stops: [0, 0.3, 1],
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + bottom),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
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
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 8 + (bottom > 0 ? 0 : 4)),
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
