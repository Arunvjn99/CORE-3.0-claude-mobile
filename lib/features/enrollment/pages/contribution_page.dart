import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../widgets/enrollment_scaffold.dart';

/// Set Your Retirement Savings — Step 2/7
/// Matches Figma "Contribution" (2230:4576)
class ContributionPage extends ConsumerStatefulWidget {
  const ContributionPage({super.key});

  @override
  ConsumerState<ContributionPage> createState() => _ContributionPageState();
}

class _ContributionPageState extends ConsumerState<ContributionPage> {
  double _pct = 10.0;

  static const _salary = 120000.0;
  static const _maxMatch = 6.0;

  double get _annual => _salary * (_pct / 100);
  double get _monthly => _annual / 12;
  double get _monthlyImpact => -(_salary / 12) * (_pct / 100);
  bool get _isMaxMatch => _pct >= _maxMatch;

  // Quick picks
  static const _quickPicks = [4.0, 6.0, 10.0, 15.0];
  static const _quickLabels = ['4%', 'Match (6%)', '10%', '15%'];

  void _next() {
    ref.read(enrollmentProvider.notifier).setContribution(rate: _pct / 100);
    context.push(AppRoutes.enrollmentSource);
  }

  @override
  Widget build(BuildContext context) {
    return EnrollmentScaffold(
      stepName: 'Contribution',
      stepNumber: 2,
      totalSteps: 7,
      bottomButton: EnrollmentButton(label: 'Continue to Tax Allocation', onTap: _next),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set Your Retirement Savings',
            style: TextStyle(fontFamily: 'Lato', fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), height: 1.2),
          ),
          const SizedBox(height: 8),
          const Text(
            'Decide how much of your paycheck you want to contribute to your future.',
            style: TextStyle(fontFamily: 'Lato', fontSize: 15, color: Color(0xFF64748B), height: 1.5),
          ),
          const SizedBox(height: 24),

          // Main contribution card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 4))],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'CONTRIBUTION RATE',
                  style: TextStyle(fontFamily: 'Lato', fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 1),
                ),
                const SizedBox(height: 12),

                // +/- counter
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _CounterButton(
                      icon: Icons.remove,
                      onTap: () => setState(() => _pct = math.max(1, _pct - 1)),
                    ),
                    const SizedBox(width: 24),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: _pct.toStringAsFixed(0),
                            style: const TextStyle(fontFamily: 'Lato', fontSize: 64, fontWeight: FontWeight.w900, color: Color(0xFF2563EB), height: 1.0),
                          ),
                          const TextSpan(
                            text: '%',
                            style: TextStyle(fontFamily: 'Lato', fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF2563EB), height: 1.6),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    _CounterButton(
                      icon: Icons.add,
                      onTap: () => setState(() => _pct = math.min(50, _pct + 1)),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Slider
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF2563EB),
                    inactiveTrackColor: const Color(0xFFE2E8F0),
                    thumbColor: const Color(0xFF2563EB),
                    overlayColor: const Color(0x202563EB),
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                  ),
                  child: Slider(
                    value: _pct,
                    min: 1,
                    max: 50,
                    divisions: 49,
                    onChanged: (v) => setState(() => _pct = v.roundToDouble()),
                  ),
                ),

                // Quick pick buttons
                Row(
                  children: List.generate(_quickPicks.length, (i) {
                    final v = _quickPicks[i];
                    final label = _quickLabels[i];
                    final sel = _pct == v;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: i < _quickPicks.length - 1 ? 8 : 0),
                        child: GestureDetector(
                          onTap: () => setState(() => _pct = v),
                          child: Container(
                            height: 36,
                            decoration: BoxDecoration(
                              color: sel ? const Color(0xFF2563EB) : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: sel ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              label,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: sel ? Colors.white : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 16),

                // Annual + monthly impact
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('ANNUAL CONTRIBUTION', style: TextStyle(fontFamily: 'Lato', fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
                            const SizedBox(height: 4),
                            Text('\$${_annual.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('MONTHLY IMPACT', style: TextStyle(fontFamily: 'Lato', fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
                            const SizedBox(height: 4),
                            Text('\$${_monthlyImpact.toStringAsFixed(0)}', style: const TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Employer match banner
          if (_isMaxMatch)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.card_giftcard_outlined, size: 20, color: Color(0xFF10B981)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Maximized Employer Match', style: TextStyle(fontFamily: 'Lato', fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF10B981))),
                        SizedBox(height: 2),
                        Text('You are contributing enough to receive the full 6% employer match.', style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF15803D), height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 20, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Increase to capture full match', style: TextStyle(fontFamily: 'Lato', fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFFB45309))),
                        const SizedBox(height: 2),
                        Text('Contribute at least 6% to get the full employer match (you\'re leaving \$${(((_maxMatch - _pct).clamp(0, _maxMatch) / 100) * _salary).toStringAsFixed(0)}/yr).', style: const TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF92400E), height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // CORE AI Recommendation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Icon(Icons.auto_awesome_rounded, size: 16, color: Color(0xFF2563EB)),
                  SizedBox(width: 6),
                  Text('CORE AI Recommendation', style: TextStyle(fontFamily: 'Lato', fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF2563EB))),
                ]),
                const SizedBox(height: 8),
                Text(
                  'Increasing your contribution by just 1% could add an estimated \$64,200 to your final retirement balance.',
                  style: const TextStyle(fontFamily: 'Lato', fontSize: 13, color: Color(0xFF1E40AF), height: 1.4),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => setState(() => _pct = math.min(50, _pct + 1)),
                  child: const Row(
                    children: [
                      Text('Apply 1% Increase', style: TextStyle(fontFamily: 'Lato', fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF2563EB))),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF2563EB)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Retirement Projection
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('Retirement Projection', style: TextStyle(fontFamily: 'Lato', fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                    Spacer(),
                    Text('Expand Graph', style: TextStyle(fontFamily: 'Lato', fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2563EB))),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('PROJECTED BALANCE', style: TextStyle(fontFamily: 'Lato', fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.3)),
                            const SizedBox(height: 4),
                            Text(
                              '\$${(1420000 * (_pct / 10)).clamp(500000, 2000000) ~/ 1000}K',
                              style: const TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('MONTHLY INCOME', style: TextStyle(fontFamily: 'Lato', fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.3)),
                            const SizedBox(height: 4),
                            Text(
                              '\$${(6400 * (_pct / 10)).clamp(1000, 12000).toInt()}',
                              style: const TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Simple trend graph
                SizedBox(
                  height: 100,
                  child: CustomPaint(
                    painter: _TrendPainter(_pct),
                    size: const Size(double.infinity, 100),
                  ),
                ),

                const SizedBox(height: 6),
                const Center(
                  child: Text('Projection based on 7% annual return', style: TextStyle(fontFamily: 'Lato', fontSize: 11, color: Color(0xFF94A3B8))),
                ),
              ],
            ),
          ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFF1F5F9),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF0F172A)),
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  final double pct;
  _TrendPainter(this.pct);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFF2563EB).withValues(alpha: 0.15), const Color(0xFF2563EB).withValues(alpha: 0.01)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final points = [
      Offset(0, size.height * 0.9),
      Offset(size.width * 0.2, size.height * 0.75),
      Offset(size.width * 0.4, size.height * 0.55),
      Offset(size.width * 0.6, size.height * 0.38),
      Offset(size.width * 0.8, size.height * 0.22),
      Offset(size.width, size.height * 0.05),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    fillPath.moveTo(points[0].dx, size.height);
    fillPath.lineTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final cp1 = Offset((points[i].dx + points[i + 1].dx) / 2, points[i].dy);
      final cp2 = Offset((points[i].dx + points[i + 1].dx) / 2, points[i + 1].dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i + 1].dx, points[i + 1].dy);
      fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i + 1].dx, points[i + 1].dy);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrendPainter old) => old.pct != pct;
}
