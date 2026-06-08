import 'package:flutter/material.dart';
import '../theme/brand_tokens.dart';

/// Lightweight illustration system using SVG icons and CSS-style gradients.
/// Replaces heavy Lottie animations with performant, brand-aligned visuals.
/// 
/// Design Philosophy:
/// - Simple, geometric shapes with brand colors
/// - Radial gradients for depth
/// - Icon-based for consistency
/// - ~5KB vs ~50KB+ for Lottie files
class AppIllustrations {
  AppIllustrations._();

  /// Savings/retirement illustration
  static Widget savings(BrandTokens tokens, {double size = 180}) {
    return _Illustration(
      size: size,
      icon: Icons.savings_rounded,
      primaryColor: tokens.brandPrimary,
      tokens: tokens,
    );
  }

  /// Growth/investment illustration
  static Widget growth(BrandTokens tokens, {double size = 180}) {
    return _Illustration(
      size: size,
      icon: Icons.trending_up_rounded,
      primaryColor: AppColors.chartBlue,
      tokens: tokens,
    );
  }

  /// Success/completion illustration
  static Widget success(BrandTokens tokens, {double size = 180}) {
    return _Illustration(
      size: size,
      icon: Icons.check_circle_rounded,
      primaryColor: AppColors.success,
      tokens: tokens,
    );
  }

  /// Document/form illustration
  static Widget document(BrandTokens tokens, {double size = 180}) {
    return _Illustration(
      size: size,
      icon: Icons.description_rounded,
      primaryColor: tokens.brandPrimary,
      tokens: tokens,
    );
  }

  /// Security/lock illustration
  static Widget security(BrandTokens tokens, {double size = 180}) {
    return _Illustration(
      size: size,
      icon: Icons.shield_rounded,
      primaryColor: tokens.brandPrimary,
      tokens: tokens,
    );
  }

  /// Account/profile illustration
  static Widget account(BrandTokens tokens, {double size = 180}) {
    return _Illustration(
      size: size,
      icon: Icons.account_circle_rounded,
      primaryColor: tokens.brandPrimary,
      tokens: tokens,
    );
  }

  /// Transfer/movement illustration
  static Widget transfer(BrandTokens tokens, {double size = 180}) {
    return _Illustration(
      size: size,
      icon: Icons.swap_horiz_rounded,
      primaryColor: AppColors.chartTeal,
      tokens: tokens,
    );
  }

  /// Loan/withdrawal illustration
  static Widget loan(BrandTokens tokens, {double size = 180}) {
    return _Illustration(
      size: size,
      icon: Icons.account_balance_wallet_rounded,
      primaryColor: AppColors.chartPurple,
      tokens: tokens,
    );
  }

  /// Chart/analytics illustration
  static Widget analytics(BrandTokens tokens, {double size = 180}) {
    return _Illustration(
      size: size,
      icon: Icons.pie_chart_rounded,
      primaryColor: AppColors.chartBlue,
      tokens: tokens,
    );
  }

  /// Empty state illustration
  static Widget empty(BrandTokens tokens, {double size = 180}) {
    return _Illustration(
      size: size,
      icon: Icons.inbox_rounded,
      primaryColor: AppColors.lightTextMuted,
      tokens: tokens,
    );
  }

  /// Error state illustration
  static Widget error(BrandTokens tokens, {double size = 180}) {
    return _Illustration(
      size: size,
      icon: Icons.error_outline_rounded,
      primaryColor: AppColors.danger,
      tokens: tokens,
    );
  }
}

class AppColors {
  static const success = Color(0xFF22C55E);
  static const danger = Color(0xFFEF4444);
  static const chartBlue = Color(0xFF2563EB);
  static const chartTeal = Color(0xFF0D9488);
  static const chartPurple = Color(0xFF8B5CF6);
  static const lightTextMuted = Color(0xFF9CA3AF);
}

class _Illustration extends StatelessWidget {
  final double size;
  final IconData icon;
  final Color primaryColor;
  final BrandTokens tokens;

  const _Illustration({
    required this.size,
    required this.icon,
    required this.primaryColor,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              primaryColor.withValues(alpha: 0.12),
              primaryColor.withValues(alpha: 0.04),
              primaryColor.withValues(alpha: 0.0),
            ],
            stops: const [0.3, 0.6, 1.0],
          ),
        ),
        child: Center(
          child: Container(
            width: size * 0.5,
            height: size * 0.5,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: size * 0.35,
              color: primaryColor.withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}
