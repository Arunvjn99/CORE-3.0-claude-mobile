import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/enrollment_model.dart';

const _enrollmentKey = 'enrollment_draft';

final enrollmentProvider =
    StateNotifierProvider<EnrollmentNotifier, EnrollmentDraft>((ref) {
  return EnrollmentNotifier();
});

class EnrollmentNotifier extends StateNotifier<EnrollmentDraft> {
  EnrollmentNotifier() : super(const EnrollmentDraft()) {
    _load();
  }

  SupabaseClient get _db => Supabase.instance.client;
  String? get _userId => _db.auth.currentUser?.id;

  // ── Load: Supabase first (if authed), then local cache ──────────────────
  Future<void> _load() async {
    // Try Supabase first
    final uid = _userId;
    if (uid != null) {
      try {
        final row = await _db
            .from('enrollments')
            .select()
            .eq('user_id', uid)
            .maybeSingle();
        if (row != null) {
          state = _fromSupabaseRow(row);
          _saveLocal(); // keep local cache in sync
          return;
        }
      } catch (_) {}
    }

    // Fall back to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_enrollmentKey);
    if (raw == null) return;
    try {
      state = _fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {}
  }

  // ── Save: always local, upsert to Supabase if authed ────────────────────
  Future<void> _save() async {
    await _saveLocal();
    await _saveRemote();
  }

  Future<void> _saveLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_enrollmentKey, jsonEncode(_toJson(state)));
  }

  Future<void> _saveRemote() async {
    final uid = _userId;
    if (uid == null) return;
    try {
      final d = state;
      await _db.from('enrollments').upsert(
        {
          'user_id': uid,
          'status': d.status.name,
          'current_step': _stepFromStatus(d),
          'plan_data': d.plan != null ? {'type': d.plan!.name} : null,
          'contribution_data': d.contributionRate != null
              ? {
                  'rate': d.contributionRate,
                  'type': d.contributionType.name,
                }
              : null,
          'source_data': d.source != null ? {'source': d.source!.name} : null,
          'auto_increase_data': {
            'enabled': d.autoIncreaseEnabled,
            'percent': d.autoIncreasePercent,
            'max': d.autoIncreaseMax,
          },
          'investment_data': d.riskLevel != null
              ? {
                  'riskLevel': d.riskLevel!.name,
                  'strategyId': d.investmentStrategyId,
                }
              : null,
          'readiness_data': d.readinessScore != null
              ? {'score': d.readinessScore}
              : null,
          'updated_at': DateTime.now().toIso8601String(),
          if (d.status == EnrollmentStatus.complete)
            'completed_at': DateTime.now().toIso8601String(),
        },
        onConflict: 'user_id',
      );
    } catch (_) {
      // Silent fail — local cache is the source of truth offline
    }
  }

  int _stepFromStatus(EnrollmentDraft d) {
    if (d.reviewConfirmed) return 7;
    if (d.readinessScore != null) return 6;
    if (d.riskLevel != null) return 5;
    if (d.autoIncreaseEnabled || d.autoIncreasePercent != null) return 4;
    if (d.source != null) return 3;
    if (d.contributionRate != null) return 2;
    if (d.plan != null) return 1;
    return 0;
  }

  // ── Public mutations ─────────────────────────────────────────────────────
  void setPlan(PlanType plan) {
    state = state.copyWith(plan: plan, status: EnrollmentStatus.inProgress);
    _save();
  }

  void setContribution(
      {required double rate,
      ContributionType type = ContributionType.percentage}) {
    state = state.copyWith(contributionRate: rate, contributionType: type);
    _save();
  }

  void setSource(SourceType source) {
    state = state.copyWith(source: source);
    _save();
  }

  void setAutoIncrease(
      {required bool enabled, double? percent, double? max}) {
    state = state.copyWith(
      autoIncreaseEnabled: enabled,
      autoIncreasePercent: percent,
      autoIncreaseMax: max,
    );
    _save();
  }

  void setInvestment({required RiskLevel riskLevel, String? strategyId}) {
    state = state.copyWith(
        riskLevel: riskLevel, investmentStrategyId: strategyId);
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
    final uid = _userId;
    if (uid != null) {
      try {
        await _db.from('enrollments').delete().eq('user_id', uid);
      } catch (_) {}
    }
    state = const EnrollmentDraft();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_enrollmentKey);
  }

  // ── Serialisation ────────────────────────────────────────────────────────
  EnrollmentDraft _fromSupabaseRow(Map<String, dynamic> row) {
    Map<String, dynamic>? plan = row['plan_data'] as Map<String, dynamic>?;
    Map<String, dynamic>? contrib =
        row['contribution_data'] as Map<String, dynamic>?;
    Map<String, dynamic>? src = row['source_data'] as Map<String, dynamic>?;
    Map<String, dynamic>? ai =
        row['auto_increase_data'] as Map<String, dynamic>?;
    Map<String, dynamic>? inv =
        row['investment_data'] as Map<String, dynamic>?;
    Map<String, dynamic>? read =
        row['readiness_data'] as Map<String, dynamic>?;

    return EnrollmentDraft(
      plan: plan?['type'] != null
          ? PlanType.values.byName(plan!['type'] as String)
          : null,
      contributionRate: (contrib?['rate'] as num?)?.toDouble(),
      contributionType: contrib?['type'] != null
          ? ContributionType.values.byName(contrib!['type'] as String)
          : ContributionType.percentage,
      source: src?['source'] != null
          ? SourceType.values.byName(src!['source'] as String)
          : null,
      autoIncreaseEnabled: ai?['enabled'] as bool? ?? false,
      autoIncreasePercent: (ai?['percent'] as num?)?.toDouble(),
      autoIncreaseMax: (ai?['max'] as num?)?.toDouble(),
      riskLevel: inv?['riskLevel'] != null
          ? RiskLevel.values.byName(inv!['riskLevel'] as String)
          : null,
      investmentStrategyId: inv?['strategyId'] as String?,
      readinessScore: read?['score'] as int?,
      reviewConfirmed: (row['highest_completed_step'] as int? ?? 0) >= 7,
      status: row['status'] != null
          ? EnrollmentStatus.values.byName(row['status'] as String)
          : EnrollmentStatus.notStarted,
    );
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
        plan: j['plan'] != null
            ? PlanType.values.byName(j['plan'] as String)
            : null,
        contributionRate: (j['contributionRate'] as num?)?.toDouble(),
        contributionType: j['contributionType'] != null
            ? ContributionType.values.byName(j['contributionType'] as String)
            : ContributionType.percentage,
        source: j['source'] != null
            ? SourceType.values.byName(j['source'] as String)
            : null,
        autoIncreaseEnabled: j['autoIncreaseEnabled'] as bool? ?? false,
        autoIncreasePercent: (j['autoIncreasePercent'] as num?)?.toDouble(),
        autoIncreaseMax: (j['autoIncreaseMax'] as num?)?.toDouble(),
        riskLevel: j['riskLevel'] != null
            ? RiskLevel.values.byName(j['riskLevel'] as String)
            : null,
        investmentStrategyId: j['investmentStrategyId'] as String?,
        readinessScore: j['readinessScore'] as int?,
        reviewConfirmed: j['reviewConfirmed'] as bool? ?? false,
        status: j['status'] != null
            ? EnrollmentStatus.values.byName(j['status'] as String)
            : EnrollmentStatus.notStarted,
      );
}
