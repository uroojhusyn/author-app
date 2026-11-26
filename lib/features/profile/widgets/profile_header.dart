import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/profile_model.dart';

/// Profile Header matching BlogHub Author Profile (THEME.md Section 6).
class ProfileHeader extends StatelessWidget {
  final ProfileModel profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // 110px Circular Avatar with 4px border #F0EFFF per THEME.md Section 6
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? const Color(0xFF29304F) : const Color(0xFFF0EFFF),
              width: 4,
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: AppColors.authorPrimary,
            child: Text(
              profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'A',
              style: AppTextStyles.headlineLarge.copyWith(
                color: Colors.white,
                fontSize: 34,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Author Name: Playfair Display serif per THEME.md Section 2
        Text(
          profile.name,
          style: AppTextStyles.headlineMedium.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: isDark ? const Color(0x266366F1) : AppColors.authorBadgeBg,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          child: Text(
            profile.title.isNotEmpty ? profile.title : 'Author on BlogHub',
            style: AppTextStyles.labelSmall.copyWith(
              color: isDark ? const Color(0xFFA5B4FC) : AppColors.authorBadgeText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Three Stats block
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 12,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ProfileStat(label: 'Articles', value: '${profile.articles}'),
              const _Divider(),
              _ProfileStat(label: 'Followers', value: '${profile.followers}'),
              const _Divider(),
              _ProfileStat(label: 'Total Reads', value: '${profile.totalReads}'),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.statNumber.copyWith(
            fontSize: 20,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label.toUpperCase(),
          style: AppTextStyles.statLabel.copyWith(
            fontSize: 11,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 28,
      width: 1,
      color: isDark ? AppColors.borderDark : AppColors.borderLight,
    );
  }
}
