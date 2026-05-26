import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum BadgeVariant { success, warning, danger, info, neutral }

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;

  const StatusBadge({super.key, required this.label, this.variant = BadgeVariant.neutral});

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _colors(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  (Color bg, Color fg) _colors(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (variant) {
      case BadgeVariant.success:
        return (AppColors.successBg, AppColors.success);
      case BadgeVariant.warning:
        return (AppColors.warningBg, AppColors.warning);
      case BadgeVariant.danger:
        return (AppColors.dangerBg, AppColors.danger);
      case BadgeVariant.info:
        return (AppColors.infoBg, AppColors.info);
      case BadgeVariant.neutral:
        return (scheme.surfaceContainerHigh, scheme.onSurfaceVariant);
    }
  }
}
