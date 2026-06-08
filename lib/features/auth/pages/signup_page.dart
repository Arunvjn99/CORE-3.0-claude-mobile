import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system/brand_assets.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../widgets/auth_form_widgets.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _agreeToTerms = true;
  bool _loading = false;
  String? _error;
  String _selectedState = 'Texas';

  static const _states = [
    'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California',
    'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia',
    'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa',
    'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland',
    'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi', 'Missouri',
    'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey',
    'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio',
    'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina',
    'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont',
    'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming',
  ];

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
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      setState(() => _error = 'Please agree to the Terms and Conditions.');
      return;
    }
    setState(() { _loading = true; _error = null; });

    final name = '${_firstNameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}'.trim();
    final error = await ref.read(authNotifierProvider.notifier).signUp(
      _emailCtrl.text.trim(),
      _passwordCtrl.text,
      name,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (error != null) {
      setState(() => _error = error);
    } else {
      final email = _emailCtrl.text.trim();
      await ref.read(authNotifierProvider.notifier).sendOtp(email);
      if (!mounted) return;
      context.push('${AppRoutes.verifyOtp}?email=${Uri.encodeComponent(email)}&source=signup');
    }
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
            // ── Top nav ─────────────────────────────────────────────────
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

            // ── Scrollable form ──────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company logo
                    SvgPicture.asset(BrandAssets.coreLogoSvg, height: 28),

                    const SizedBox(height: 24),

                    const Text(
                      'Sign up',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),

                    const SizedBox(height: 24),

                    if (_error != null) ...[
                      AuthErrorBannerWidget(message: _error!),
                      const SizedBox(height: 16),
                    ],

                    // First name
                    FigmaInputField(
                      controller: _firstNameCtrl,
                      hint: 'First name',
                      autofillHints: const [AutofillHints.givenName],
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),

                    // Last name
                    FigmaInputField(
                      controller: _lastNameCtrl,
                      hint: 'Last name',
                      autofillHints: const [AutofillHints.familyName],
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),

                    // Email
                    FigmaInputField(
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

                    // State picker (matches Figma "Where do you live")
                    GestureDetector(
                      onTap: () async {
                        final picked = await showModalBottomSheet<String>(
                          context: context,
                          builder: (_) => _StatePickerSheet(
                            selected: _selectedState,
                            states: _states,
                          ),
                        );
                        if (picked != null) setState(() => _selectedState = picked);
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                'https://flagcdn.com/w80/us.png',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Where do you live',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 11,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                  Text(
                                    _selectedState,
                                    style: const TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Password
                    FigmaInputField(
                      controller: _passwordCtrl,
                      hint: 'Password',
                      obscureText: true,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password is required';
                        if (v.length < 8) return 'Minimum 8 characters';
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Terms toggle (matches Figma)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 13,
                                color: Color(0xFF64748B),
                                height: 1.5,
                              ),
                              children: [
                                TextSpan(text: 'I Agree to CORE '),
                                TextSpan(
                                  text: 'Terms and conditions',
                                  style: TextStyle(
                                    color: Color(0xFF0F172A),
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(text: ' and\n'),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: Color(0xFF0F172A),
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Switch(
                          value: _agreeToTerms,
                          onChanged: (v) => setState(() => _agreeToTerms = v),
                          activeColor: const Color(0xFF2563EB),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom button ────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 16 + bottom),
              child: AuthPrimaryButton(
                label: 'Sign up',
                loading: _loading,
                onTap: _submit,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 8 + bottom),
              child: const Text(
                '© Congruent Solutions, Inc. All Rights Reserved',
                style: TextStyle(fontFamily: 'Lato', fontSize: 11, color: Color(0xFF667085)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatePickerSheet extends StatelessWidget {
  const _StatePickerSheet({required this.selected, required this.states});
  final String selected;
  final List<String> states;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 40, height: 4,
          decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(height: 16),
        const Text('Select State', style: TextStyle(fontFamily: 'Lato', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: states.length,
            itemBuilder: (_, i) => ListTile(
              title: Text(states[i], style: const TextStyle(fontFamily: 'Lato', fontSize: 15, color: Color(0xFF0F172A))),
              trailing: states[i] == selected ? const Icon(Icons.check, color: Color(0xFF2563EB)) : null,
              onTap: () => Navigator.pop(context, states[i]),
            ),
          ),
        ),
      ],
    );
  }
}
