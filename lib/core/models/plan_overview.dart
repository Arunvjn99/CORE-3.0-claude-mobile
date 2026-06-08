/// Plan Overview Model for Transaction Center
class PlanOverview {
  final String planName;
  final double totalBalance;
  final double vestedBalance;
  final double vestingPercentage; // 0-100

  const PlanOverview({
    required this.planName,
    required this.totalBalance,
    required this.vestedBalance,
    required this.vestingPercentage,
  });

  factory PlanOverview.fromJson(Map<String, dynamic> json) {
    return PlanOverview(
      planName: json['planName'] as String,
      totalBalance: (json['totalBalance'] as num).toDouble(),
      vestedBalance: (json['vestedBalance'] as num).toDouble(),
      vestingPercentage: (json['vestingPercentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planName': planName,
      'totalBalance': totalBalance,
      'vestedBalance': vestedBalance,
      'vestingPercentage': vestingPercentage,
    };
  }

  // Mock data for demo
  factory PlanOverview.mock() {
    return const PlanOverview(
      planName: '401(k) Retirement Savings Plan',
      totalBalance: 30000.0,
      vestedBalance: 25000.0,
      vestingPercentage: 83.3,
    );
  }
}
