import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class FlowScaffold extends StatelessWidget {
  final String title;
  final int currentStep;
  final int totalSteps;
  final Widget body;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final bool primaryEnabled;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? secondaryAction;
  final bool isLoading;

  const FlowScaffold({
    super.key,
    required this.title,
    required this.currentStep,
    required this.totalSteps,
    required this.body,
    this.primaryLabel = 'Next',
    this.onPrimary,
    this.primaryEnabled = true,
    this.showBack = true,
    this.onBack,
    this.secondaryAction,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;
    final topPad = MediaQuery.of(context).padding.top;

    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      body: Column(
        children: [
          // Custom header with step indicator
          Container(
            color: scheme.surface,
            padding: EdgeInsets.fromLTRB(20, topPad + 12, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (showBack)
                      GestureDetector(
                        onTap: onBack ?? () => Navigator.of(context).maybePop(),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.arrow_back, size: 18, color: scheme.onSurface),
                        ),
                      )
                    else
                      const SizedBox(width: 36),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface,
                            ),
                          ),
                          Text(
                            'Step $currentStep of $totalSteps',
                            style: TextStyle(
                              fontSize: 11,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        '${(progress * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Segmented step dots
                Row(
                  children: List.generate(totalSteps, (i) {
                    final done = i < currentStep;
                    final active = i == currentStep - 1;
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: i < totalSteps - 1 ? 4 : 0),
                        height: 4,
                        decoration: BoxDecoration(
                          color: done || active
                              ? AppColors.primary
                              : scheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: body,
            ),
          ),

          // Bottom action bar
          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: scheme.surface,
              border: const Border(
                top: BorderSide(color: Color(0xFFE5E7EB), width: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (secondaryAction != null) ...[
                  secondaryAction!,
                  const SizedBox(height: 10),
                ],
                GestureDetector(
                  onTap: primaryEnabled && !isLoading ? onPrimary : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 54,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: primaryEnabled
                          ? const LinearGradient(
                              colors: [AppColors.primary, AppColors.primaryHover],
                            )
                          : null,
                      color: primaryEnabled ? null : const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: primaryEnabled
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              primaryLabel,
                              style: TextStyle(
                                color: primaryEnabled ? Colors.white : const Color(0xFF9CA3AF),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
