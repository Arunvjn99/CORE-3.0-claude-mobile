import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../brand_assets.dart';
import '../tokens/app_spacing.dart';
import 'app_button.dart';
import 'app_legal_footer.dart';

/// Premium Auth Scaffold - Inspired by Slice/HDFC Bank
/// Clean, modern, spacious layout for authentication flows
class AuthScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget body;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final bool loading;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? bottomExtra;
  final bool showLegalAboveButton;

  const AuthScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.body,
    required this.primaryLabel,
    this.onPrimary,
    this.loading = false,
    this.showBack = true,
    this.onBack,
    this.bottomExtra,
    this.showLegalAboveButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AuthNavBar(showBack: showBack, onBack: onBack),
              _ModernLogo(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    AppSpacing.xxl,
                    24,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.authHeading,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.authPlaceholder,
                            height: 1.5,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xxl),
                      body,
                      if (bottomExtra != null) ...[
                        const SizedBox(height: AppSpacing.xxl),
                        bottomExtra!,
                      ],
                    ],
                  ),
                ),
              ),
              if (showLegalAboveButton) const AppLegalFooter(),
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  0,
                  24,
                  AppSpacing.lg,
                ),
                child: AppButton(
                  label: primaryLabel,
                  loading: loading,
                  onPressed: onPrimary,
                  variant: AppButtonVariant.gradient,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthNavBar extends StatelessWidget {
  final bool showBack;
  final VoidCallback? onBack;

  const _AuthNavBar({required this.showBack, this.onBack});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (showBack)
              IconButton(
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Color(0xFF343434),
                  ),
                ),
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                tooltip: 'Back',
              )
            else
              const SizedBox(width: 48),
            IconButton(
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.authInputBorder),
                ),
                child: const Icon(
                  Icons.help_outline,
                  size: 20,
                  color: Color(0xFF343434),
                ),
              ),
              onPressed: () {},
              tooltip: 'Help',
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Image.asset(
        BrandAssets.transamericaLogo,
        width: 140,
        height: 32,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const SizedBox(height: 32),
      ),
    );
  }
}

class AuthErrorBanner extends StatelessWidget {
  final String message;

  const AuthErrorBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.dangerBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppColors.danger,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
