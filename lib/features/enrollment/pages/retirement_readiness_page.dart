import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../widgets/enrollment_scaffold.dart';

/// Retirement Readiness page — Step 6 of 7, 84% Complete
/// Matches Figma "Rediness" frame (2244:5591)
class RetirementReadinessPage extends StatefulWidget {
  const RetirementReadinessPage({super.key});

  @override
  State<RetirementReadinessPage> createState() => _RetirementReadinessPageState();
}

class _RetirementReadinessPageState extends State<RetirementReadinessPage> {
  bool _contributionApplied = false;
  bool _autoIncreaseApplied = false;

  int get _score => 82 + (_contributionApplied ? 5 : 0) + (_autoIncreaseApplied ? 8 : 0);

  @override
  Widget build(BuildContext context) {
    return EnrollmentScaffold(
      stepName: 'Retirement Readiness',
      stepNumber: 6,
      totalSteps: 7,
      bottomButton: EnrollmentButton(
        label: 'Continue to Review',
        onTap: () => context.push(AppRoutes.enrollmentReview),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EnrollmentHeading(
            title: 'Your Retirement Readiness',
            subtitle: 'See how your current enrollment choices track against your long-term retirement goals.',
          ),
          const SizedBox(height: 24),

          // Score card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Column(children: [
              SizedBox(
                width: 140, height: 140,
                child: Stack(alignment: Alignment.center, children: [
                  CustomPaint(size: const Size(140, 140), painter: _ScoreArcPainter(score: _score)),
                  Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('$_score', style: const TextStyle(fontFamily: 'Lato', fontSize: 40, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                    const Text('SCORE', style: TextStyle(fontFamily: 'Lato', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B), letterSpacing: 0.5)),
                  ]),
                ]),
              ),
              const SizedBox(height: 12),
              const Text('Strong Retirement Outlook', style: TextStyle(fontFamily: 'Lato', fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF059669))),
              const SizedBox(height: 6),
              const Text('Based on your current plan, you are on track to replace 85% of your pre-retirement income.', style: TextStyle(fontFamily: 'Lato', fontSize: 13, color: Color(0xFF64748B), height: 1.5), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFE2E8F0)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: _IncomeCol(label: 'PROJECTED INCOME', value: '\$6,400/mo')),
                const VerticalDivider(color: Color(0xFFE2E8F0), width: 1),
                Expanded(child: _IncomeCol(label: 'INCOME TARGET', value: '\$7,500/mo')),
              ]),
            ]),
          ),

          const SizedBox(height: 20),

          // Improve Your Score
          Row(children: [
            const Expanded(child: Text('Improve Your Score', style: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(20)),
              child: const Text('3 SUGGESTIONS', style: TextStyle(fontFamily: 'Lato', fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF2563EB))),
            ),
          ]),

          const SizedBox(height: 12),

          // Suggestion 1
          _SuggestionCard(
            icon: Icons.trending_up,
            title: 'Increase Contribution to 12%',
            subtitle: 'Adds +5 to Readiness Score',
            applied: _contributionApplied,
            onApply: () => setState(() => _contributionApplied = !_contributionApplied),
          ),
          const SizedBox(height: 10),

          // Suggestion 2
          _SuggestionCard(
            icon: Icons.auto_awesome_outlined,
            title: 'Enable Auto Increase',
            subtitle: 'Adds +8 to Readiness Score',
            applied: _autoIncreaseApplied,
            onApply: () => setState(() => _autoIncreaseApplied = !_autoIncreaseApplied),
          ),

          const SizedBox(height: 20),

          // Plan Summary
          const Text('PLAN SUMMARY', style: TextStyle(fontFamily: 'Lato', fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.8)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Column(children: [
              _SummaryRow(label: 'Income Goal', value: '\$1.8M'),
              _SummaryRow(label: 'Current Savings', value: '\$12,000'),
              _SummaryRow(label: 'Annual Contributions', value: '+\$19,200', valueColor: const Color(0xFF059669)),
              _SummaryRow(label: 'Projected Gap', value: '-\$240,000', valueColor: const Color(0xFFEF4444), last: true),
            ]),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _ScoreArcPainter extends CustomPainter {
  const _ScoreArcPainter({required this.score});
  final int score;
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 12.0;
    const radius = 62.0;
    final bgPaint = Paint()..style = PaintingStyle.stroke..strokeWidth = strokeWidth..color = const Color(0xFFE2E8F0)..strokeCap = StrokeCap.round;
    final fgPaint = Paint()..style = PaintingStyle.stroke..strokeWidth = strokeWidth..color = const Color(0xFF10B981)..strokeCap = StrokeCap.round;
    const startAngle = math.pi * 0.7;
    const sweepAngle = math.pi * 1.6;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, false, bgPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle * (score / 100), false, fgPaint);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _IncomeCol extends StatelessWidget {
  const _IncomeCol({required this.label, required this.value});
  final String label; final String value;
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(label, style: const TextStyle(fontFamily: 'Lato', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
    const SizedBox(height: 4),
    Text(value, style: const TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
  ]);
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.icon, required this.title, required this.subtitle, required this.applied, required this.onApply});
  final IconData icon; final String title; final String subtitle; final bool applied; final VoidCallback onApply;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 18, color: const Color(0xFF2563EB))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
          Text(subtitle, style: const TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF64748B))),
        ])),
        const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: GestureDetector(
          onTap: onApply,
          child: Container(
            height: 40,
            decoration: BoxDecoration(color: applied ? const Color(0xFF059669) : const Color(0xFF2563EB), borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: Text(applied ? 'Applied ✓' : 'Apply Recommendation', style: const TextStyle(fontFamily: 'Lato', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        )),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 40, padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
            alignment: Alignment.center,
            child: const Text('Dismiss', style: TextStyle(fontFamily: 'Lato', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
          ),
        ),
      ]),
    ]),
  );
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.valueColor, this.last = false});
  final String label; final String value; final Color? valueColor; final bool last;
  @override
  Widget build(BuildContext context) => Column(children: [
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        Expanded(child: Text(label, style: const TextStyle(fontFamily: 'Lato', fontSize: 14, color: Color(0xFF64748B)))),
        Text(value, style: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w700, color: valueColor ?? const Color(0xFF0F172A))),
      ]),
    ),
    if (!last) const Divider(height: 1, color: Color(0xFFE2E8F0)),
  ]);
}
