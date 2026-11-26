import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showSignOutDialog(BuildContext context, AuthProvider authProvider) {
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        title: Text(
          'Sign Out',
          style: AppTextStyles.titleMedium.copyWith(color: cs.onSurface),
        ),
        content: Text(
          'Are you sure you want to sign out of BlogHub Authors?',
          style: AppTextStyles.bodyMedium.copyWith(color: cs.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: Text(
              'Cancel',
              style: AppTextStyles.button.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
            ),
            onPressed: () async {
              ctx.pop();
              await authProvider.logout();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
            child: Text('Sign Out', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final authProvider = context.watch<AuthProvider>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.appBarTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.lg,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Group: Preferences ──────────────────────────────────────
                  _SettingsGroup(
                    title: 'PREFERENCES',
                    children: [
                      SwitchListTile(
                        secondary: Container(
                          padding: const EdgeInsets.all(AppSpacing.xs + 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Icon(
                            settingsProvider.themeMode == ThemeMode.dark
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            size: AppSpacing.iconSm,
                            color: AppColors.primary,
                          ),
                        ),
                        title: Text(
                          'Dark Mode',
                          style: AppTextStyles.titleSmall.copyWith(color: cs.onSurface),
                        ),
                        subtitle: Text(
                          'Switch between light and dark visual themes',
                          style: AppTextStyles.bodySmall.copyWith(color: cs.onSurfaceVariant),
                        ),
                        value: settingsProvider.themeMode == ThemeMode.dark,
                        activeThumbImage: null,
                        onChanged: (val) {
                          settingsProvider.setThemeMode(
                            val ? ThemeMode.dark : ThemeMode.light,
                          );
                        },
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        secondary: Container(
                          padding: const EdgeInsets.all(AppSpacing.xs + 2),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: const Icon(
                            Icons.save_as_rounded,
                            size: AppSpacing.iconSm,
                            color: AppColors.secondary,
                          ),
                        ),
                        title: Text(
                          'Auto-save Drafts',
                          style: AppTextStyles.titleSmall.copyWith(color: cs.onSurface),
                        ),
                        subtitle: Text(
                          'Automatically preserve article revisions while typing',
                          style: AppTextStyles.bodySmall.copyWith(color: cs.onSurfaceVariant),
                        ),
                        value: settingsProvider.settings.autoSaveDrafts,
                        onChanged: (val) => settingsProvider.toggleAutoSaveDrafts(val),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── Group: Notifications ────────────────────────────────────
                  _SettingsGroup(
                    title: 'NOTIFICATIONS',
                    children: [
                      SwitchListTile(
                        secondary: Container(
                          padding: const EdgeInsets.all(AppSpacing.xs + 2),
                          decoration: BoxDecoration(
                            color: AppColors.infoContainer,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: const Icon(
                            Icons.notifications_active_outlined,
                            size: AppSpacing.iconSm,
                            color: AppColors.info,
                          ),
                        ),
                        title: Text(
                          'Comment Alerts',
                          style: AppTextStyles.titleSmall.copyWith(color: cs.onSurface),
                        ),
                        subtitle: Text(
                          'Notify when readers post new comments on your articles',
                          style: AppTextStyles.bodySmall.copyWith(color: cs.onSurfaceVariant),
                        ),
                        value: settingsProvider.settings.commentAlerts,
                        onChanged: (val) => settingsProvider.toggleCommentAlerts(val),
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        secondary: Container(
                          padding: const EdgeInsets.all(AppSpacing.xs + 2),
                          decoration: BoxDecoration(
                            color: AppColors.successContainer,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: const Icon(
                            Icons.mark_email_unread_outlined,
                            size: AppSpacing.iconSm,
                            color: AppColors.success,
                          ),
                        ),
                        title: Text(
                          'Weekly Performance Digest',
                          style: AppTextStyles.titleSmall.copyWith(color: cs.onSurface),
                        ),
                        subtitle: Text(
                          'Receive weekly traffic, views and engagement summaries',
                          style: AppTextStyles.bodySmall.copyWith(color: cs.onSurfaceVariant),
                        ),
                        value: settingsProvider.settings.emailNotifications,
                        onChanged: (val) => settingsProvider.toggleEmailNotifications(val),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── Group: Account ──────────────────────────────────────────
                  _SettingsGroup(
                    title: 'ACCOUNT',
                    children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(AppSpacing.xs + 2),
                          decoration: BoxDecoration(
                            color: AppColors.errorContainer,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            size: AppSpacing.iconSm,
                            color: AppColors.error,
                          ),
                        ),
                        title: Text(
                          'Sign Out',
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          'Log out of your current author session',
                          style: AppTextStyles.bodySmall.copyWith(color: cs.onSurfaceVariant),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: AppSpacing.iconSm,
                          color: AppColors.error,
                        ),
                        onTap: () => _showSignOutDialog(context, authProvider),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsGroup({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.sm,
            bottom: AppSpacing.sm,
          ),
          child: Text(
            title,
            style: AppTextStyles.labelSmall.copyWith(
              color: cs.onSurfaceVariant,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Card(
          elevation: 0,
          color: cs.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            side: BorderSide(color: cs.outline.withValues(alpha: 0.2)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: children),
        ),
      ],
    );
  }
}
