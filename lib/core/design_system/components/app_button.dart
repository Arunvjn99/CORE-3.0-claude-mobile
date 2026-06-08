import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../tokens/app_radius.dart';
import '../theme/brand_tokens.dart';

enum AppButtonVariant { primary, secondary, pill, gradient }

/// Premium Button Component - Inspired by Slice/HDFC Bank
/// Features: Gradients, shadows, haptic feedback, smooth animations
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool enabled;
  final AppButtonVariant variant;
  final double? height;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.enabled = true,
    this.variant = AppButtonVariant.primary,
    this.height,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.brandTokens;
    final active = enabled && !loading && onPressed != null;

    Color? bg;
    Gradient? gradient;
    Color fg;
    BorderSide? border;
    BorderRadius radius;
    List<BoxShadow>? shadows;

    switch (variant) {
      case AppButtonVariant.primary:
        bg = active ? tokens.brandPrimary : const Color(0xFFD1D5DB);
        fg = Colors.white;
        border = null;
        radius = BorderRadius.circular(14);
        shadows = active
            ? [
                BoxShadow(
                  color: tokens.brandPrimary.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null;
      case AppButtonVariant.gradient:
        gradient = active
            ? LinearGradient(
                colors: [tokens.brandPrimary, tokens.brandPrimaryDeep],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null;
        bg = active ? null : const Color(0xFFD1D5DB);
        fg = Colors.white;
        border = null;
        radius = BorderRadius.circular(14);
        shadows = active
            ? [
                BoxShadow(
                  color: tokens.brandPrimary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null;
      case AppButtonVariant.pill:
        bg = active ? tokens.brandPrimaryDeep : const Color(0xFFD1D5DB);
        fg = Colors.white;
        border = null;
        radius = AppRadius.pillShape;
        shadows = null;
      case AppButtonVariant.secondary:
        bg = Colors.white;
        fg = tokens.brandPrimary;
        border = BorderSide(color: tokens.brandPrimary, width: 1.5);
        radius = BorderRadius.circular(14);
        shadows = [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];
    }

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: active
              ? () {
                  HapticFeedback.lightImpact();
                  onPressed!();
                }
              : null,
          borderRadius: radius,
          child: Ink(
            height: height ?? (variant == AppButtonVariant.pill ? 40 : 56),
            width: double.infinity,
            decoration: BoxDecoration(
              color: bg,
              gradient: gradient,
              borderRadius: radius,
              border: border != null ? Border.fromBorderSide(border) : null,
              boxShadow: shadows,
            ),
            child: Center(
              child: loading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: fg,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, size: 20, color: fg),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          label,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: variant == AppButtonVariant.pill ? 14 : 16,
                            fontWeight: FontWeight.w600,
                            color: fg,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
