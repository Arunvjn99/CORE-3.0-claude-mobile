import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system/theme/brand_tokens.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../../../core/models/enrollment_model.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';

/// OTP Verification Screen
/// [source] = 'login'  → after verify, go to home dashboard
/// [source] = 'signup' → after verify, go to login (confirm then sign in)
class VerifyOtpPage extends ConsumerStatefulWidget {
  final String email;
  final String source; // 'login' | 'signup'

  const VerifyOtpPage({
    super.key,
    required this.email,
    this.source = 'login',
  });

  @override
  ConsumerState<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends ConsumerState<VerifyOtpPage>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _ctrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());

  bool _loading = false;
  String? _error;
  bool _resending = false;
  String? _resendMsg;

  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn),
    );
    // Focus first box on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _nodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _ctrls) c.dispose();
    for (final n in _nodes) n.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  String get _fullCode =>
      _ctrls.map((c) => c.text).join();

  void _onDigit(int index, String value) {
    if (value.length > 1) {
      // Paste handling — fill boxes
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (var i = 0; i < 6 && i < digits.length; i++) {
        _ctrls[i].text = digits[i];
      }
      final nextFocus = (digits.length < 6) ? digits.length : 5;
      _nodes[nextFocus].requestFocus();
      if (digits.length == 6) _verify();
      return;
    }
    if (value.isNotEmpty && index < 5) {
      _nodes[index + 1].requestFocus();
    }
    if (_fullCode.length == 6) _verify();
  }

  void _onBackspace(int index) {
    if (_ctrls[index].text.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
      _ctrls[index - 1].clear();
    }
  }

  Future<void> _verify() async {
    final code = _fullCode;
    if (code.length != 6) {
      setState(() => _error = 'Enter all 6 digits');
      _shakeCtrl.forward(from: 0);
      return;
    }
    setState(() { _loading = true; _error = null; });

    final auth = ref.read(authNotifierProvider.notifier);
    final error = await auth.verifyOtp(widget.email, code);

    if (!mounted) return;
    setState(() => _loading = false);

    if (error != null) {
      setState(() => _error = 'Invalid or expired code. Try again.');
      _shakeCtrl.forward(from: 0);
      for (final c in _ctrls) c.clear();
      _nodes[0].requestFocus();
    } else {
      _navigateNext();
    }
  }

  void _navigateNext() {
    if (widget.source == 'signup') {
      // After email verification → go to login to sign in
      context.go(AppRoutes.login);
    } else {
      // After 2FA → go to home
      final enrollment = ref.read(enrollmentProvider);
      context.go(
        enrollment.status == EnrollmentStatus.complete
            ? AppRoutes.postEnrollmentDashboard
            : AppRoutes.preEnrollmentDashboard,
      );
    }
  }

  void _demoSkip() {
    ref.read(authNotifierProvider.notifier).signInDemo();
    final enrollment = ref.read(enrollmentProvider);
    context.go(
      enrollment.status == EnrollmentStatus.complete
          ? AppRoutes.postEnrollmentDashboard
          : AppRoutes.preEnrollmentDashboard,
    );
  }

  Future<void> _resend() async {
    setState(() { _resending = true; _resendMsg = null; _error = null; });
    final err = await ref.read(authNotifierProvider.notifier).sendOtp(widget.email);
    if (!mounted) return;
    setState(() {
      _resending = false;
      _resendMsg = err ?? 'A new code was sent to your email.';
    });
  }

  String _maskedEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    final visible = name.length > 2 ? name.substring(0, 2) : name;
    return '$visible••••••@$domain';
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final tokens = context.brandTokens;
    final isSignup = widget.source == 'signup';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: bottomPad + 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top nav ─────────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(24, topPad > 0 ? 0 : 12, 24, 0),
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 20, color: AppColors.lightTextPrimary),
                  ),
                ),

                // ── Illustration ─────────────────────────────────────────
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: _OtpIllustration(
                      accentColor: tokens.brandPrimary,
                      isSignup: isSignup,
                    ),
                  ),
                ),

                // ── Heading ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isSignup
                            ? 'Verify your email'
                            : 'Enter your code',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.lightTextPrimary,
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: AppColors.lightTextSecondary,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: isSignup
                                  ? 'We sent a 6-digit code to '
                                  : 'A 6-digit security code was sent to ',
                            ),
                            TextSpan(
                              text: _maskedEmail(widget.email),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.lightTextPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ── OTP Boxes ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AnimatedBuilder(
                    animation: _shakeAnim,
                    builder: (_, child) => Transform.translate(
                      offset: Offset(
                        _error != null
                            ? 6 * (_shakeAnim.value < 0.5
                                ? _shakeAnim.value * 2
                                : (1 - _shakeAnim.value) * 2)
                            : 0,
                        0,
                      ),
                      child: child,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (i) => _OtpBox(
                          controller: _ctrls[i],
                          focusNode: _nodes[i],
                          accentColor: tokens.brandPrimary,
                          hasError: _error != null,
                          onChanged: (v) => _onDigit(i, v),
                          onBackspace: () => _onBackspace(i),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Error / Success message ──────────────────────────────
                if (_error != null) ...[
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline_rounded,
                            size: 15, color: AppColors.danger),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: AppColors.danger,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (_resendMsg != null) ...[
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline_rounded,
                            size: 15,
                            color: _resendMsg!.contains('sent')
                                ? AppColors.success
                                : AppColors.danger),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _resendMsg!,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: _resendMsg!.contains('sent')
                                  ? AppColors.success
                                  : AppColors.danger,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),

                // ── Resend row ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    children: [
                      const Text(
                        "Didn't receive it? ",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: _resending ? null : _resend,
                        child: Text(
                          _resending ? 'Sending…' : 'Resend code',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _resending
                                ? AppColors.lightTextMuted
                                : tokens.brandPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ── Verify button ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _VerifyButton(
                    label: isSignup ? 'Verify Email' : 'Verify & Continue',
                    loading: _loading,
                    accentColor: tokens.brandPrimary,
                    onTap: _verify,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Demo skip ────────────────────────────────────────────
                Center(
                  child: GestureDetector(
                    onTap: _demoSkip,
                    child: const Text(
                      'Skip — explore demo mode',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// OTP ILLUSTRATION — Email envelope with animated dots
// ═══════════════════════════════════════════════════════════════════════════
class _OtpIllustration extends StatelessWidget {
  final Color accentColor;
  final bool isSignup;
  const _OtpIllustration({required this.accentColor, required this.isSignup});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow circle
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withValues(alpha: 0.08),
            ),
          ),
          // Middle circle
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withValues(alpha: 0.12),
            ),
          ),
          // Icon container
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              isSignup ? Icons.mark_email_read_outlined : Icons.lock_open_rounded,
              size: 36,
              color: Colors.white,
            ),
          ),
          // Badge top-right
          Positioned(
            top: 16,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    '6-digit code',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// OTP BOX — Single digit input cell
// ═══════════════════════════════════════════════════════════════════════════
class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color accentColor;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.accentColor,
    required this.hasError,
    required this.onChanged,
    required this.onBackspace,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filled = widget.controller.text.isNotEmpty;
    Color borderColor;
    Color bgColor;

    if (widget.hasError) {
      borderColor = AppColors.danger;
      bgColor = AppColors.dangerBg;
    } else if (_focused) {
      borderColor = widget.accentColor;
      bgColor = widget.accentColor.withValues(alpha: 0.05);
    } else if (filled) {
      borderColor = widget.accentColor.withValues(alpha: 0.4);
      bgColor = Colors.white;
    } else {
      borderColor = AppColors.lightBorder;
      bgColor = const Color(0xFFF9FAFB);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 46,
      height: 56,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: _focused ? 2 : 1.5),
      ),
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            widget.onBackspace();
          }
        },
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: widget.onChanged,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: widget.hasError ? AppColors.danger : AppColors.lightTextPrimary,
          ),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// VERIFY BUTTON
// ═══════════════════════════════════════════════════════════════════════════
class _VerifyButton extends StatelessWidget {
  final String label;
  final bool loading;
  final Color accentColor;
  final VoidCallback onTap;

  const _VerifyButton({
    required this.label,
    required this.loading,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color: loading ? AppColors.lightBorder : accentColor,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
