import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Brand primary — matches Figma design system ──
  static const primary        = Color(0xFF2563EB);
  static const primaryHover   = Color(0xFF1D4ED8);
  static const primaryActive  = Color(0xFF1E40AF);
  static const primaryLight   = Color(0xFFEFF6FF);
  static const primaryDark    = Color(0xFF1D4ED8);
  static const primaryShadow  = Color(0x332563EB);
  static const brandNavy      = Color(0xFF0F172A);

  // ── Status ──
  static const success        = Color(0xFF10B981);
  static const successBg      = Color(0xFFF0FDF4);
  static const successText    = Color(0xFF059669);
  static const warning        = Color(0xFFF59E0B);
  static const warningBg      = Color(0xFFFFFBEB);
  static const warningText    = Color(0xFF92400E);
  static const danger         = Color(0xFFEF4444);
  static const dangerBg       = Color(0xFFFEF2F2);
  static const dangerText     = Color(0xFFB91C1C);
  static const info           = Color(0xFF2563EB);
  static const infoBg         = Color(0xFFEFF6FF);
  static const infoText       = Color(0xFF1D4ED8);

  // ── Chart palette ──
  static const chartBlue      = Color(0xFF2563EB);
  static const chartBlueLight = Color(0xFF3B82F6);
  static const chartTeal      = Color(0xFF0D9488);
  static const chartCyan      = Color(0xFF06B6D4);
  static const chartGreen     = Color(0xFF22C55E);
  static const chartGreenDark = Color(0xFF16A34A);
  static const chartEmerald   = Color(0xFF059669);
  static const chartPurple    = Color(0xFF8B5CF6);
  static const chartViolet    = Color(0xFF7C3AED);
  static const chartAmber     = Color(0xFFF59E0B);
  static const chartOrange    = Color(0xFFEA580C);
  static const chartRed       = Color(0xFFEF4444);
  static const chartGray      = Color(0xFF94A3B8);

  // ── Light theme surfaces — matches Figma ──
  static const lightShell         = Color(0xFFFFFCFC);
  static const lightBackground    = Color(0xFFFFFCFC);
  static const lightSurface       = Color(0xFFFFFFFF);
  static const lightCard          = Color(0xFFFFFFFF);
  static const lightElevated      = Color(0xFFF1F5F9);
  static const lightBorder        = Color(0xFFE2E8F0);
  static const lightBorderLight   = Color(0xFFF1F5F9);
  static const lightDivider       = Color(0xFFE2E8F0);

  // ── Light theme text — matches Figma ──
  static const lightTextPrimary   = Color(0xFF0F172A);
  static const lightTextSecondary = Color(0xFF64748B);
  static const lightTextMuted     = Color(0xFF94A3B8);
  static const lightTextFaint     = Color(0xFFCBD5E1);

  // ── Dark theme surfaces ──
  static const darkBackground    = Color(0xFF030712);
  static const darkSurface       = Color(0xFF0A0A0F);
  static const darkCard          = Color(0xFF111118);
  static const darkElevated      = Color(0xFF1A1A24);
  static const darkBorder        = Color(0x14FFFFFF);
  static const darkBorderStrong  = Color(0x26FFFFFF);

  // ── Dark theme text ──
  static const darkTextPrimary   = Color(0xFFF9FAFB);
  static const darkTextSecondary = Color(0xFF9CA3AF);
  static const darkTextMuted     = Color(0xFF6B7280);

  // ── Dark mode primary ──
  static const darkPrimary       = Color(0xFF3B82F6);

  // ── Gradient (hero banners only) ──
  static const gradientStart     = Color(0xFF1D4ED8);
  static const gradientEnd       = Color(0xFF2563EB);

  // ── Additional Figma chart colors ──
  static const chartPurpleVivid  = Color(0xFFAD46FF);
  static const chartOrangeVivid  = Color(0xFFFF8904);

  // ── Auth screens ──
  static const authHeading       = Color(0xFF292670);
  static const authInputBorder   = Color(0xFFDEDEDE);
  static const authPlaceholder   = Color(0xFF9E9E9E);
  static const authInputText     = Color(0xFF343434);
  static const authFooterText    = Color(0xFF667085);
  static const authSecondaryText = Color(0xFF3F4552);

  // ── Zing-style UI tokens ──
  static const darkButton        = Color(0xFF111111);
  static const darkButtonText    = Color(0xFFFFFFFF);
  static const iconBgBlue        = Color(0xFFEFF6FF);
  static const iconBgGreen       = Color(0xFFF0FDF4);
  static const iconBgAmber       = Color(0xFFFFFBEB);
  static const iconBgPurple      = Color(0xFFF5F3FF);
  static const iconBgRed         = Color(0xFFFEF2F2);
  static const iconBgTeal        = Color(0xFFF0FDFA);

  // ── Adaptive helpers for dark mode ──
  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTextPrimary : lightTextPrimary;

  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTextSecondary : lightTextSecondary;

  static Color textMuted(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTextMuted : lightTextMuted;

  static Color surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkCard : lightSurface;

  static Color cardColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkCard : lightCard;

  static Color border(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkBorderStrong : lightBorder;

  static Color divider(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkBorder : lightDivider;

  static Color shell(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkBackground : lightShell;
}

