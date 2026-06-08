import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../design_system/brand_assets.dart';

enum CompanyBrand {
  transamerica,
  core,
  congruent,
}

class CompanyThemeData {
  final CompanyBrand brand;
  final Color primaryColor;
  final Color secondaryColor;
  final String companyName;
  final String? logoAssetPath;
  final String logoUrl;
  final String tagline;
  final List<Color> gradientColors;

  const CompanyThemeData({
    required this.brand,
    required this.primaryColor,
    required this.secondaryColor,
    required this.companyName,
    this.logoAssetPath,
    required this.logoUrl,
    required this.tagline,
    required this.gradientColors,
  });

  static const transamerica = CompanyThemeData(
    brand: CompanyBrand.transamerica,
    primaryColor: Color(0xFFF9002D),
    secondaryColor: Color(0xFFBA141A),
    companyName: 'Transamerica',
    logoAssetPath: BrandAssets.transamericaLogo,
    logoUrl: BrandAssets.coreLogoNetwork,
    tagline: 'Retirement Plan Services',
    gradientColors: [Color(0xFFFFFFFF), Color(0xFFFFE1E2)],
  );

  static const core = CompanyThemeData(
    brand: CompanyBrand.core,
    primaryColor: Color(0xFFF9002D),
    secondaryColor: Color(0xFFBA141A),
    companyName: 'CORE',
    logoAssetPath: BrandAssets.coreLogoSvg,
    logoUrl: BrandAssets.coreLogoNetwork,
    tagline: 'Retirement Intelligence Platform',
    gradientColors: [Color(0xFFFFFFFF), Color(0xFFFFE1E2)],
  );

  static const congruent = CompanyThemeData(
    brand: CompanyBrand.congruent,
    primaryColor: Color(0xFF0F766E),
    secondaryColor: Color(0xFF7C3AED),
    companyName: 'Congruent Solutions',
    logoUrl: BrandAssets.coreLogoNetwork,
    tagline: 'Retirement Plan Administration',
    gradientColors: [Color(0xFF042F2E), Color(0xFF0F766E), Color(0xFF14B8A6)],
  );

  static const Map<String, CompanyThemeData> presets = {
    'transamerica': transamerica,
    'core': core,
    'congruent': congruent,
  };
}

class CompanyThemeNotifier extends StateNotifier<CompanyThemeData> {
  CompanyThemeNotifier() : super(CompanyThemeData.transamerica) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString('company_brand') ?? 'transamerica';
    state = CompanyThemeData.presets[key] ?? CompanyThemeData.transamerica;
  }

  Future<void> setBrand(String key) async {
    final theme = CompanyThemeData.presets[key];
    if (theme == null) return;
    state = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('company_brand', key);
  }
}

final companyThemeProvider =
    StateNotifierProvider<CompanyThemeNotifier, CompanyThemeData>(
  (ref) => CompanyThemeNotifier(),
);

final companyPrimaryProvider = Provider<Color>((ref) {
  return ref.watch(companyThemeProvider).primaryColor;
});
