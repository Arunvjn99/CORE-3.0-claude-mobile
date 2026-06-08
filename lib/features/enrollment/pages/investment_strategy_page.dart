import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../widgets/enrollment_scaffold.dart';

/// Investment Strategy page — Step 5 of 7, 70% Complete
/// Matches Figma "Investements" frame (2244:5336)
class InvestmentStrategyPage extends StatefulWidget {
  const InvestmentStrategyPage({super.key});

  @override
  State<InvestmentStrategyPage> createState() => _InvestmentStrategyPageState();
}

class _InvestmentStrategyPageState extends State<InvestmentStrategyPage> {
  String _selected = 'default';

  @override
  Widget build(BuildContext context) {
    return EnrollmentScaffold(
      stepName: 'Investment Strategy',
      stepNumber: 5,
      totalSteps: 7,
      bottomButton: EnrollmentButton(
        label: 'Continue to Readiness',
        onTap: () => context.push(AppRoutes.enrollmentReadiness),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EnrollmentHeading(
            title: 'Your Investment Strategy',
            subtitle: 'Choose how your money is invested to balance growth and risk.',
          ),
          const SizedBox(height: 24),

          // Plan Default Portfolio card
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () => setState(() => _selected = 'default'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: _selected == 'default' ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0), width: _selected == 'default' ? 2 : 1),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Plan Default Portfolio', style: TextStyle(fontFamily: 'Lato', fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                        const SizedBox(height: 2),
                        const Text('Default Investment', style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF64748B))),
                      ])),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 24, height: 24,
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: _selected == 'default' ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0), width: 2)),
                        child: _selected == 'default' ? const Center(child: CircleAvatar(radius: 6, backgroundColor: Color(0xFF2563EB))) : null,
                      ),
                    ]),
                    const SizedBox(height: 16),
                    // Allocation breakdown
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
                      child: Row(children: [
                        // Donut chart placeholder
                        SizedBox(
                          width: 72, height: 72,
                          child: CustomPaint(painter: _DonutPainter()),
                        ),
                        const SizedBox(width: 20),
                        Expanded(child: Wrap(spacing: 12, runSpacing: 6, children: const [
                          _Legend(color: Color(0xFF2563EB), label: 'Stocks (60%)'),
                          _Legend(color: Color(0xFF10B981), label: 'Bonds (30%)'),
                          _Legend(color: Color(0xFFAD46FF), label: 'Intl (5%)'),
                          _Legend(color: Color(0xFFFF8904), label: 'Cash (5%)'),
                        ])),
                      ]),
                    ),
                    const Divider(height: 20, color: Color(0xFFE2E8F0)),
                    Row(children: [
                      Expanded(child: _StatCol(label: 'RISK', value: 'Moderate')),
                      const VerticalDivider(color: Color(0xFFE2E8F0), width: 1),
                      Expanded(child: _StatCol(label: 'EXP. RETURN', value: '7.2%')),
                      const VerticalDivider(color: Color(0xFFE2E8F0), width: 1),
                      Expanded(child: _StatCol(label: 'TIME', value: '15+ Yrs')),
                    ]),
                  ]),
                ),
              ),
              // AI Recommended badge
              Positioned(
                top: -10, right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(999), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))]),
                  child: const Text('AI RECOMMENDED', style: TextStyle(fontFamily: 'Lato', fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Custom Portfolio card
          GestureDetector(
            onTap: () => setState(() => _selected = 'custom'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _selected == 'custom' ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0), width: _selected == 'custom' ? 2 : 1),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Text('Custom Portfolio', style: TextStyle(fontFamily: 'Lato', fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                      SizedBox(width: 8),
                      _Badge(label: 'ADVANCED'),
                    ]),
                    SizedBox(height: 2),
                    Text('Select individual funds yourself', style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF64748B))),
                  ])),
                  Container(width: 24, height: 24, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFE2E8F0), width: 2))),
                ]),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF2563EB))),
                  alignment: Alignment.center,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.tune, size: 16, color: Color(0xFF2563EB)),
                    const SizedBox(width: 8),
                    const Text('Build My Own Portfolio', style: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2563EB))),
                  ]),
                ),
              ]),
            ),
          ),

          const SizedBox(height: 16),

          // Advisor card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(24)),
            child: Row(children: [
              Stack(children: [
                const CircleAvatar(radius: 24, backgroundColor: Color(0xFF2563EB), child: Text('SR', style: TextStyle(fontFamily: 'Lato', fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white))),
                Positioned(bottom: 0, right: 0, child: Container(width: 12, height: 12, decoration: BoxDecoration(color: const Color(0xFF10B981), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
              ]),
              const SizedBox(width: 14),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Need help deciding?', style: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                SizedBox(height: 2),
                Text('Schedule a free 15-minute call\nwith a retirement specialist.', style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF64748B), height: 1.4)),
              ])),
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4, offset: const Offset(0, 2))]),
                child: const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF2563EB)),
              ),
            ]),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const center = Offset(36, 36);
    const radius = 28.0;
    const stroke = 12.0;
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = stroke..strokeCap = StrokeCap.butt;
    // Stocks 60% = 216deg, Bonds 30% = 108deg, Intl 5% = 18deg, Cash 5% = 18deg
    final slices = [
      (0.60, const Color(0xFF2563EB)),
      (0.30, const Color(0xFF10B981)),
      (0.05, const Color(0xFFAD46FF)),
      (0.05, const Color(0xFFFF8904)),
    ];
    double startAngle = -1.5708; // -90deg in radians
    for (final s in slices) {
      paint.color = s.$2;
      final sweep = s.$1 * 6.2832;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweep - 0.05, false, paint);
      startAngle += sweep;
    }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color; final String label;
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
    const SizedBox(width: 4),
    Text(label, style: const TextStyle(fontFamily: 'Lato', fontSize: 10, fontWeight: FontWeight.w500, color: Color(0xFF0F172A))),
  ]);
}

class _StatCol extends StatelessWidget {
  const _StatCol({required this.label, required this.value});
  final String label; final String value;
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(label, style: const TextStyle(fontFamily: 'Lato', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
    const SizedBox(height: 2),
    Text(value, style: const TextStyle(fontFamily: 'Lato', fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
  ]);
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4)),
    child: Text(label, style: const TextStyle(fontFamily: 'Lato', fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
  );
}
