import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../features/posts/models/post_model.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Reusable card that renders a [PostModel] in list/grid views.
/// Direct implementation of BlogHub THEME.md Section 6.
class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onTap;
  final VoidCallback? onEditTap;
  final VoidCallback? onDeleteTap;
  final bool showActions;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onEditTap,
    this.onDeleteTap,
    this.showActions = true,
  });

  // ---------------------------------------------------------------------------
  // Status badge style (THEME.md Section 3 & 6)
  // ---------------------------------------------------------------------------
  ({Color bg, Color fg, IconData icon}) get _statusStyle {
    switch (post.status.toLowerCase()) {
      case 'published':
      case 'approved':
        return (
          bg: AppColors.statusSuccessBg,
          fg: AppColors.statusSuccessText,
          icon: Icons.check_circle_rounded,
        );
      case 'pending':
      case 'in_review':
        return (
          bg: AppColors.statusWarningBg,
          fg: AppColors.statusWarningText,
          icon: Icons.access_time_rounded,
        );
      case 'rejected':
        return (
          bg: AppColors.statusDangerBg,
          fg: AppColors.statusDangerText,
          icon: Icons.error_outline_rounded,
        );
      case 'draft':
      default:
        return (
          bg: AppColors.statusDraftBg,
          fg: AppColors.statusDraftText,
          icon: Icons.edit_note_rounded,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final status = _statusStyle;

    return Card(
      elevation: 0,
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
              // ---------------------------------------------------------------
              // Row 1: category chip + status badge + overflow menu
              // ---------------------------------------------------------------
              Row(
                children: [
                  _CategoryChip(label: post.category),
                  const SizedBox(width: AppSpacing.sm),
                  _StatusBadge(
                    label: post.status.toUpperCase(),
                    bg: status.bg,
                    fg: status.fg,
                    icon: status.icon,
                  ),
                  const Spacer(),
                  if (showActions && onEditTap != null)
                    _IconBtn(
                      icon: Icons.edit_outlined,
                      tooltip: 'Edit post',
                      onTap: onEditTap!,
                      color: cs.onSurfaceVariant,
                    ),
                  if (showActions && onDeleteTap != null) ...[
                    const SizedBox(width: AppSpacing.xs),
                    _IconBtn(
                      icon: Icons.delete_outline_rounded,
                      tooltip: 'Delete post',
                      onTap: onDeleteTap!,
                      color: AppColors.statusDanger,
                    ),
                  ],
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // ---------------------------------------------------------------
              // Row 2: Post title (Playfair Display per THEME.md Section 6)
              // ---------------------------------------------------------------
              Text(
                post.title,
                style: AppTextStyles.postCardTitle.copyWith(
                  color: cs.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppSpacing.xs + 2),

              // ---------------------------------------------------------------
              // Row 3: Excerpt (DM Sans per THEME.md)
              // ---------------------------------------------------------------
              Text(
                post.excerpt,
                style: AppTextStyles.postCardExcerpt.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppSpacing.md),

              // ---------------------------------------------------------------
              // Row 4: Tags
              // ---------------------------------------------------------------
              if (post.tags.isNotEmpty)
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: post.tags
                      .take(3)
                      .map((t) => _TagChip(label: t))
                      .toList(),
                ),

              if (post.tags.isNotEmpty)
                const SizedBox(height: AppSpacing.md),

              // ---------------------------------------------------------------
              // Row 5: Stats + date (IBM Plex Mono & DM Sans)
              // ---------------------------------------------------------------
              Row(
                children: [
                  if (post.status.toLowerCase() == 'published' ||
                      post.status.toLowerCase() == 'approved') ...[
                    _StatItem(
                      icon: Icons.visibility_outlined,
                      label: _formatCount(post.views),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    _StatItem(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: _formatCount(post.commentsCount),
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  const Spacer(),
                  Text(
                    DateFormat('MMM d, yyyy').format(post.updatedAt),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: cs.onSurfaceVariant,
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

  String _formatCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }
}

// -----------------------------------------------------------------------------
// Sub-widgets
// -----------------------------------------------------------------------------

class _CategoryChip extends StatelessWidget {
  final String label;
  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.getCategoryColors(label);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        label,
        style: AppTextStyles.chip.copyWith(
          color: colors.text,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  final IconData icon;
  const _StatusBadge({
    required this.label,
    required this.bg,
    required this.fg,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: fg),
          const SizedBox(width: 3),
          Text(
            label,
            style: AppTextStyles.chip.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: Text(
        '#$label',
        style: AppTextStyles.labelSmall.copyWith(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: cs.onSurfaceVariant),
        const SizedBox(width: 3),
        Text(
          label,
          style: AppTextStyles.monoStats.copyWith(
            color: cs.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color color;

  const _IconBtn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Icon(icon, size: AppSpacing.iconSm + 2, color: color),
      ),
    );
  }
}
