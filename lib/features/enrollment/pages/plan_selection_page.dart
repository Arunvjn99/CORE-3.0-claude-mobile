import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../../../core/models/enrollment_model.dart';
import '../widgets/enrollment_scaffold.dart';

/// Choose Your Retirement Plan — Step 1/7
/// Matches Figma "Plan Selection" (2230:4291)
class PlanSelectionPage extends ConsumerStatefulWidget {
  const PlanSelectionPage({super.key});

  @override
  ConsumerState<PlanSelectionPage> createState() => _PlanSelectionPageState();
}

class _PlanSelectionPageState extends ConsumerState<PlanSelectionPage> {
  PlanType _selected = PlanType.traditional;

  void _next() {
    ref.read(enrollmentProvider.notifier).setPlan(_selected);
    context.push(AppRoutes.enrollmentContribution);
  }

  @override
  Widget build(BuildContext context) {
    return EnrollmentScaffold(
      stepName: 'Plan Selection',
      stepNumber: 1,
      totalSteps: 7,
      bottomButton: EnrollmentButton(label: 'Continue to Contribution', onTap: _next),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose Your Retirement Plan',
            style: TextStyle(fontFamily: 'Lato', fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), height: 1.2),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select the plan that best aligns with your financial goals and tax strategy.',
            style: TextStyle(fontFamily: 'Lato', fontSize: 15, color: Color(0xFF64748B), height: 1.5),
          ),
          const SizedBox(height: 24),

          // Traditional 401(k) card
          _PlanCard(
            title: 'Traditional 401(k)',
            subtitle: 'Pre-tax contributions',
            isSelected: _selected == PlanType.traditional,
            badge: 'RECOMMENDED',
            badgeColor: const Color(0xFF2563EB),
            benefits: [
              ('trending_down', 'Lower taxable income today', const Color(0xFF10B981)),
              ('card_giftcard', 'Employer match eligible', const Color(0xFF2563EB)),
              ('shield_outlined', 'Tax-deferred growth', const Color(0xFF2563EB)),
            ],
            aiInsight: 'Based on your age (36) and tax bracket, a Traditional 401(k) offers the highest immediate tax savings.',
            onTap: () => setState(() => _selected = PlanType.traditional),
          ),

          const SizedBox(height: 14),

          // Roth 401(k) card
          _PlanCard(
            title: 'Roth 401(k)',
            subtitle: 'Post-tax contributions',
            isSelected: _selected == PlanType.roth,
            badge: null,
            badgeColor: const Color(0xFF10B981),
            benefits: [
              ('check_circle_outline', 'Tax-free withdrawals in retirement', const Color(0xFF2563EB)),
              ('shuffle', 'Flexible retirement income', const Color(0xFF2563EB)),
              ('event_busy', 'No required minimum distributions', const Color(0xFF2563EB)),
            ],
            aiInsight: null,
            onTap: () => setState(() => _selected = PlanType.roth),
          ),

          const SizedBox(height: 20),

          // Bottom action buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.compare_arrows_rounded, size: 16, color: Color(0xFF0F172A)),
                        SizedBox(width: 6),
                        Text('Compare Plans', style: TextStyle(fontFamily: 'Lato', fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.aiAssistant),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Color(0xFF0F172A)),
                        SizedBox(width: 6),
                        Text('Ask CORE AI', style: TextStyle(fontFamily: 'Lato', fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.badge,
    required this.badgeColor,
    required this.benefits,
    required this.aiInsight,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final String? badge;
  final Color badgeColor;
  final List<(String, String, Color)> benefits;
  final String? aiInsight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? const Color(0xFF2563EB).withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(fontFamily: 'Lato', fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: const TextStyle(fontFamily: 'Lato', fontSize: 13, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
                          width: isSelected ? 2 : 1.5,
                        ),
                        color: Colors.white,
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                            )
                          : null,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Benefits
                ...benefits.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: b.$3.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(_iconForKey(b.$1), size: 15, color: b.$3),
                      ),
                      const SizedBox(width: 10),
                      Text(b.$2, style: const TextStyle(fontFamily: 'Lato', fontSize: 14, color: Color(0xFF0F172A))),
                    ],
                  ),
                )),

                // AI Insight
                if (aiInsight != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.auto_awesome_rounded, size: 16, color: Color(0xFF2563EB)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('AI INSIGHT', style: TextStyle(fontFamily: 'Lato', fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF2563EB), letterSpacing: 0.5)),
                              const SizedBox(height: 3),
                              Text(aiInsight!, style: const TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF2563EB), height: 1.4)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Badge
          if (badge != null)
            Positioned(
              top: -1,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(fontFamily: 'Lato', fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5),
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _iconForKey(String key) {
    switch (key) {
      case 'trending_down': return Icons.trending_down_rounded;
      case 'card_giftcard': return Icons.card_giftcard_outlined;
      case 'shield_outlined': return Icons.shield_outlined;
      case 'check_circle_outline': return Icons.check_circle_outline_rounded;
      case 'shuffle': return Icons.shuffle_rounded;
      case 'event_busy': return Icons.event_busy_outlined;
      default: return Icons.check_rounded;
    }
  }
}
