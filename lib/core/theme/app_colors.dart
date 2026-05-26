import 'package:flutter/material.dart';

// Exact tokens from Core 3.0 Claude design system (colors.css + light.css + dark.css)
abstract class AppColors {
  // ── Brand primary — blue-600 (Core 3.0: --color-primary) ──
  static const primary        = Color(0xFF2563EB);
  static const primaryHover   = Color(0xFF1D4ED8);
  static const primaryActive  = Color(0xFF1E40AF);
  static const primaryLight   = Color(0xFFEFF6FF); // blue-50
  static const primaryDark    = Color(0xFF1D4ED8);
  static const primaryShadow  = Color(0x262563EB); // rgba(37,99,235,0.15)

  // ── Status — exact Core 3.0 tokens ──
  static const success        = Color(0xFF10B981);
  static const successBg      = Color(0xFFECFDF5);
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
  static const chartGreen     = Color(0xFF10B981);
  static const chartGreenDark = Color(0xFF16A34A);
  static const chartEmerald   = Color(0xFF059669);
  static const chartPurple    = Color(0xFF8B5CF6);
  static const chartViolet    = Color(0xFF7C3AED);
  static const chartAmber     = Color(0xFFF59E0B);
  static const chartOrange    = Color(0xFFEA580C);
  static const chartRed       = Color(0xFFEF4444);
  static const chartGray      = Color(0xFF94A3B8);

  // ── Light theme surfaces (--surface-*) ──
  static const lightBackground   = Color(0xFFF5F7FA); // --surface-shell
  static const lightSurface      = Color(0xFFFFFFFF); // --surface-page
  static const lightCard         = Color(0xFFFFFFFF); // --surface-card
  static const lightElevated     = Color(0xFFF8FAFC); // --surface-elevated
  static const lightBorder       = Color(0xFFE2E8F0); // --border-default
  static const lightBorderLight  = Color(0xFFF1F5F9); // --border-light

  // ── Light theme text ──
  static const lightTextPrimary   = Color(0xFF0F172A); // --text-primary slate-900
  static const lightTextSecondary = Color(0xFF64748B); // --text-secondary slate-500
  static const lightTextMuted     = Color(0xFF94A3B8); // --text-muted slate-400
  static const lightTextFaint     = Color(0xFFCBD5E1); // --text-faint slate-300

  // ── Dark theme surfaces ──
  static const darkBackground    = Color(0xFF030712); // --surface-shell
  static const darkSurface       = Color(0xFF0A0A0F); // --surface-page
  static const darkCard          = Color(0xFF111118); // --surface-card
  static const darkElevated      = Color(0xFF1A1A24); // --surface-elevated
  static const darkBorder        = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
  static const darkBorderStrong  = Color(0x26FFFFFF); // rgba(255,255,255,0.15)

  // ── Dark theme text ──
  static const darkTextPrimary   = Color(0xFFF1F5F9); // slate-100
  static const darkTextSecondary = Color(0xFF94A3B8); // slate-400
  static const darkTextMuted     = Color(0xFF64748B); // slate-500

  // ── Dark mode primary (slightly lighter for contrast) ──
  static const darkPrimary       = Color(0xFF3B82F6); // blue-500

  // ── Gradient (login page, hero) ──
  static const gradientStart     = Color(0xFF1E3A5F); // --gradient-dark-start
  static const gradientEnd       = Color(0xFF2563EB); // --gradient-dark-end
}
