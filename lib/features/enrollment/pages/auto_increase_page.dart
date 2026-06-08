import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../widgets/enrollment_scaffold.dart';

/// Auto Increase page — Step 4 of 7, 56% Complete
/// Matches Figma "auto increase" frame (2244:5098)
class AutoIncreasePage extends StatefulWidget {
  const AutoIncreasePage({super.key});

  @override
  State<AutoIncreasePage> createState() => _AutoIncreasePageState();
}

class _AutoIncreasePageState extends State<AutoIncreasePage> {
  bool _enabled = true;
  String _frequency = 'Calendar Year';
  double _increaseAmt = 1.0;
  double _targetRate = 15.0;

  static const _frequencies = ['Calendar Year', 'Hire Date', 'Plan Year'];
  static const _increaseOptions = [1.0, 2.0, 3.0];

  @override
  Widget build(BuildContext context) {
    return EnrollmentScaffold(
      stepName: 'Auto Increase',
      stepNumber: 4,
      totalSteps: 7,
      bottomButton: EnrollmentButton(
        label: 'Continue to Investment',
        onTap: () => context.push(AppRoutes.enrollmentInvestment),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EnrollmentHeading(
            title: 'Increase Your Savings Automatically',
            subtitle: 'Small annual increases can lead to massive growth without impacting your daily lifestyle.',
          ),
          const SizedBox(height: 24),

          // Enable toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Enable Auto Increase', style: TextStyle(fontFamily: 'Lato', fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                const SizedBox(height: 2),
                const Text('Recommended for long-term growth', style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF64748B))),
              ])),
              Switch(value: _enabled, onChanged: (v) => setState(() => _enabled = v), activeColor: const Color(0xFF2563EB)),
            ]),
          ),

          const SizedBox(height: 16),

          if (_enabled) ...[
            // Increase Frequency
            const Text('INCREASE FREQUENCY', style: TextStyle(fontFamily: 'Lato', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.8)),
            const SizedBox(height: 10),
            Row(children: _frequencies.map((f) {
              final sel = _frequency == f;
              return Expanded(child: GestureDetector(
                onTap: () => setState(() => _frequency = f),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: sel ? const Color(0xFFEFF6FF) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: sel ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0), width: sel ? 2 : 1),
                  ),
                  alignment: Alignment.center,
                  child: Text(f, style: TextStyle(fontFamily: 'Lato', fontSize: 11, fontWeight: FontWeight.w600, color: sel ? const Color(0xFF2563EB) : const Color(0xFF64748B))),
                ),
              ));
            }).toList()),

            const SizedBox(height: 20),

            // Annual Increase Amount
            const Text('ANNUAL INCREASE AMOUNT', style: TextStyle(fontFamily: 'Lato', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.8)),
            const SizedBox(height: 10),
            Row(children: [
              ..._increaseOptions.map((v) {
                final sel = _increaseAmt == v;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => _increaseAmt = v),
                    child: Container(
                      width: 56,
                      height: 44,
                      decoration: BoxDecoration(
                        color: sel ? const Color(0xFF2563EB) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: sel ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0)),
                      ),
                      alignment: Alignment.center,
                      child: Text('${v.toInt()}%', style: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w700, color: sel ? Colors.white : const Color(0xFF0F172A))),
                    ),
                  ),
                );
              }),
              GestureDetector(
                onTap: () => setState(() => _increaseAmt = 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: _increaseAmt == 0 ? const Color(0xFF2563EB) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _increaseAmt == 0 ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0)),
                  ),
                  child: Text('Custom', style: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w700, color: _increaseAmt == 0 ? Colors.white : const Color(0xFF0F172A))),
                ),
              ),
            ]),

            const SizedBox(height: 20),

            // Stop at target rate
            const Text('STOP AT TARGET RATE', style: TextStyle(fontFamily: 'Lato', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.8)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Row(children: [
                const Expanded(child: Text('Maximum Target', style: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)))),
                Text('${_targetRate.toInt()}%', style: const TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2563EB))),
              ]),
            ),

            const SizedBox(height: 24),

            // Bar chart — projected retirement gain
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _Bar(label: 'With Auto\nIncrease', height: 100, color: const Color(0xFF2563EB)),
                    const SizedBox(width: 24),
                    _Bar(label: 'Without', height: 64, color: const Color(0xFFE2E8F0)),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('POTENTIAL GAIN', style: TextStyle(fontFamily: 'Lato', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
                      SizedBox(height: 2),
                      Text('+\$430,000', style: TextStyle(fontFamily: 'Lato', fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF059669))),
                    ])),
                    const Icon(Icons.trending_up, color: Color(0xFF059669), size: 28),
                  ]),
                ),
              ]),
            ),

            const SizedBox(height: 16),

            CoreAiInsightCard(text: "Most participants don't notice a 1% annual increase in their take-home pay, but it can shorten your retirement timeline by 4 years."),
          ],

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.label, required this.height, required this.color});
  final String label; final double height; final Color color;
  @override
  Widget build(BuildContext context) => Column(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 60, height: height, decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.vertical(top: Radius.circular(8)))),
    const SizedBox(height: 6),
    Text(label, style: const TextStyle(fontFamily: 'Lato', fontSize: 11, color: Color(0xFF64748B)), textAlign: TextAlign.center),
  ]);
}
