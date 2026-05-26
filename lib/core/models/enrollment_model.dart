enum PlanType { traditional, roth }
enum ContributionType { percentage, fixed }
enum SourceType { pretax, roth, split }
enum RiskLevel { conservative, balanced, growth, aggressive }
enum EnrollmentStatus { notStarted, inProgress, complete }

class EnrollmentDraft {
  final PlanType? plan;
  final double? contributionRate;
  final ContributionType contributionType;
  final SourceType? source;
  final bool autoIncreaseEnabled;
  final double? autoIncreasePercent;
  final double? autoIncreaseMax;
  final RiskLevel? riskLevel;
  final String? investmentStrategyId;
  final int? readinessScore;
  final bool reviewConfirmed;
  final EnrollmentStatus status;

  const EnrollmentDraft({
    this.plan,
    this.contributionRate,
    this.contributionType = ContributionType.percentage,
    this.source,
    this.autoIncreaseEnabled = false,
    this.autoIncreasePercent,
    this.autoIncreaseMax,
    this.riskLevel,
    this.investmentStrategyId,
    this.readinessScore,
    this.reviewConfirmed = false,
    this.status = EnrollmentStatus.notStarted,
  });

  EnrollmentDraft copyWith({
    PlanType? plan,
    double? contributionRate,
    ContributionType? contributionType,
    SourceType? source,
    bool? autoIncreaseEnabled,
    double? autoIncreasePercent,
    double? autoIncreaseMax,
    RiskLevel? riskLevel,
    String? investmentStrategyId,
    int? readinessScore,
    bool? reviewConfirmed,
    EnrollmentStatus? status,
  }) {
    return EnrollmentDraft(
      plan: plan ?? this.plan,
      contributionRate: contributionRate ?? this.contributionRate,
      contributionType: contributionType ?? this.contributionType,
      source: source ?? this.source,
      autoIncreaseEnabled: autoIncreaseEnabled ?? this.autoIncreaseEnabled,
      autoIncreasePercent: autoIncreasePercent ?? this.autoIncreasePercent,
      autoIncreaseMax: autoIncreaseMax ?? this.autoIncreaseMax,
      riskLevel: riskLevel ?? this.riskLevel,
      investmentStrategyId: investmentStrategyId ?? this.investmentStrategyId,
      readinessScore: readinessScore ?? this.readinessScore,
      reviewConfirmed: reviewConfirmed ?? this.reviewConfirmed,
      status: status ?? this.status,
    );
  }
}
