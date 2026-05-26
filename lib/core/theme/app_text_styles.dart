import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  static TextStyle get _base => GoogleFonts.inter();

  static TextStyle heading1(BuildContext context) => _base.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle heading2(BuildContext context) => _base.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle heading3(BuildContext context) => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.35,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle titleLarge(BuildContext context) => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.4,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle titleMedium(BuildContext context) => _base.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle bodyLarge(BuildContext context) => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle bodyMedium(BuildContext context) => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle bodySmall(BuildContext context) => _base.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  static TextStyle caption(BuildContext context) => _base.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.3,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  static TextStyle labelSmall(BuildContext context) => _base.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.5,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  static TextStyle button(BuildContext context) => _base.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: Colors.white,
      );

  static TextStyle monospace(BuildContext context) => const TextStyle(
        fontFamily: 'monospace',
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  // Static (no context) variants for use in ThemeData
  static TextStyle get displayLargeStatic => _base.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: AppColors.lightTextPrimary,
      );
}
