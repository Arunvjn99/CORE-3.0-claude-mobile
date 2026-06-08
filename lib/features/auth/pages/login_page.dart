import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system/brand_assets.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../../../core/models/enrollment_model.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _showPassword = false;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _navigateHome() {
    final enrollment = ref.read(enrollmentProvider);
    context.go(
      enrollment.status == EnrollmentStatus.complete
          ? AppRoutes.postEnrollmentDashboard
          : AppRoutes.preEnrollmentDashboard,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });

    final auth = ref.read(authNotifierProvider.notifier);
    final signInError = await auth.signIn(
      _emailCtrl.text.trim(),
      _passwordCtrl.text,
    );

    if (!mounted) return;

    if (signInError != null) {
      setState(() { _loading = false; _error = signInError; });
      return;
    }

    final email = _emailCtrl.text.trim();
    final otpError = await auth.sendOtp(email);
    if (!mounted) return;
    setState(() => _loading = false);

    if (otpError != null) {
      _navigateHome();
    } else {
      context.push('${AppRoutes.verifyOtp}?email=${Uri.encodeComponent(email)}');
    }
  }

  void _demoSignIn() {
    ref.read(authNotifierProvider.notifier).signInDemo();
    context.go(AppRoutes.postEnrollmentDashboard);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // ── Top nav bar ──────────────────────────────────────────────
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF0F172A)),
                      onPressed: () => context.go(AppRoutes.loginWelcome),
                    ),
                    IconButton(
                      icon: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Icon(Icons.question_mark, size: 16, color: Color(0xFF64748B)),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

            // ── Scrollable content ────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company logo (white-label placeholder)
                    SvgPicture.asset(
                      BrandAssets.coreLogoSvg,
                      height: 28,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 28),

                    // Title
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),

                    const SizedBox(height: 24),

                    if (_error != null) ...[
                      _ErrorBanner(message: _error!),
                      if (_error!.contains('connect') || _error!.contains('Demo')) ...[
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _demoSignIn,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: 0.3)),
                            ),
                            child: const Text(
                              'Try Demo Mode →',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Lato', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                    ],

                    // Email field
                    _FigmaInputField(
                      controller: _emailCtrl,
                      hint: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Email is required';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // Password field
                    _FigmaInputField(
                      controller: _passwordCtrl,
                      hint: 'Password',
                      obscureText: !_showPassword,
                      autofillHints: const [AutofillHints.password],
                      suffix: GestureDetector(
                        onTap: () => setState(() => _showPassword = !_showPassword),
                        child: Icon(
                          _showPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          size: 20,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password is required';
                        return null;
                      },
                      onSubmitted: (_) => _submit(),
                    ),

                    const SizedBox(height: 8),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => context.push(AppRoutes.forgotPassword),
                        child: const Text(
                          'Forget Password ?',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Demo mode
                    Center(
                      child: TextButton(
                        onPressed: _demoSignIn,
                        child: const Text(
                          'Explore Demo Mode',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom section (sticky) ───────────────────────────────────
            Column(
              children: [
                const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(fontFamily: 'Lato', fontSize: 12, color: Color(0xFF94A3B8)),
                      children: [
                        TextSpan(text: 'CORE '),
                        TextSpan(
                          text: 'Terms and conditions',
                          style: TextStyle(
                            color: Color(0xFF0F172A),
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: Color(0xFF0F172A),
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 12 + bottom),
                  child: _PrimaryButton(
                    label: 'Login',
                    loading: _loading,
                    onTap: _submit,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 8 + bottom),
                  child: const Text(
                    '© Congruent Solutions, Inc. All Rights Reserved',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 11,
                      color: Color(0xFF667085),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared components ──────────────────────────────────────────────────────

class _FigmaInputField extends StatelessWidget {
  const _FigmaInputField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.autofillHints,
    this.suffix,
    this.validator,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final Widget? suffix;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autofillHints: autofillHints,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'Lato',
        fontSize: 15,
        color: Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Lato',
          fontSize: 15,
          color: Color(0xFF94A3B8),
        ),
        suffixIcon: suffix != null ? Padding(padding: const EdgeInsets.only(right: 12), child: suffix) : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.loading = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF2563EB),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: const Color(0xFF2563EB).withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 16, color: Color(0xFFEF4444)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 13,
                color: Color(0xFFB91C1C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
