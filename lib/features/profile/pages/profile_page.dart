import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../../../core/providers/company_theme_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);
    final companyTheme = ref.watch(companyThemeProvider);
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    final user = userAsync.valueOrNull;
    final initials = user?.initials ?? '??';
    final displayName = user?.displayName ?? 'Demo User';
    final email = user?.email ?? 'demo@example.com';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // Header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Stats row card
                _Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: Row(
                      children: [
                        _StatBox('\$142,893', 'Balance'),
                        _VertDiv(),
                        _StatBox('6%', 'Contribution'),
                        _VertDiv(),
                        _StatBox('80', 'Readiness'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Account section
                _SectionHeader('Account'),
                const SizedBox(height: 8),
                _Card(
                  child: Column(
                    children: [
                      _MenuItem(
                        icon: Icons.person_outline,
                        iconBg: AppColors.iconBgBlue,
                        iconColor: AppColors.primary,
                        title: 'Personal Information',
                        onTap: () {},
                      ),
                      _Divider(),
                      _MenuItem(
                        icon: Icons.work_outline,
                        iconBg: AppColors.iconBgTeal,
                        iconColor: AppColors.chartTeal,
                        title: 'Employment Details',
                        onTap: () {},
                      ),
                      _Divider(),
                      _MenuItem(
                        icon: Icons.people_outline,
                        iconBg: AppColors.iconBgRed,
                        iconColor: AppColors.danger,
                        title: 'Beneficiaries',
                        badge: 'Required',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Company Theming section
                _SectionHeader('Company Theming'),
                const SizedBox(height: 8),
                _Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.iconBgPurple,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.palette_outlined, size: 20, color: AppColors.chartPurple),
                            ),
                            const SizedBox(width: 14),
                            const Text(
                              'Brand Theme',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.lightTextPrimary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              companyTheme.companyName,
                              style: TextStyle(
                                fontSize: 12,
                                color: companyTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: CompanyThemeData.presets.entries.map((entry) {
                            final isActive = companyTheme.brand == entry.value.brand;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => ref.read(companyThemeProvider.notifier).setBrand(entry.key),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? entry.value.primaryColor.withValues(alpha: 0.08)
                                        : AppColors.lightShell,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isActive ? entry.value.primaryColor : AppColors.lightBorder,
                                      width: isActive ? 2 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: entry.value.gradientColors.take(2).toList(),
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        entry.value.companyName,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: isActive ? entry.value.primaryColor : AppColors.lightTextSecondary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Preferences section
                _SectionHeader('Preferences'),
                const SizedBox(height: 8),
                _Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.iconBgPurple,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.dark_mode_outlined, size: 20, color: AppColors.chartPurple),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Text(
                                'Dark Mode',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.lightTextPrimary,
                                ),
                              ),
                            ),
                            Switch(
                              value: isDark,
                              onChanged: (_) => ref.read(themeProvider.notifier).toggle(context),
                            ),
                          ],
                        ),
                      ),
                      _Divider(),
                      _MenuItem(
                        icon: Icons.language_outlined,
                        iconBg: AppColors.iconBgTeal,
                        iconColor: AppColors.chartTeal,
                        title: 'Language',
                        trailing: 'English',
                        onTap: () {},
                      ),
                      _Divider(),
                      _MenuItem(
                        icon: Icons.notifications_outlined,
                        iconBg: AppColors.iconBgAmber,
                        iconColor: AppColors.warning,
                        title: 'Notifications',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Security section
                _SectionHeader('Security'),
                const SizedBox(height: 8),
                _Card(
                  child: Column(
                    children: [
                      _MenuItem(
                        icon: Icons.lock_outline,
                        iconBg: AppColors.iconBgBlue,
                        iconColor: AppColors.primary,
                        title: 'Change Password',
                        onTap: () {},
                      ),
                      _Divider(),
                      _MenuItem(
                        icon: Icons.fingerprint,
                        iconBg: AppColors.iconBgGreen,
                        iconColor: AppColors.success,
                        title: 'Biometric Login',
                        onTap: () {},
                      ),
                      _Divider(),
                      _MenuItem(
                        icon: Icons.security_outlined,
                        iconBg: AppColors.iconBgAmber,
                        iconColor: AppColors.warning,
                        title: 'Two-Factor Authentication',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Support section
                _SectionHeader('Support'),
                const SizedBox(height: 8),
                _Card(
                  child: Column(
                    children: [
                      _MenuItem(
                        icon: Icons.help_outline,
                        iconBg: AppColors.iconBgBlue,
                        iconColor: AppColors.primary,
                        title: 'Help Center',
                        onTap: () {},
                      ),
                      _Divider(),
                      _MenuItem(
                        icon: Icons.feedback_outlined,
                        iconBg: AppColors.iconBgGreen,
                        iconColor: AppColors.success,
                        title: 'Send Feedback',
                        onTap: () {},
                      ),
                      _Divider(),
                      _MenuItem(
                        icon: Icons.privacy_tip_outlined,
                        iconBg: AppColors.iconBgTeal,
                        iconColor: AppColors.chartTeal,
                        title: 'Privacy Policy',
                        onTap: () {},
                      ),
                      _Divider(),
                      _MenuItem(
                        icon: Icons.description_outlined,
                        iconBg: AppColors.iconBgPurple,
                        iconColor: AppColors.chartPurple,
                        title: 'Terms of Service',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Sign out button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkButton,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Sign Out'),
                          content: const Text('Are you sure you want to sign out?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Sign Out'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        await ref.read(authNotifierProvider.notifier).signOut();
                        await ref.read(enrollmentProvider.notifier).reset();
                        if (context.mounted) context.go(AppRoutes.login);
                      }
                    },
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    '© Congruent Solutions, Inc. v1.0.0',
                    style: TextStyle(fontSize: 11, color: AppColors.lightTextMuted),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Shared card widget ──────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: AppColors.lightBorder, indent: 20, endIndent: 20);
  }
}

// ─── Section header ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.lightTextSecondary,
        letterSpacing: 0.5,
      ),
    );
  }
}

// ─── Menu item ───────────────────────────────────────────────────────────────

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String? badge;
  final String? trailing;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.badge,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.lightTextPrimary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.dangerBg,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.danger,
                ),
              ),
            ),
          if (trailing != null) ...[
            const SizedBox(width: 4),
            Text(
              trailing!,
              style: const TextStyle(fontSize: 13, color: AppColors.lightTextSecondary),
            ),
          ],
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 18, color: AppColors.lightTextMuted),
        ],
      ),
      onTap: onTap,
    );
  }
}

// ─── Stat box ────────────────────────────────────────────────────────────────

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  const _StatBox(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 17,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.lightTextSecondary),
          ),
        ],
      ),
    );
  }
}

class _VertDiv extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 36, width: 1, color: AppColors.lightBorder);
  }
}
