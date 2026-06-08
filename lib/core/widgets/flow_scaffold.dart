import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/company_theme_provider.dart';
import '../design_system/components/app_button.dart';

class FlowScaffold extends ConsumerWidget {
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
    this.primaryLabel = 'Continue',
    this.onPrimary,
    this.primaryEnabled = true,
    this.showBack = true,
    this.onBack,
    this.secondaryAction,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyTheme = ref.watch(companyThemeProvider);
    final progress = currentStep / totalSteps;
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      body: Column(
        children: [
          Container(
            color: cs.surface,
            padding: EdgeInsets.fromLTRB(20, topPad + 8, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (showBack)
                      GestureDetector(
                        onTap: onBack ?? () => Navigator.of(context).maybePop(),
                        child: Icon(Icons.arrow_back_ios_new, size: 20, color: cs.onSurface),
                      )
                    else
                      const SizedBox(width: 20),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    Text(
                      '$currentStep / $totalSteps',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: cs.outlineVariant,
                    valueColor: AlwaysStoppedAnimation(companyTheme.primaryColor),
                    minHeight: 3,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: body,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(24, 12, 24, bottomPad + 12),
            decoration: BoxDecoration(
              color: cs.surface,
              border: Border(top: BorderSide(color: cs.outlineVariant, width: 1)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (secondaryAction != null) ...[
                  secondaryAction!,
                  const SizedBox(height: 10),
                ],
                AppButton(
                  label: primaryLabel,
                  loading: isLoading,
                  enabled: primaryEnabled,
                  onPressed: onPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
