import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../widgets/enrollment_scaffold.dart';

/// Review & Submit page — Step 7 of 7, 100% Complete
/// Matches Figma "Review" frame (2244:6103)
class ReviewEnrollmentPage extends ConsumerStatefulWidget {
  const ReviewEnrollmentPage({super.key});

  @override
  ConsumerState<ReviewEnrollmentPage> createState() => _ReviewEnrollmentPageState();
}

class _ReviewEnrollmentPageState extends ConsumerState<ReviewEnrollmentPage> {
  bool _agreed = false;
  bool _loading = false;

  Future<void> _complete() async {
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please agree to Terms and Conditions.')));
      return;
    }
    setState(() => _loading = true);
    await ref.read(enrollmentProvider.notifier).complete();
    if (!mounted) return;
    setState(() => _loading = false);
    context.go(AppRoutes.enrollmentSuccess);
  }

  @override
  Widget build(BuildContext context) {
    return EnrollmentScaffold(
      stepName: 'Review & Submit',
      stepNumber: 7,
      totalSteps: 7,
      bottomButton: Column(mainAxisSize: MainAxisSize.min, children: [
        // Terms checkbox
        GestureDetector(
          onTap: () => setState(() => _agreed = !_agreed),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 22, height: 22,
              decoration: BoxDecoration(
                color: _agreed ? const Color(0xFF2563EB) : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: _agreed ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0), width: 2),
              ),
              child: _agreed ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
            const SizedBox(width: 10),
            const Expanded(child: Text.rich(
              TextSpan(
                style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF64748B), height: 1.5),
                children: [
                  TextSpan(text: 'I have read and agree to the '),
                  TextSpan(text: 'Terms and Conditions', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600, decoration: TextDecoration.underline)),
                  TextSpan(text: ' and have reviewed the '),
                  TextSpan(text: 'Plan Disclosure Documents', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600, decoration: TextDecoration.underline)),
                ],
              ),
            )),
          ]),
        ),
        const SizedBox(height: 16),
        EnrollmentButton(label: 'Complete Enrollment', onTap: _complete, loading: _loading),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EnrollmentHeading(
            title: 'Review Your Retirement Plan',
            subtitle: 'Review your selections carefully before finalizing your enrollment.',
          ),
          const SizedBox(height: 24),

          // Hero card — projected balance
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Expanded(child: Text('PROJECTED BALANCE AT 62', style: TextStyle(fontFamily: 'Lato', fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white70, letterSpacing: 0.5))),
                Container(width: 32, height: 32, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.trending_up, color: Colors.white, size: 18)),
              ]),
              const SizedBox(height: 8),
              const Text('\$1,420,000', style: TextStyle(fontFamily: 'Lato', fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('MONTHLY INCOME', style: TextStyle(fontFamily: 'Lato', fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white70, letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  const Text('\$6,400', style: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                ])),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('TOTAL MATCH', style: TextStyle(fontFamily: 'Lato', fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white70, letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  const Text('+\$240k', style: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                ])),
              ]),
            ]),
          ),

          const SizedBox(height: 24),

          // Plan Configuration
          const Text('Plan Configuration', style: TextStyle(fontFamily: 'Lato', fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
          const SizedBox(height: 12),

          _ConfigRow(label: 'PLAN TYPE', icon: Icons.check_circle_outline, title: 'Traditional 401(k)', onEdit: () => context.push(AppRoutes.enrollmentPlan)),
          _ConfigRow(label: 'CONTRIBUTION', icon: Icons.schedule_outlined, title: '10% of Paycheck', subtitle: '\$840/mo', onEdit: () => context.push(AppRoutes.enrollmentContribution)),
          _ConfigRow(label: 'TAX ALLOCATION', icon: Icons.account_balance_outlined, title: '100% Pre-Tax', onEdit: () => context.push(AppRoutes.enrollmentSource)),
          _ConfigRow(label: 'AUTO INCREASE', icon: Icons.trending_up_outlined, title: 'Enabled', subtitle: '+1% annually, Cap 15%', onEdit: () => context.push(AppRoutes.enrollmentAutoIncrease)),
          _ConfigRow(label: 'INVESTMENT STRATEGY', icon: Icons.shield_outlined, title: 'Balanced Growth', subtitle: '60% Stocks, 30% Bonds, 10% Other', onEdit: () => context.push(AppRoutes.enrollmentInvestment), last: true),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _ConfigRow extends StatelessWidget {
  const _ConfigRow({required this.label, required this.icon, required this.title, this.subtitle, required this.onEdit, this.last = false});
  final String label; final IconData icon; final String title; final String? subtitle; final VoidCallback onEdit; final bool last;
  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(bottom: last ? 0 : 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(label, style: const TextStyle(fontFamily: 'Lato', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
        const Spacer(),
        GestureDetector(onTap: onEdit, child: const Text('Edit', style: TextStyle(fontFamily: 'Lato', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2563EB)))),
      ]),
      const SizedBox(height: 8),
      Row(children: [
        Container(width: 32, height: 32, decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 16, color: const Color(0xFF2563EB))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
          if (subtitle != null) Text(subtitle!, style: const TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF64748B))),
        ])),
      ]),
    ]),
  );
}
