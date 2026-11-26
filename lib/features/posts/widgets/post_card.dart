import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../models/post_model.dart';

/// Post Card widget for Posts feature matching BlogHub THEME.md.
class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  ({Color bg, Color fg}) _getStatusStyle(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'published':
        return (
          bg: AppColors.statusSuccessBg,
          fg: AppColors.statusSuccessText,
        );
      case 'pending':
      case 'in_review':
        return (
          bg: AppColors.statusWarningBg,
          fg: AppColors.statusWarningText,
        );
      case 'rejected':
        return (
          bg: AppColors.statusDangerBg,
          fg: AppColors.statusDangerText,
        );
      case 'draft':
      default:
        return (
          bg: AppColors.statusDraftBg,
          fg: AppColors.statusDraftText,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusStyle = _getStatusStyle(post.status);
    final categoryColors = AppColors.getCategoryColors(post.categoryName);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusStyle.bg,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      post.status.toUpperCase(),
                      style: AppTextStyles.chip.copyWith(
                        color: statusStyle.fg,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_horiz_rounded, size: 20),
                    padding: EdgeInsets.zero,
                    onSelected: (value) {
                      if (value == 'edit') onEdit();
                      if (value == 'delete') onDelete();
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 18),
                            SizedBox(width: 8),
                            Text('Edit Post'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 18, color: AppColors.statusDanger),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: AppColors.statusDanger)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              // Post Title: Playfair Display serif per THEME.md
              Text(
                post.title,
                style: AppTextStyles.postCardTitle.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              // Excerpt: DM Sans
              Text(
                post.excerpt,
                style: AppTextStyles.postCardExcerpt.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  // Category Pill matching THEME.md Category palette
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: categoryColors.bg,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      post.categoryName,
                      style: AppTextStyles.chip.copyWith(
                        color: categoryColors.text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.remove_red_eye_outlined,
                    size: 14,
                    color: isDark ? AppColors.iconDark : AppColors.iconLight,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${post.viewsCount}',
                    style: AppTextStyles.monoStats.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 14,
                    color: isDark ? AppColors.iconDark : AppColors.iconLight,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${post.commentsCount}',
                    style: AppTextStyles.monoStats.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    DateFormatter.formatShortDate(post.updatedAt),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isDark ? AppColors.textHintDark : AppColors.textHintLight,
                    ),
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
