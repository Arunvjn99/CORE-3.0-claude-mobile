import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../../../core/models/enrollment_model.dart';
import '../../../core/theme/app_colors.dart';

class VerifyOtpPage extends ConsumerStatefulWidget {
  final String email;
  const VerifyOtpPage({super.key, required this.email});

  @override
  ConsumerState<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends ConsumerState<VerifyOtpPage> {
  final _codeCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _resending = false;
  String? _resendMsg;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _codeCtrl.text.trim();
    if (code.length != 6) {
      setState(() { _error = 'Enter the 6-digit code'; });
      return;
    }
    setState(() { _loading = true; _error = null; });

    final auth = ref.read(authNotifierProvider.notifier);
    final error = await auth.verifyOtp(widget.email, code);

    if (!mounted) return;
    setState(() { _loading = false; });

    if (error != null) {
      setState(() { _error = error; });
    } else {
      _navigateHome();
    }
  }

  void _navigateHome() {
    final enrollment = ref.read(enrollmentProvider);
    context.go(
      enrollment.status == EnrollmentStatus.complete
          ? AppRoutes.postEnrollmentDashboard
          : AppRoutes.preEnrollmentDashboard,
    );
  }

  void _demoVerify() {
    // Activate demo mode so router doesn't redirect back to login
    ref.read(authNotifierProvider.notifier).signInDemo();
    _navigateHome();
  }

  Future<void> _resend() async {
    setState(() { _resending = true; _resendMsg = null; });
    final auth = ref.read(authNotifierProvider.notifier);
    final error = await auth.sendOtp(widget.email);
    if (!mounted) return;
    setState(() {
      _resending = false;
      _resendMsg = error ?? 'A new code was sent to your email.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Verify Identity'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Verification Code',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                "We've sent a 6-digit code to\n${widget.email}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 32),

              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.dangerBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
                  ),
                  child: Text(_error!, style: const TextStyle(color: AppColors.danger, fontSize: 13)),
                ),
                const SizedBox(height: 16),
              ],

              if (_resendMsg != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.infoBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
                  ),
                  child: Text(_resendMsg!, style: const TextStyle(color: AppColors.info, fontSize: 13)),
                ),
                const SizedBox(height: 16),
              ],

              // 6-digit code input
              TextFormField(
                controller: _codeCtrl,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 12,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: '000000',
                  hintStyle: TextStyle(letterSpacing: 12, fontWeight: FontWeight.w300, fontSize: 28),
                  counterText: '',
                ),
                onChanged: (v) {
                  if (v.length == 6) _verify();
                },
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _verify,
                  child: _loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Verify & Continue'),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _resending ? null : _resend,
                    child: Text(_resending ? 'Sending…' : 'Resend code'),
                  ),
                  TextButton(
                    onPressed: _demoVerify,
                    child: const Text('Skip (Demo)'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
