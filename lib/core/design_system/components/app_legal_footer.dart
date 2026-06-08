import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../tokens/app_spacing.dart';

class AppLegalFooter extends StatelessWidget {
  final bool showCoreTerms;

  const AppLegalFooter({super.key, this.showCoreTerms = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showCoreTerms)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.authPlaceholder,
                ),
                children: [
                  TextSpan(text: ' CORE '),
                  TextSpan(
                    text: 'Terms and conditions ',
                    style: TextStyle(
                      color: AppColors.authSecondaryText,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(text: 'and'),
                  TextSpan(
                    text: ' Privacy Policy',
                    style: TextStyle(
                      color: AppColors.authSecondaryText,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        const Divider(height: 1, thickness: 1, color: AppColors.authInputBorder),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageHorizontal,
            AppSpacing.sm,
            AppSpacing.pageHorizontal,
            0,
          ),
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(fontFamily: 'Inter', fontSize: 12),
                children: [
                  TextSpan(
                    text: '© ',
                    style: TextStyle(color: AppColors.authFooterText),
                  ),
                  TextSpan(
                    text: 'Congruent Solutions, Inc. All Rights Reserved',
                    style: TextStyle(
                      color: AppColors.authFooterText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
