import 'package:flutter/material.dart';
import '../design_system/theme/brand_tokens.dart';
import '../design_system/tokens/app_radius.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final VoidCallback? onTap;
  final bool noPadding;
  final double radius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
    this.noPadding = false,
    this.radius = AppRadius.md,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = context.brandTokens;
    final cardColor = color ?? (isDark ? const Color(0xFF111118) : Colors.white);

    final decoration = BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: isDark ? null : tokens.cardElevation,
    );

    Widget content = Container(
      decoration: decoration,
      child: noPadding
          ? ClipRRect(borderRadius: BorderRadius.circular(radius), child: child)
          : Padding(padding: padding ?? const EdgeInsets.all(16), child: child),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: content,
        ),
      );
    }
    return content;
  }
}
