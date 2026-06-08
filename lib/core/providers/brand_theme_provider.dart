import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design_system/theme/brand_tokens.dart';

/// Available brand theme options
enum BrandTheme {
  indigo,
  teal,
  emerald,
  slate,
  violet,
  rose,
  transamerica,
}

/// Provider for current brand theme configuration
/// Allows white-label customization per client
final brandThemeProvider = StateProvider<BrandTheme>((ref) {
  // Default to modern Indigo theme
  // Override per client: BrandTheme.teal, BrandTheme.emerald, etc.
  return BrandTheme.indigo;
});

/// Extension to convert BrandTheme enum to BrandTokens
extension BrandThemeExtension on BrandTheme {
  BrandTokens get tokens {
    switch (this) {
      case BrandTheme.indigo:
        return BrandTokens.indigo;
      case BrandTheme.teal:
        return BrandTokens.teal;
      case BrandTheme.emerald:
        return BrandTokens.emerald;
      case BrandTheme.slate:
        return BrandTokens.slate;
      case BrandTheme.violet:
        return BrandTokens.violet;
      case BrandTheme.rose:
        return BrandTokens.rose;
      case BrandTheme.transamerica:
        // ignore: deprecated_member_use_from_same_package
        return BrandTokens.transamerica;
    }
  }

  String get displayName {
    switch (this) {
      case BrandTheme.indigo:
        return 'Indigo (Default)';
      case BrandTheme.teal:
        return 'Teal';
      case BrandTheme.emerald:
        return 'Emerald';
      case BrandTheme.slate:
        return 'Slate';
      case BrandTheme.violet:
        return 'Violet';
      case BrandTheme.rose:
        return 'Rose';
      case BrandTheme.transamerica:
        return 'Transamerica (Legacy)';
    }
  }
}
