import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../../../core/providers/company_theme_provider.dart';
import '../../../core/models/enrollment_model.dart';
import '../../../core/theme/app_colors.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _showPassword = false;
  bool _loading = false;
  String? _error;

  late final AnimationController _slideCtrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _slideCtrl, curve: Curves.easeIn),
    );
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _slideCtrl.dispose();
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
    setState(() {
      _loading = true;
      _error = null;
    });

    final auth = ref.read(authNotifierProvider.notifier);
    final error = await auth.signIn(
      _emailCtrl.text.trim(),
      _passwordCtrl.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (error != null) {
      setState(() => _error = error);
    } else {
      _navigateHome();
    }
  }

  void _demoSignIn() {
    ref.read(authNotifierProvider.notifier).signInDemo();
    _navigateHome();
  }

  @override
  Widget build(BuildContext context) {
    final companyTheme = ref.watch(companyThemeProvider);
    final gradients = companyTheme.gradientColors;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradients,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Background orbs
              Positioned(
                top: -100,
                right: -100,
                child: _Orb(size: 300, color: Colors.white.withValues(alpha: 0.05)),
              ),
              Positioned(
                bottom: 100,
                left: -60,
                child: _Orb(size: 180, color: companyTheme.primaryColor.withValues(alpha: 0.15)),
              ),

              SafeArea(
                child: Column(
                  children: [
                    // Header with logo
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
                      child: _LogoHeader(companyTheme: companyTheme),
                    ),
                    const SizedBox(height: 28),

                    // Form card (scrollable)
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        child: AnimatedBuilder(
                          animation: _slideCtrl,
                          builder: (_, child) => FadeTransition(
                            opacity: _fadeAnim,
                            child: SlideTransition(
                              position: _slideAnim,
                              child: child,
                            ),
                          ),
                          child: _FormCard(
                            formKey: _formKey,
                            emailCtrl: _emailCtrl,
                            passwordCtrl: _passwordCtrl,
                            showPassword: _showPassword,
                            loading: _loading,
                            error: _error,
                            companyTheme: companyTheme,
                            onTogglePassword: () =>
                                setState(() => _showPassword = !_showPassword),
                            onSubmit: _submit,
                            onForgotPassword: () =>
                                context.push(AppRoutes.forgotPassword),
                            onSignUp: () => context.push(AppRoutes.signup),
                            onDemo: _demoSignIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoHeader extends StatelessWidget {
  final CompanyThemeData companyTheme;

  const _LogoHeader({required this.companyTheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: companyTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: SvgPicture.network(
                companyTheme.logoUrl,
                fit: BoxFit.contain,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                placeholderBuilder: (_) => const Icon(
                  Icons.account_balance,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  companyTheme.companyName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  companyTheme.tagline,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Welcome back',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          'Sign in to access your retirement portal',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final bool showPassword;
  final bool loading;
  final String? error;
  final CompanyThemeData companyTheme;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignUp;
  final VoidCallback onDemo;

  const _FormCard({
    required this.formKey,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.showPassword,
    required this.loading,
    required this.error,
    required this.companyTheme,
    required this.onTogglePassword,
    required this.onSubmit,
    required this.onForgotPassword,
    required this.onSignUp,
    required this.onDemo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Error banner
            if (error != null) ...[
              _ErrorBanner(message: error!),
              const SizedBox(height: 16),
            ],

            // Email field
            _Label('Email address'),
            const SizedBox(height: 8),
            _InputField(
              controller: emailCtrl,
              hint: 'demo1234@gmail.com',
              keyboardType: TextInputType.emailAddress,
              autofillHint: AutofillHints.email,
              prefixIcon: Icons.mail_outline,
              accentColor: companyTheme.primaryColor,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Password field
            _Label('Password'),
            const SizedBox(height: 8),
            _InputField(
              controller: passwordCtrl,
              hint: '••••••••',
              obscureText: !showPassword,
              autofillHint: AutofillHints.password,
              prefixIcon: Icons.lock_outline,
              accentColor: companyTheme.primaryColor,
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: onTogglePassword,
              ),
              onSubmitted: (_) => onSubmit(),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                return null;
              },
            ),

            // Forgot password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onForgotPassword,
                style: TextButton.styleFrom(
                  foregroundColor: companyTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Forgot password?', style: TextStyle(fontSize: 13)),
              ),
            ),
            const SizedBox(height: 8),

            // Sign in button
            GestureDetector(
              onTap: loading ? null : onSubmit,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 54,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      companyTheme.primaryColor,
                      companyTheme.primaryColor.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: companyTheme.primaryColor.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Divider
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'or',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 20),

            // Demo mode button
            GestureDetector(
              onTap: onDemo,
              child: Container(
                height: 54,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: companyTheme.primaryColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: companyTheme.primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_outline,
                      color: companyTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Explore Demo Mode',
                      style: TextStyle(
                        color: companyTheme.primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sign up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                GestureDetector(
                  onTap: onSignUp,
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: companyTheme.primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Footer
            Center(
              child: Text(
                '© Congruent Solutions, Inc. All Rights Reserved',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final String autofillHint;
  final IconData prefixIcon;
  final Color accentColor;
  final Widget? suffixIcon;
  final void Function(String)? onSubmitted;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    required this.autofillHint,
    required this.prefixIcon,
    required this.accentColor,
    this.suffixIcon,
    this.onSubmitted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autofillHints: [autofillHint],
      onFieldSubmitted: onSubmitted,
      validator: validator,
      style: const TextStyle(fontSize: 15, color: Color(0xFF111827)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(prefixIcon, size: 18, color: Colors.grey.shade400),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger, width: 2),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.dangerBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.danger,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}
