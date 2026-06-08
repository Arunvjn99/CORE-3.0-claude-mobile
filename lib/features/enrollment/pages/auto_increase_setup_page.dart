import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/flow_scaffold.dart';

class AutoIncreaseSetupPage extends ConsumerStatefulWidget {
  const AutoIncreaseSetupPage({super.key});
  @override
  ConsumerState<AutoIncreaseSetupPage> createState() => _AutoIncreaseSetupPageState();
}

class _AutoIncreaseSetupPageState extends ConsumerState<AutoIncreaseSetupPage> {
  double _annualIncrease = 1.0;
  double _maxRate = 15.0;
  int _cycleIndex = 0; // 0=Calendar, 1=Plan, 2=Participant

  static const _cycles = ['Calendar Year', 'Plan Anniversary', 'Participant Anniversary'];
  static const _cycleIcons = [Icons.calendar_today, Icons.account_balance_outlined, Icons.person_outline];

  static const double _currentRate = 6.0;
  static const double _salary = 75000;

  List<_YearRow> _buildSchedule() {
    final rows = <_YearRow>[];
    double rate = _currentRate;
    for (int y = 1; y <= 5; y++) {
      final next = (rate + _annualIncrease).clamp(0.0, _maxRate);
      rows.add(_YearRow(year: 'Year $y', rate: rate, next: next));
      rate = next;
      if (rate >= _maxRate) break;
    }
    return rows;
  }

  double _projectedExtra() {
    double total = 0;
    double rate = _currentRate;
    for (int y = 0; y < 30; y++) {
      final annualContrib = _salary * rate / 100;
      total = (total + annualContrib) * 1.07;
      rate = (rate + _annualIncrease).clamp(0, _maxRate);
    }
    // baseline (no increase)
    double baseline = 0;
    for (int y = 0; y < 30; y++) {
      baseline = (baseline + _salary * _currentRate / 100) * 1.07;
    }
    return total - baseline;
  }

  @override
  Widget build(BuildContext context) {
    final schedule = _buildSchedule();
    final extra = _projectedExtra();

    return FlowScaffold(
      title: 'Auto Increase Setup',
      currentStep: 4,
      totalSteps: 8,
      primaryLabel: 'Enable Auto Increase',
      primaryEnabled: true,
      onPrimary: () {
        ref.read(enrollmentProvider.notifier).setAutoIncrease(
          enabled: true,
          percent: _annualIncrease,
          max: _maxRate,
        );
        context.go(AppRoutes.enrollmentInvestment);
      },
      onBack: () => context.go(AppRoutes.enrollmentAutoIncrease),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Configure Auto Increase', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.lightTextPrimary)),
          const SizedBox(height: 4),
          const Text('Set how much your contribution increases each year and the maximum cap.', style: TextStyle(fontSize: 13, color: AppColors.lightTextSecondary, height: 1.5)),
          const SizedBox(height: 24),

          // Settings card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Settings', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                const SizedBox(height: 16),

                // Annual increase
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Annual increase', style: TextStyle(fontSize: 13, color: AppColors.lightTextSecondary, fontWeight: FontWeight.w600)),
                        const Text('Added to your rate each year', style: TextStyle(fontSize: 11, color: AppColors.lightTextMuted)),
                      ],
                    ),
                    Row(
                      children: [
                        _StepBtn(icon: Icons.remove, onTap: () => setState(() => _annualIncrease = (_annualIncrease - 0.5).clamp(0.5, 5.0))),
                        const SizedBox(width: 12),
                        Text('${_annualIncrease.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
                        const SizedBox(width: 12),
                        _StepBtn(icon: Icons.add, onTap: () => setState(() => _annualIncrease = (_annualIncrease + 0.5).clamp(0.5, 5.0))),
                      ],
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider(height: 1, color: Color(0xFFF3F4F6))),

                // Max rate
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Maximum cap', style: TextStyle(fontSize: 13, color: AppColors.lightTextSecondary, fontWeight: FontWeight.w600)),
                        const Text('Contribution won\'t exceed this', style: TextStyle(fontSize: 11, color: AppColors.lightTextMuted)),
                      ],
                    ),
                    Row(
                      children: [
                        _StepBtn(icon: Icons.remove, onTap: () => setState(() => _maxRate = (_maxRate - 1).clamp(6.0, 25.0))),
                        const SizedBox(width: 12),
                        Text('${_maxRate.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
                        const SizedBox(width: 12),
                        _StepBtn(icon: Icons.add, onTap: () => setState(() => _maxRate = (_maxRate + 1).clamp(6.0, 25.0))),
                      ],
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider(height: 1, color: Color(0xFFF3F4F6))),

                // Increment cycle
                const Text('Increment cycle', style: TextStyle(fontSize: 13, color: AppColors.lightTextSecondary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(_cycles.length, (i) {
                    final sel = i == _cycleIndex;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _cycleIndex = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: EdgeInsets.only(right: i < _cycles.length - 1 ? 8 : 0),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: sel ? AppColors.primary.withValues(alpha: 0.1) : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(10),
                            border: sel ? Border.all(color: AppColors.primary.withValues(alpha: 0.4)) : null,
                          ),
                          child: Column(
                            children: [
                              Icon(_cycleIcons[i], size: 18, color: sel ? AppColors.primary : AppColors.lightTextMuted),
                              const SizedBox(height: 4),
                              Text(
                                _cycles[i].split(' ').first,
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: sel ? AppColors.primary : AppColors.lightTextSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Year-by-year schedule
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.calendar_month_outlined, size: 16, color: AppColors.primary),
                    SizedBox(width: 6),
                    Text('Increase Schedule', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.lightTextPrimary)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Expanded(child: Text('Period', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.lightTextMuted))),
                    SizedBox(width: 12),
                    SizedBox(width: 70, child: Text('Rate', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.lightTextMuted), textAlign: TextAlign.center)),
                    SizedBox(width: 70, child: Text('After', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.lightTextMuted), textAlign: TextAlign.center)),
                  ],
                ),
                const SizedBox(height: 8),
                ...schedule.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(child: Text(r.year, style: const TextStyle(fontSize: 12, color: AppColors.lightTextSecondary))),
                      const SizedBox(width: 12),
                      SizedBox(width: 70, child: Text('${r.rate.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                      SizedBox(width: 70, child: Text('${r.next.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.success), textAlign: TextAlign.center)),
                    ],
                  ),
                )),
                if (schedule.isNotEmpty && schedule.last.next >= _maxRate)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('Max rate of ${_maxRate.toStringAsFixed(0)}% reached', style: const TextStyle(fontSize: 11, color: AppColors.lightTextMuted, fontStyle: FontStyle.italic)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Financial impact card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.successBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: AppColors.successBg, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.savings_outlined, color: AppColors.success, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Estimated additional savings', style: TextStyle(fontSize: 11, color: AppColors.successText)),
                      Text(
                        '\$${(extra / 1000).toStringAsFixed(0)}K more over 30 years',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.successText),
                      ),
                      const Text('vs. keeping your current rate fixed', style: TextStyle(fontSize: 10, color: AppColors.successText)),
                    ],
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

class _YearRow {
  final String year;
  final double rate;
  final double next;
  const _YearRow({required this.year, required this.rate, required this.next});
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }
}
