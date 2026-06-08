import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/enrollment_model.dart';
import '../providers/enrollment_provider.dart';
import '../router/app_router.dart';
import '../theme/app_colors.dart';

class AppShell extends ConsumerWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  int _selectedIndex(String location) {
    if (location.startsWith(AppRoutes.transactions)) return 1;
    if (location.startsWith(AppRoutes.investments)) return 3;
    if (location.startsWith(AppRoutes.profile)) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _selectedIndex(location);
    final enrollmentStatus = ref.watch(enrollmentProvider).status;
    final isEnrolled = enrollmentStatus == EnrollmentStatus.complete;
    final isAiSelected = location.startsWith(AppRoutes.aiAssistant);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: child,
      floatingActionButton: _AiFab(
        isSelected: isAiSelected,
        onTap: () => context.go(AppRoutes.aiAssistant),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _BottomNav(
        selectedIndex: selectedIndex,
        isEnrolled: isEnrolled,
        onHome: () => context.go(
          isEnrolled
              ? AppRoutes.postEnrollmentDashboard
              : AppRoutes.preEnrollmentDashboard,
        ),
        onTransactions: () => context.go(AppRoutes.transactions),
        onInvest: () => context.go(AppRoutes.investments),
        onProfile: () => context.go(AppRoutes.profile),
        scheme: scheme,
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.selectedIndex,
    required this.isEnrolled,
    required this.onHome,
    required this.onTransactions,
    required this.onInvest,
    required this.onProfile,
    required this.scheme,
  });

  final int selectedIndex;
  final bool isEnrolled;
  final VoidCallback onHome;
  final VoidCallback onTransactions;
  final VoidCallback onInvest;
  final VoidCallback onProfile;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                isSelected: selectedIndex == 0,
                onTap: onHome,
                scheme: scheme,
              ),
              _NavItem(
                icon: Icons.swap_horiz_outlined,
                activeIcon: Icons.swap_horiz_rounded,
                label: 'Transactions',
                isSelected: selectedIndex == 1,
                onTap: onTransactions,
                scheme: scheme,
              ),
              const Expanded(child: SizedBox()),
              _NavItem(
                icon: Icons.bar_chart_outlined,
                activeIcon: Icons.bar_chart_rounded,
                label: 'Invest',
                isSelected: selectedIndex == 3,
                onTap: onInvest,
                scheme: scheme,
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                isSelected: selectedIndex == 4,
                onTap: onProfile,
                scheme: scheme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.scheme,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final activeColor = scheme.primary;
    final mutedColor = scheme.onSurfaceVariant;

    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                size: 22,
                color: isSelected ? activeColor : mutedColor,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected ? activeColor : mutedColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AiFab extends StatelessWidget {
  const _AiFab({required this.isSelected, required this.onTap});
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.brandNavy,
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
          border: isSelected ? Border.all(color: Colors.white, width: 2.5) : null,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.psychology_outlined, color: Colors.white, size: 20),
            Text(
              'AI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
