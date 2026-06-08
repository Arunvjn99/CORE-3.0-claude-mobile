import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/design_system/components/app_text_field.dart';
import '../../../core/design_system/components/auth_scaffold.dart';
import '../../../core/design_system/tokens/app_spacing.dart';
import '../../../core/design_system/theme/brand_tokens.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    final error = await ref.read(authNotifierProvider.notifier).resetPassword(_emailCtrl.text.trim());

    if (!mounted) return;
    setState(() => _loading = false);

    if (error != null) {
      setState(() => _error = error);
    } else {
      setState(() => _sent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_sent) {
      return AuthScaffold(
        title: 'Check your email',
        showBack: true,
        onBack: () => context.go(AppRoutes.login),
        primaryLabel: 'Back to Login',
        onPrimary: () => context.go(AppRoutes.login),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.mark_email_read_outlined, size: 48, color: AppColors.success),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'We sent a password reset link to ${_emailCtrl.text.trim()}',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.authSecondaryText,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    final tokens = context.brandTokens;

    return AuthScaffold(
      title: 'Forgot Password',
      showBack: true,
      onBack: () => context.go(AppRoutes.login),
      primaryLabel: 'Send reset link',
      loading: _loading,
      onPrimary: _submit,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter your email and we'll send you a reset link.",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.authPlaceholder,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            if (_error != null) ...[
              AuthErrorBanner(message: _error!),
              const SizedBox(height: AppSpacing.lg),
            ],
            AppTextField(
              controller: _emailCtrl,
              hint: 'Email',
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              focusColor: tokens.brandPrimary,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
