import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';

class InvestmentsPage extends StatefulWidget {
  const InvestmentsPage({super.key});
  @override
  State<InvestmentsPage> createState() => _InvestmentsPageState();
}

class _InvestmentsPageState extends State<InvestmentsPage> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Investments'),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Portfolio'),
            Tab(text: 'Funds'),
            Tab(text: 'Performance'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _PortfolioTab(),
          _FundsTab(),
          _PerformanceTab(),
        ],
      ),
    );
  }
}

// ─── Portfolio Tab ────────────────────────────────────────────────────────────

class _PortfolioTab extends StatelessWidget {
  final _sections = const [
    _FundAlloc('US Equity', 55, AppColors.chartBlue),
    _FundAlloc('International', 25, AppColors.chartTeal),
    _FundAlloc('Fixed Income', 15, AppColors.chartGreen),
    _FundAlloc('Cash', 5, AppColors.chartGray),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            child: Column(
              children: [
                const Text('Total Portfolio Value', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                const Text('\$142,893', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: AppColors.primary)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.trending_up, size: 14, color: AppColors.success),
                    const SizedBox(width: 4),
                    Text('+\$11,421 (8.4%) YTD', style: const TextStyle(fontSize: 13, color: AppColors.success, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Donut chart
          AppCard(
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: _sections.map((s) => PieChartSectionData(
                        value: s.pct.toDouble(),
                        color: s.color,
                        radius: 60,
                        showTitle: false,
                      )).toList(),
                      centerSpaceRadius: 50,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 3.5,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  children: _sections.map((s) => Row(
                    children: [
                      Container(width: 10, height: 10, decoration: BoxDecoration(color: s.color, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text('${s.name} ${s.pct}%', style: const TextStyle(fontSize: 12)),
                    ],
                  )).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Asset Allocation', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ..._sections.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              child: Row(
                children: [
                  Container(width: 10, height: 40, decoration: BoxDecoration(color: s.color, borderRadius: BorderRadius.circular(3))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: s.pct / 100,
                            backgroundColor: scheme.surfaceContainerHigh,
                            valueColor: AlwaysStoppedAnimation(s.color),
                            minHeight: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('${s.pct}%', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: s.color)),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class _FundAlloc {
  final String name;
  final int pct;
  final Color color;
  const _FundAlloc(this.name, this.pct, this.color);
}

// ─── Funds Tab ────────────────────────────────────────────────────────────────

class _FundsTab extends StatelessWidget {
  final _funds = const [
    _Fund('Vanguard 500 Index', 'VFIAX', 38.5, 1.2, AppColors.chartBlue),
    _Fund('Vanguard Total Int\'l', 'VTIAX', 22.3, -0.3, AppColors.chartTeal),
    _Fund('PIMCO Total Return', 'PTTRX', 15.1, 0.4, AppColors.chartGreen),
    _Fund('Fidelity Contrafund', 'FCNTX', 14.6, 2.1, AppColors.chartOrange),
    _Fund('BlackRock Cash Fund', 'BCLMX', 9.5, 0.1, AppColors.chartGray),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: _funds.map((f) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AppCard(
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: f.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text(f.ticker.substring(0, 2), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: f.color))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(f.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      Text(f.ticker, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${f.allocation}%', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    Text(
                      f.dayChange >= 0 ? '+${f.dayChange}%' : '${f.dayChange}%',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: f.dayChange >= 0 ? AppColors.success : AppColors.danger),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )).toList(),
      ),
    );
  }
}

class _Fund {
  final String name;
  final String ticker;
  final double allocation;
  final double dayChange;
  final Color color;
  const _Fund(this.name, this.ticker, this.allocation, this.dayChange, this.color);
}

// ─── Performance Tab ─────────────────────────────────────────────────────────

class _PerformanceTab extends StatelessWidget {
  final _spotData = const [
    FlSpot(0, 110),
    FlSpot(1, 112),
    FlSpot(2, 115),
    FlSpot(3, 113),
    FlSpot(4, 118),
    FlSpot(5, 122),
    FlSpot(6, 120),
    FlSpot(7, 125),
    FlSpot(8, 128),
    FlSpot(9, 130),
    FlSpot(10, 133),
    FlSpot(11, 135),
    FlSpot(12, 142.9),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('YTD Return', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          Text('+8.4%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.success)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Benchmark', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                        const Text('+7.1%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.chartGray)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 10,
                        getDrawingHorizontalLine: (v) => FlLine(color: scheme.outline.withValues(alpha: 0.3), strokeWidth: 1),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (v, _) => Text('\$${v.toInt()}K', style: TextStyle(fontSize: 9, color: scheme.onSurfaceVariant)),
                          ),
                        ),
                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _spotData,
                          isCurved: true,
                          color: AppColors.primary,
                          barWidth: 2.5,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(show: true, color: AppColors.primary.withValues(alpha: 0.08)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Returns by Period', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          AppCard(
            noPadding: true,
            child: Column(
              children: [
                _PerfRow('1 Month', '+1.2%', true),
                const Divider(height: 1),
                _PerfRow('3 Months', '+3.1%', true),
                const Divider(height: 1),
                _PerfRow('YTD', '+8.4%', true),
                const Divider(height: 1),
                _PerfRow('1 Year', '+12.7%', true),
                const Divider(height: 1),
                _PerfRow('3 Years (Ann.)', '+9.2%', true),
                const Divider(height: 1),
                _PerfRow('Inception', '+42.5%', true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PerfRow extends StatelessWidget {
  final String period;
  final String returns;
  final bool positive;

  const _PerfRow(this.period, this.returns, this.positive);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(period, style: const TextStyle(fontSize: 13)),
          Text(returns, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: positive ? AppColors.success : AppColors.danger)),
        ],
      ),
    );
  }
}
