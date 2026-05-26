import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/enrollment_model.dart';

const _enrollmentKey = 'enrollment_draft';

final enrollmentProvider = StateNotifierProvider<EnrollmentNotifier, EnrollmentDraft>((ref) {
  return EnrollmentNotifier();
});

class EnrollmentNotifier extends StateNotifier<EnrollmentDraft> {
  EnrollmentNotifier() : super(const EnrollmentDraft()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_enrollmentKey);
    if (raw == null) return;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      state = _fromJson(json);
    } catch (_) {}
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_enrollmentKey, jsonEncode(_toJson(state)));
  }

  void setPlan(PlanType plan) {
    state = state.copyWith(plan: plan, status: EnrollmentStatus.inProgress);
    _save();
  }

  void setContribution({required double rate, ContributionType type = ContributionType.percentage}) {
    state = state.copyWith(contributionRate: rate, contributionType: type);
    _save();
  }

  void setSource(SourceType source) {
    state = state.copyWith(source: source);
    _save();
  }

  void setAutoIncrease({required bool enabled, double? percent, double? max}) {
    state = state.copyWith(
      autoIncreaseEnabled: enabled,
      autoIncreasePercent: percent,
      autoIncreaseMax: max,
    );
    _save();
  }

  void setInvestment({required RiskLevel riskLevel, String? strategyId}) {
    state = state.copyWith(riskLevel: riskLevel, investmentStrategyId: strategyId);
    _save();
  }

  void setReadiness(int score) {
    state = state.copyWith(readinessScore: score);
    _save();
  }

  void confirmReview() {
    state = state.copyWith(reviewConfirmed: true);
    _save();
  }

  Future<void> complete() async {
    state = state.copyWith(status: EnrollmentStatus.complete);
    await _save();
  }

  Future<void> reset() async {
    state = const EnrollmentDraft();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_enrollmentKey);
  }

  Map<String, dynamic> _toJson(EnrollmentDraft d) => {
        'plan': d.plan?.name,
        'contributionRate': d.contributionRate,
        'contributionType': d.contributionType.name,
        'source': d.source?.name,
        'autoIncreaseEnabled': d.autoIncreaseEnabled,
        'autoIncreasePercent': d.autoIncreasePercent,
        'autoIncreaseMax': d.autoIncreaseMax,
        'riskLevel': d.riskLevel?.name,
        'investmentStrategyId': d.investmentStrategyId,
        'readinessScore': d.readinessScore,
        'reviewConfirmed': d.reviewConfirmed,
        'status': d.status.name,
      };

  EnrollmentDraft _fromJson(Map<String, dynamic> j) => EnrollmentDraft(
        plan: j['plan'] != null ? PlanType.values.byName(j['plan'] as String) : null,
        contributionRate: (j['contributionRate'] as num?)?.toDouble(),
        contributionType: j['contributionType'] != null
            ? ContributionType.values.byName(j['contributionType'] as String)
            : ContributionType.percentage,
        source: j['source'] != null ? SourceType.values.byName(j['source'] as String) : null,
        autoIncreaseEnabled: j['autoIncreaseEnabled'] as bool? ?? false,
        autoIncreasePercent: (j['autoIncreasePercent'] as num?)?.toDouble(),
        autoIncreaseMax: (j['autoIncreaseMax'] as num?)?.toDouble(),
        riskLevel: j['riskLevel'] != null ? RiskLevel.values.byName(j['riskLevel'] as String) : null,
        investmentStrategyId: j['investmentStrategyId'] as String?,
        readinessScore: j['readinessScore'] as int?,
        reviewConfirmed: j['reviewConfirmed'] as bool? ?? false,
        status: j['status'] != null
            ? EnrollmentStatus.values.byName(j['status'] as String)
            : EnrollmentStatus.notStarted,
      );
}
