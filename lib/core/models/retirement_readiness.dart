/// Retirement Readiness Score Model
class RetirementReadinessScore {
  final int score; // 0-100
  final String status; // "On Track", "Behind", "Ahead"
  final String projectedIncome;
  final String retirementDate;

  const RetirementReadinessScore({
    required this.score,
    required this.status,
    required this.projectedIncome,
    required this.retirementDate,
  });

  factory RetirementReadinessScore.fromJson(Map<String, dynamic> json) {
    return RetirementReadinessScore(
      score: json['score'] as int,
      status: json['status'] as String,
      projectedIncome: json['projectedIncome'] as String,
      retirementDate: json['retirementDate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'status': status,
      'projectedIncome': projectedIncome,
      'retirementDate': retirementDate,
    };
  }

  // Mock data for demo
  factory RetirementReadinessScore.mock() {
    return const RetirementReadinessScore(
      score: 80,
      status: 'On Track',
      projectedIncome: '\$75,000/year',
      retirementDate: 'Feb 2055',
    );
  }
}
