import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/enrollment_provider.dart';
import '../../../core/providers/company_theme_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/app_card.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final userAsync = ref.watch(userProfileProvider);
    final companyTheme = ref.watch(companyThemeProvider);
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    final user = userAsync.valueOrNull;
    final initials = user?.initials ?? '??';
    final displayName = user?.displayName ?? 'Demo User';
    final email = user?.email ?? 'demo@example.com';

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Avatar
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: AppColors.primary,
                      child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 12),
                    Text(displayName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                    Text(email, style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Account Summary
              AppCard(
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
              const SizedBox(height: 20),

              // Personal Info section
              _SectionHeader('Account'),
              AppCard(
                noPadding: true,
                child: Column(
                  children: [
                    _MenuItem(icon: Icons.person_outline, title: 'Personal Information', onTap: () {}),
                    const Divider(height: 1),
                    _MenuItem(icon: Icons.work_outline, title: 'Employment Details', onTap: () {}),
                    const Divider(height: 1),
                    _MenuItem(icon: Icons.people_outline, title: 'Beneficiaries', badge: 'Required', onTap: () {}),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Company Theming
              _SectionHeader('Company Theming'),
              AppCard(
                noPadding: true,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.palette_outlined, size: 22, color: AppColors.primary),
                              const SizedBox(width: 14),
                              const Text('Brand Theme', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              const Spacer(),
                              Text(companyTheme.companyName,
                                  style: TextStyle(fontSize: 12, color: companyTheme.primaryColor, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 14),
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
                                      color: isActive ? entry.value.primaryColor.withValues(alpha: 0.1) : const Color(0xFFF9FAFB),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isActive ? entry.value.primaryColor : const Color(0xFFE5E7EB),
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
                                            color: isActive ? entry.value.primaryColor : const Color(0xFF6B7280),
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
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _SectionHeader('Preferences'),
              AppCard(
                noPadding: true,
                child: Column(
                  children: [
                    // Dark mode toggle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.dark_mode_outlined, size: 22, color: AppColors.primary),
                          const SizedBox(width: 14),
                          const Expanded(child: Text('Dark Mode', style: TextStyle(fontSize: 14))),
                          Switch(
                            value: isDark,
                            onChanged: (_) => ref.read(themeProvider.notifier).toggle(context),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    _MenuItem(icon: Icons.language_outlined, title: 'Language', trailing: 'English', onTap: () {}),
                    const Divider(height: 1),
                    _MenuItem(icon: Icons.notifications_outlined, title: 'Notifications', onTap: () {}),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _SectionHeader('Security'),
              AppCard(
                noPadding: true,
                child: Column(
                  children: [
                    _MenuItem(icon: Icons.lock_outline, title: 'Change Password', onTap: () {}),
                    const Divider(height: 1),
                    _MenuItem(icon: Icons.fingerprint, title: 'Biometric Login', onTap: () {}),
                    const Divider(height: 1),
                    _MenuItem(icon: Icons.security_outlined, title: 'Two-Factor Authentication', onTap: () {}),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _SectionHeader('Support'),
              AppCard(
                noPadding: true,
                child: Column(
                  children: [
                    _MenuItem(icon: Icons.help_outline, title: 'Help Center', onTap: () {}),
                    const Divider(height: 1),
                    _MenuItem(icon: Icons.feedback_outlined, title: 'Send Feedback', onTap: () {}),
                    const Divider(height: 1),
                    _MenuItem(icon: Icons.privacy_tip_outlined, title: 'Privacy Policy', onTap: () {}),
                    const Divider(height: 1),
                    _MenuItem(icon: Icons.description_outlined, title: 'Terms of Service', onTap: () {}),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Sign out
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: BorderSide(color: AppColors.danger.withValues(alpha: 0.5)),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Sign Out'),
                        content: const Text('Are you sure you want to sign out?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
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
                  label: const Text('Sign Out'),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '© Congruent Solutions, Inc. v1.0.0',
                style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.7,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? badge;
  final String? trailing;
  final VoidCallback onTap;

  const _MenuItem({required this.icon, required this.title, required this.onTap, this.badge, this.trailing});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppColors.dangerBg, borderRadius: BorderRadius.circular(4)),
              child: Text(badge!, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.danger)),
            ),
          if (trailing != null)
            Text(trailing!, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, size: 18, color: scheme.onSurfaceVariant),
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  const _StatBox(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.primary)),
          Text(label, style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _VertDiv extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 32, width: 1, color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4));
  }
}
