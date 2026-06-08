import 'package:flutter/material.dart';

/// White-label brand tokens system supporting multiple client brands.
/// Inspired by modern fintech design systems (Stripe, Plaid, Wealthfront).
@immutable
class BrandTokens extends ThemeExtension<BrandTokens> {
  final Color brandPrimary;
  final Color brandPrimaryDeep;
  final Color brandNavy;
  final Color heroGradientStart;
  final Color heroGradientEnd;
  final Color cardShadow;
  final Color surfaceShell;

  const BrandTokens({
    required this.brandPrimary,
    required this.brandPrimaryDeep,
    required this.brandNavy,
    required this.heroGradientStart,
    required this.heroGradientEnd,
    required this.cardShadow,
    required this.surfaceShell,
  });

  // ══════════════════════════════════════════════════════════════════════════
  // MODERN WHITE-LABEL THEMES
  // Sophisticated, trustworthy color palettes for financial services
  // ══════════════════════════════════════════════════════════════════════════

  /// **Default Indigo Theme** — Modern, professional, trustworthy
  /// Primary: Indigo (#4F46E5) — Conveys stability and innovation
  /// Used by: Stripe, Linear, many modern SaaS products
  static const indigo = BrandTokens(
    brandPrimary: Color(0xFF4F46E5),
    brandPrimaryDeep: Color(0xFF4338CA),
    brandNavy: Color(0xFF1E293B),
    heroGradientStart: Color(0xFFFFFFFF),
    heroGradientEnd: Color(0xFFEEF2FF),
    cardShadow: Color(0xFF4F46E5),
    surfaceShell: Color(0xFFFAFAFC),
  );

  /// **Teal Theme** — Growth-focused, modern fintech
  /// Primary: Teal (#0891B2) — Represents growth and financial health
  /// Used by: Wealthfront, Robinhood
  static const teal = BrandTokens(
    brandPrimary: Color(0xFF0891B2),
    brandPrimaryDeep: Color(0xFF0E7490),
    brandNavy: Color(0xFF0F172A),
    heroGradientStart: Color(0xFFFFFFFF),
    heroGradientEnd: Color(0xFFCFFAFE),
    cardShadow: Color(0xFF0891B2),
    surfaceShell: Color(0xFFFCFEFE),
  );

  /// **Emerald Theme** — Wealth & growth focused
  /// Primary: Emerald (#059669) — Financial growth and prosperity
  /// Used by: Mint, Acorns
  static const emerald = BrandTokens(
    brandPrimary: Color(0xFF059669),
    brandPrimaryDeep: Color(0xFF047857),
    brandNavy: Color(0xFF134E4A),
    heroGradientStart: Color(0xFFFFFFFF),
    heroGradientEnd: Color(0xFFD1FAE5),
    cardShadow: Color(0xFF059669),
    surfaceShell: Color(0xFFFDFEFD),
  );

  /// **Slate Theme** — Minimalist, premium, sophisticated
  /// Primary: Slate (#475569) with Blue accent (#3B82F6)
  /// Used by: Apple, premium financial services
  static const slate = BrandTokens(
    brandPrimary: Color(0xFF3B82F6),
    brandPrimaryDeep: Color(0xFF2563EB),
    brandNavy: Color(0xFF0F172A),
    heroGradientStart: Color(0xFFFFFFFF),
    heroGradientEnd: Color(0xFFF1F5F9),
    cardShadow: Color(0xFF475569),
    surfaceShell: Color(0xFFFCFDFE),
  );

  /// **Violet Theme** — Premium, innovative
  /// Primary: Violet (#7C3AED) — Innovation and premium positioning
  /// Used by: Affirm, modern fintech startups
  static const violet = BrandTokens(
    brandPrimary: Color(0xFF7C3AED),
    brandPrimaryDeep: Color(0xFF6D28D9),
    brandNavy: Color(0xFF1E1B4B),
    heroGradientStart: Color(0xFFFFFFFF),
    heroGradientEnd: Color(0xFFF5F3FF),
    cardShadow: Color(0xFF7C3AED),
    surfaceShell: Color(0xFFFBFAFE),
  );

  /// **Rose Theme** — Warm, approachable, human-centered
  /// Primary: Rose (#E11D48) — Trust with energy
  /// Used by: Chime, human-focused fintech
  static const rose = BrandTokens(
    brandPrimary: Color(0xFFE11D48),
    brandPrimaryDeep: Color(0xFFBE123C),
    brandNavy: Color(0xFF1F2937),
    heroGradientStart: Color(0xFFFFFFFF),
    heroGradientEnd: Color(0xFFFFE4E6),
    cardShadow: Color(0xFFE11D48),
    surfaceShell: Color(0xFFFFFAFA),
  );

  /// **Legacy Transamerica Theme** — For backward compatibility
  /// Will be deprecated in favor of modern themes
  @Deprecated('Use indigo, teal, or other modern themes instead')
  static const transamerica = BrandTokens(
    brandPrimary: Color(0xFFF9002D),
    brandPrimaryDeep: Color(0xFFBA141A),
    brandNavy: Color(0xFF292670),
    heroGradientStart: Color(0xFFFFFFFF),
    heroGradientEnd: Color(0xFFFFE1E2),
    cardShadow: Color(0x21292670),
    surfaceShell: Color(0xFFFFFCFC),
  );

  // ══════════════════════════════════════════════════════════════════════════
  // THEME UTILITIES
  // ══════════════════════════════════════════════════════════════════════════

  /// Gradient for hero sections
  LinearGradient get heroGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [heroGradientStart, heroGradientEnd],
      );

  /// Subtle card elevation matching modern fintech standards
  List<BoxShadow> get cardElevation => [
        BoxShadow(
          color: cardShadow.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];

  /// Strong elevation for modals and overlays
  List<BoxShadow> get strongElevation => [
        BoxShadow(
          color: cardShadow.withValues(alpha: 0.12),
          blurRadius: 32,
          offset: const Offset(0, 8),
        ),
      ];

  @override
  BrandTokens copyWith({
    Color? brandPrimary,
    Color? brandPrimaryDeep,
    Color? brandNavy,
    Color? heroGradientStart,
    Color? heroGradientEnd,
    Color? cardShadow,
    Color? surfaceShell,
  }) {
    return BrandTokens(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandPrimaryDeep: brandPrimaryDeep ?? this.brandPrimaryDeep,
      brandNavy: brandNavy ?? this.brandNavy,
      heroGradientStart: heroGradientStart ?? this.heroGradientStart,
      heroGradientEnd: heroGradientEnd ?? this.heroGradientEnd,
      cardShadow: cardShadow ?? this.cardShadow,
      surfaceShell: surfaceShell ?? this.surfaceShell,
    );
  }

  @override
  BrandTokens lerp(ThemeExtension<BrandTokens>? other, double t) {
    if (other is! BrandTokens) return this;
    return BrandTokens(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandPrimaryDeep: Color.lerp(brandPrimaryDeep, other.brandPrimaryDeep, t)!,
      brandNavy: Color.lerp(brandNavy, other.brandNavy, t)!,
      heroGradientStart: Color.lerp(heroGradientStart, other.heroGradientStart, t)!,
      heroGradientEnd: Color.lerp(heroGradientEnd, other.heroGradientEnd, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
      surfaceShell: Color.lerp(surfaceShell, other.surfaceShell, t)!,
    );
  }
}

extension BrandTokensContext on BuildContext {
  BrandTokens get brandTokens =>
      Theme.of(this).extension<BrandTokens>() ?? BrandTokens.indigo;
}
