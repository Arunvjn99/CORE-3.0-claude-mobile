import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';

class WalkthroughPage extends StatefulWidget {
  const WalkthroughPage({super.key});

  @override
  State<WalkthroughPage> createState() => _WalkthroughPageState();
}

class _WalkthroughPageState extends State<WalkthroughPage>
    with TickerProviderStateMixin {
  final _pageCtrl = PageController();
  int _currentPage = 0;

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  static const _slides = [
    _Slide(
      lottieUrl:
          'https://lottie.host/4db68bbd-31f6-4cd8-84eb-189de081159a/IGmMCqhzpt.json',
      fallbackIcon: Icons.savings_outlined,
      title: 'Your Retirement,\nSimplified',
      subtitle:
          'Plan your future with clarity. Track every contribution, projection, and milestone — all in one place.',
      gradientColors: [Color(0xFF0F172A), Color(0xFF1E3A5F)],
      accentColor: Color(0xFF3B82F6),
    ),
    _Slide(
      lottieUrl:
          'https://lottie.host/bdcab0f8-1cc8-4e80-b2e9-92c9e064f1b3/JK0mcH9YmI.json',
      fallbackIcon: Icons.trending_up,
      title: 'Smart Investments\nThat Grow With You',
      subtitle:
          'Diversified portfolios, real-time performance, and AI-powered insights to maximize your returns.',
      gradientColors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
      accentColor: Color(0xFF10B981),
    ),
    _Slide(
      lottieUrl:
          'https://lottie.host/38e47a4e-ff3b-47cc-a9f7-5e5b4eff3f4e/zyZJkYzc9P.json',
      fallbackIcon: Icons.shield_outlined,
      title: 'Secure &\nBank-Grade Protected',
      subtitle:
          'Your data is encrypted end-to-end. We use the same security standards as the world\'s leading banks.',
      gradientColors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
      accentColor: Color(0xFF8B5CF6),
    ),
    _Slide(
      lottieUrl:
          'https://lottie.host/d95c614c-4b83-4b5e-9d84-9f1b3d1c0b5e/CoreAI.json',
      fallbackIcon: Icons.psychology_outlined,
      title: 'CORE AI at\nYour Service',
      subtitle:
          'Get personalized retirement advice instantly. Ask anything — contribution strategies, loan options, or investment tips.',
      gradientColors: [Color(0xFF0A0A0F), Color(0xFF1A1A24), Color(0xFF2D1B69)],
      accentColor: Color(0xFFA855F7),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _fadeCtrl,
      curve: Curves.easeIn,
    ));
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) context.go('/login');
  }

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _complete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_currentPage];
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: slide.gradientColors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Skip button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Page dots
                      Row(
                        children: List.generate(_slides.length, (i) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 6),
                            width: i == _currentPage ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: i == _currentPage
                                  ? slide.accentColor
                                  : Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                      TextButton(
                        onPressed: _complete,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white.withValues(alpha: 0.6),
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(48, 36),
                        ),
                        child: const Text('Skip', style: TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                ),

                // Page view
                Expanded(
                  child: PageView.builder(
                    controller: _pageCtrl,
                    onPageChanged: (i) {
                      setState(() => _currentPage = i);
                    },
                    itemCount: _slides.length,
                    itemBuilder: (_, i) => _SlideView(slide: _slides[i]),
                  ),
                ),

                // Bottom action area
                Padding(
                  padding: EdgeInsets.only(
                    left: 28,
                    right: 28,
                    bottom: MediaQuery.of(context).padding.bottom + 24,
                  ),
                  child: Column(
                    children: [
                      // Next / Get Started button
                      GestureDetector(
                        onTap: _next,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: slide.accentColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: slide.accentColor.withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentPage == _slides.length - 1
                                    ? 'Get Started'
                                    : 'Continue',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward,
                                  color: Colors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Already have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 13,
                            ),
                          ),
                          GestureDetector(
                            onTap: _complete,
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: slide.accentColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

class _SlideView extends StatelessWidget {
  final _Slide slide;

  const _SlideView({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration / Lottie
          Container(
            height: 260,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: _LottieOrFallback(
                url: slide.lottieUrl,
                fallbackIcon: slide.fallbackIcon,
                accentColor: slide.accentColor,
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Title
          Text(
            slide.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Subtitle
          Text(
            slide.subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 15,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LottieOrFallback extends StatelessWidget {
  final String url;
  final IconData fallbackIcon;
  final Color accentColor;

  const _LottieOrFallback({
    required this.url,
    required this.fallbackIcon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.network(
      url,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Center(
        child: Icon(fallbackIcon, size: 80, color: accentColor),
      ),
    );
  }
}

class _Slide {
  final String lottieUrl;
  final IconData fallbackIcon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final Color accentColor;

  const _Slide({
    required this.lottieUrl,
    required this.fallbackIcon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.accentColor,
  });
}
