import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CompanyBrand {
  core,
  congruent,
  custom,
}

class CompanyThemeData {
  final CompanyBrand brand;
  final Color primaryColor;
  final Color secondaryColor;
  final String companyName;
  final String logoUrl;
  final String tagline;
  final List<Color> gradientColors;

  const CompanyThemeData({
    required this.brand,
    required this.primaryColor,
    required this.secondaryColor,
    required this.companyName,
    required this.logoUrl,
    required this.tagline,
    required this.gradientColors,
  });

  static const core = CompanyThemeData(
    brand: CompanyBrand.core,
    primaryColor: Color(0xFF2563EB),
    secondaryColor: Color(0xFF10B981),
    companyName: 'CORE',
    logoUrl:
        'https://vrivhbghtffppkezvkfg.supabase.co/storage/v1/object/public/Logo%20and%20images/CORE%20Logo%20sup.svg',
    tagline: 'Retirement Intelligence Platform',
    gradientColors: [Color(0xFF060E1F), Color(0xFF1A3A6B), Color(0xFF2563EB)],
  );

  static const congruent = CompanyThemeData(
    brand: CompanyBrand.congruent,
    primaryColor: Color(0xFF0F766E),
    secondaryColor: Color(0xFF7C3AED),
    companyName: 'Congruent Solutions',
    logoUrl:
        'https://vrivhbghtffppkezvkfg.supabase.co/storage/v1/object/public/Logo%20and%20images/CORE%20Logo%20sup.svg',
    tagline: 'Retirement Plan Administration',
    gradientColors: [Color(0xFF042F2E), Color(0xFF0F766E), Color(0xFF14B8A6)],
  );

  // Preset themes map
  static const Map<String, CompanyThemeData> presets = {
    'core': core,
    'congruent': congruent,
  };
}

class CompanyThemeNotifier extends StateNotifier<CompanyThemeData> {
  CompanyThemeNotifier() : super(CompanyThemeData.core) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString('company_brand') ?? 'core';
    state = CompanyThemeData.presets[key] ?? CompanyThemeData.core;
  }

  Future<void> setBrand(String key) async {
    final theme = CompanyThemeData.presets[key];
    if (theme == null) return;
    state = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('company_brand', key);
  }

  Future<void> setCustomTheme(CompanyThemeData theme) async {
    state = theme;
  }
}

final companyThemeProvider =
    StateNotifierProvider<CompanyThemeNotifier, CompanyThemeData>(
  (ref) => CompanyThemeNotifier(),
);

// Convenience provider for the primary color
final companyPrimaryProvider = Provider<Color>((ref) {
  return ref.watch(companyThemeProvider).primaryColor;
});
